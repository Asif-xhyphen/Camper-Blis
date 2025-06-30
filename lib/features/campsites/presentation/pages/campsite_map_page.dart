import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../shared/constants/dimensions.dart';
import '../../../../shared/constants/strings.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../controllers/filter_controller.dart';
import '../controllers/flutter_map_controller.dart';
import '../controllers/campsite_controller.dart';
import '../widgets/campsite_card.dart';
import '../../domain/entities/campsite.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/web_filter_bar.dart';
import 'campsite_list_page.dart';

class CampsiteMapPage extends ConsumerStatefulWidget {
  const CampsiteMapPage({super.key});

  @override
  ConsumerState<CampsiteMapPage> createState() => _CampsiteMapPageState();
}

class _CampsiteMapPageState extends ConsumerState<CampsiteMapPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _horizontalScrollController = ScrollController();
  String _searchQuery = '';

  late AnimationController _animationController;
  late AnimationController _typingAnimationController;
  late AnimationController _listAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderAnimation;
  late Animation<double> _shadowAnimation;
  late Animation<double> _typingAnimation;
  late Animation<double> _listSlideAnimation;

  bool _isSearchFocused = false;
  bool _isTyping = false;

  late final MapController _mapController;
  late final PopupController _popupController;

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
    _popupController = PopupController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(campsiteControllerProvider.notifier).loadCampsites();
      ref
          .read(flutterMapControllerProvider.notifier)
          .setMapController(_mapController, _popupController);
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _listAnimationController.forward();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _borderAnimation = ColorTween(
      begin: AppColors.border,
      end: AppColors.primaryGreen,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _shadowAnimation = Tween<double>(begin: 8.0, end: 16.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _typingAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _listSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _listAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });

      if (_isSearchFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _horizontalScrollController.dispose();
    _animationController.dispose();
    _typingAnimationController.dispose();
    _listAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(flutterMapControllerProvider);
    final campsiteState = ref.watch(campsiteControllerProvider);
    final hasActiveFilters = ref.watch(hasActiveFiltersProvider);
    final activeFilterCount = ref.watch(activeFilterCountProvider);

    ref.listen<FlutterMapState>(flutterMapControllerProvider, (previous, next) {
      if (previous?.isPopupVisible != next.isPopupVisible) {
        if (next.isPopupVisible) {
          _listAnimationController.reverse();
        } else {
          _listAnimationController.forward();
        }
      }
    });

    return Scaffold(
      body: PopupScope(
        popupController: _popupController,
        child: GestureDetector(
          onTap: () {
            _searchFocusNode.unfocus();
          },
          child: Stack(
            children: [
              // Flutter Map
              _buildFlutterMap(mapState, campsiteState),

              // Loading overlay
              if (campsiteState.isLoading)
                Container(
                  color: Colors.black26,
                  child: const Center(child: LoadingWidget()),
                ),

              Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    _buildSearchOverlay(),
                    // _buildFilterChips(
                    //   context,
                    //   hasActiveFilters,
                    //   activeFilterCount,
                    // ),
                    if (ResponsiveLayout.isDesktop(context))
                      const WebFilterBar(),
                  ],
                ),
              ),

              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _listSlideAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, (1 - _listSlideAnimation.value) * 200),
                      child: Opacity(
                        opacity: _listSlideAnimation.value,
                        child: _buildCampsiteList(
                          campsiteState,
                          mapState,
                          _searchQuery,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  Widget _buildCampsiteList(
    CampsiteState state,
    FlutterMapState mapState,
    String searchQuery,
  ) {
    if (state.isLoading && state.campsites.isEmpty) {
      return const Center(
        child: LoadingWidget(message: 'Loading campsites...'),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: AppErrorWidget(
          message: state.errorMessage!,
          onRetry: () {
            ref.read(campsiteControllerProvider.notifier).loadCampsites();
          },
        ),
      );
    }

    final filteredCampsites =
        state.filteredCampsites.where((campsite) {
          if (searchQuery.isEmpty) return true;
          return campsite.matchesSearchTerm(searchQuery);
        }).toList();

    if (filteredCampsites.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildMobileList(filteredCampsites, mapState.selectedCampsiteId);
  }

  Widget _buildMobileList(
    List<Campsite> campsites,
    String? selectedCampsiteId,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _horizontalScrollController,
      child: Row(
        children:
            campsites.map((campsite) {
              final isSelected = selectedCampsiteId == campsite.id;
              return HorizontalCampsiteCard(
                campsite: campsite,
                isSelected: isSelected,
                onTap: () {
                  ref
                      .read(flutterMapControllerProvider.notifier)
                      .selectCampsite(
                        campsite.id,
                        LatLng(
                          campsite.geoLocation.latitude,
                          campsite.geoLocation.longitude,
                        ),
                      );
                  context.go('/map/campsite/${campsite.id}');
                },
              );
            }).toList(),
      ),
    );
  }

  Widget _buildFlutterMap(
    FlutterMapState mapState,
    CampsiteState campsiteState,
  ) {
    if (campsiteState.errorMessage != null) {
      return Center(
        child: AppErrorWidget(
          message: campsiteState.errorMessage ?? Strings.genericError,
          onRetry:
              () =>
                  ref.read(campsiteControllerProvider.notifier).loadCampsites(),
        ),
      );
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: mapState.initialCenter,
        initialZoom: mapState.initialZoom,
        maxZoom: 18,
        minZoom: 3,
        onTap: (tapPosition, point) {
          ref.read(flutterMapControllerProvider.notifier).clearSelection();
        },
        onPositionChanged: (position, hasGesture) {
          if (hasGesture) {
            ref.read(flutterMapControllerProvider.notifier).onZoomChanged();
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.camper_blis',
          tileProvider: CancellableNetworkTileProvider(),
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            spiderfyCircleRadius: 80,
            spiderfySpiralDistanceMultiplier: 2,
            circleSpiralSwitchover: 12,
            maxClusterRadius: 120,
            rotate: false,
            size: const Size(40, 40),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(50),
            maxZoom: 15,
            markers: mapState.markers,
            polygonOptions: const PolygonOptions(
              borderColor: Colors.blueAccent,
              color: Colors.black12,
              borderStrokeWidth: 3,
            ),
            popupOptions: PopupOptions(
              popupSnap: PopupSnap.markerTop,
              popupController: _popupController,
              popupBuilder: (context, marker) {
                return ref
                    .read(flutterMapControllerProvider.notifier)
                    .buildPopupForMarker(context, marker);
              },
            ),
            builder: (context, markers) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    markers.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedCampsiteCard(Campsite? campsite) {
    if (campsite == null) return const SizedBox.shrink();

    return Positioned(
      left: Dimensions.paddingM,
      right: Dimensions.paddingM,
      bottom: Dimensions.paddingM,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(Dimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CompactCampsiteCard(
          campsite: campsite,
          onTap: () => context.go('/map/campsite/${campsite.id}'),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "toggle_clustering",
          mini: true,
          onPressed: () {
            ref.read(flutterMapControllerProvider.notifier).toggleClustering();
          },
          backgroundColor: AppColors.surfaceWhite,
          foregroundColor: AppColors.textPrimary,
          child: Icon(
            ref.watch(flutterMapControllerProvider).showClustering
                ? Icons.scatter_plot
                : Icons.apps,
          ),
        ),
        const SizedBox(height: Dimensions.spaceS),
        FloatingActionButton(
          heroTag: "zoom_in",
          mini: true,
          onPressed:
              () => ref.read(flutterMapControllerProvider.notifier).zoomIn(),
          backgroundColor: AppColors.surfaceWhite,
          foregroundColor: AppColors.textPrimary,
          child: const Icon(Icons.zoom_in),
        ),
        const SizedBox(height: Dimensions.spaceS),
        FloatingActionButton(
          heroTag: "zoom_out",
          mini: true,
          onPressed:
              () => ref.read(flutterMapControllerProvider.notifier).zoomOut(),
          backgroundColor: AppColors.surfaceWhite,
          foregroundColor: AppColors.textPrimary,
          child: const Icon(Icons.zoom_out),
        ),
      ],
    );
  }

  Widget _buildSearchOverlay() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.all(Dimensions.paddingM),
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingM,
              vertical: Dimensions.paddingS,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(Dimensions.radiusL),
              border: Border.all(
                color: _borderAnimation.value ?? AppColors.border,
                width: _isSearchFocused ? 2.0 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      _isSearchFocused
                          ? AppColors.primaryGreen.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                  blurRadius: _shadowAnimation.value,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _typingAnimationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale:
                          _isTyping
                              ? 1.0 + (_typingAnimation.value * 0.1)
                              : 1.0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.search,
                          color:
                              _isSearchFocused
                                  ? AppColors.primaryGreen
                                  : AppColors.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: Dimensions.spaceS),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: const InputDecoration(
                      hintText: Strings.searchCampsites,
                      border: InputBorder.none,
                      isDense: true,
                      filled: false,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                        _isTyping = query.isNotEmpty;
                      });

                      if (query.isNotEmpty) {
                        _typingAnimationController.repeat(reverse: true);
                      } else {
                        _typingAnimationController.stop();
                        _typingAnimationController.reset();
                      }
                    },
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  AnimatedScale(
                    scale: _searchQuery.isNotEmpty ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 150),
                    child: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.surfaceWhite,
                          size: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _buildFilterChips(
  //   BuildContext context,
  //   bool hasActiveFilters,
  //   int activeFilterCount,
  // ) {
  //   return Container(
  //     margin: const EdgeInsets.only(
  //       left: Dimensions.paddingM,
  //       right: Dimensions.paddingM,
  //       bottom: Dimensions.spaceS,
  //     ),
  //     child: Wrap(
  //       spacing: Dimensions.spaceS,
  //       children: [
  //         FilterChipButton(
  //           icon: Icons.calendar_today,
  //           label: 'Dates',
  //           onTap: () {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(content: Text('Date picker coming soon!')),
  //             );
  //           },
  //         ),
  //         FilterChipButton(
  //           icon: Icons.people,
  //           label: 'Guests',
  //           onTap: () {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(content: Text('Guest picker coming soon!')),
  //             );
  //           },
  //         ),
  //         FilterChipButton(
  //           icon: Icons.tune,
  //           label:
  //               hasActiveFilters ? 'Filters ($activeFilterCount)' : 'Filters',
  //           isActive: hasActiveFilters,
  //           onTap: () => showFilterBottomSheet(context),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
