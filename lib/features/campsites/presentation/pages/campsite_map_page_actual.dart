// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:go_router/go_router.dart';

// import '../../../../shared/constants/dimensions.dart';
// import '../../../../shared/constants/strings.dart';
// import '../../../../shared/theme/colors.dart';
// import '../../../../shared/widgets/error_widget.dart';
// import '../../../../shared/widgets/loading_widget.dart';
// import '../../../../shared/widgets/responsive_layout.dart';
// import '../controllers/filter_controller.dart';
// import '../controllers/map_controller.dart';
// import '../controllers/campsite_controller.dart';
// import '../widgets/campsite_card.dart';
// import '../../domain/entities/campsite.dart';
// import '../widgets/filter_bottom_sheet.dart';
// import '../widgets/web_filter_bar.dart';
// import 'campsite_list_page.dart';

// class CampsiteMapPage extends ConsumerStatefulWidget {
//   const CampsiteMapPage({super.key});

//   @override
//   ConsumerState<CampsiteMapPage> createState() => _CampsiteMapPageState();
// }

// class _CampsiteMapPageState extends ConsumerState<CampsiteMapPage>
//     with TickerProviderStateMixin {
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();
//   final ScrollController _horizontalScrollController = ScrollController();
//   String _searchQuery = '';

//   late AnimationController _animationController;
//   late AnimationController _typingAnimationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<Color?> _borderAnimation;
//   late Animation<double> _shadowAnimation;
//   late Animation<double> _typingAnimation;

//   bool _isSearchFocused = false;
//   bool _isTyping = false;

//   @override
//   void initState() {
//     super.initState();

//     // Load campsites when page initializes
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(campsiteControllerProvider.notifier).loadCampsites();
//     });

//     // Initialize animations
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );

//     _typingAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _borderAnimation = ColorTween(
//       begin: AppColors.border,
//       end: AppColors.primaryGreen,
//     ).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _shadowAnimation = Tween<double>(begin: 8.0, end: 16.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _typingAnimationController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     // Listen to focus changes
//     _searchFocusNode.addListener(() {
//       setState(() {
//         _isSearchFocused = _searchFocusNode.hasFocus;
//       });

//       if (_isSearchFocused) {
//         _animationController.forward();
//       } else {
//         _animationController.reverse();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _searchFocusNode.dispose();
//     _horizontalScrollController.dispose();
//     _animationController.dispose();
//     _typingAnimationController.dispose();
//     super.dispose();
//   }

//   Completer<GoogleMapController> _mapController = Completer();

//   @override
//   Widget build(BuildContext context) {
//     final mapState = ref.watch(mapControllerProvider);
//     final campsiteState = ref.watch(campsiteControllerProvider);
//     final hasActiveFilters = ref.watch(hasActiveFiltersProvider);
//     final activeFilterCount = ref.watch(activeFilterCountProvider);

//     return Scaffold(
//       body: GestureDetector(
//         onTap: () {
//           _searchFocusNode.unfocus();
//         },
//         child: Stack(
//           children: [
//             // Google Map
//             _buildGoogleMap(mapState, campsiteState),

//             // Loading overlay
//             if (campsiteState.isLoading)
//               Container(
//                 color: Colors.black26,
//                 child: const Center(child: LoadingWidget()),
//               ),

//             // Selected campsite card at bottom
//             if (mapState.selectedCampsiteId != null)
//               _buildSelectedCampsiteCard(
//                 _getSelectedCampsite(
//                   campsiteState,
//                   mapState.selectedCampsiteId!,
//                 ),
//               ),

//             Positioned(
//               top: MediaQuery.of(context).padding.top,
//               left: 0,
//               right: 0,
//               child: Column(
//                 children: [
//                   _buildSearchOverlay(),
//                   _buildFilterChips(
//                     context,
//                     hasActiveFilters,
//                     activeFilterCount,
//                   ),
//                   // Web filter bar for larger screens
//                   if (ResponsiveLayout.isDesktop(context)) const WebFilterBar(),
//                 ],
//               ),
//             ),

//             Positioned(
//               bottom: 10,
//               left: 0,
//               right: 0,
//               child: _buildCampsiteList(campsiteState, mapState, _searchQuery),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: _buildFloatingActionButtons(),
//     );
//   }

//   Widget _buildCampsiteList(
//     CampsiteState state,
//     MapState mapState,
//     String searchQuery,
//   ) {
//     if (state.isLoading && state.campsites.isEmpty) {
//       return const Center(
//         child: LoadingWidget(message: 'Loading campsites...'),
//       );
//     }

//     if (state.errorMessage != null) {
//       return Center(
//         child: AppErrorWidget(
//           message: state.errorMessage!,
//           onRetry: () {
//             ref.read(campsiteControllerProvider.notifier).loadCampsites();
//           },
//         ),
//       );
//     }

//     // Filter campsites by search query
//     final filteredCampsites =
//         state.filteredCampsites.where((campsite) {
//           if (searchQuery.isEmpty) return true;
//           return campsite.matchesSearchTerm(searchQuery);
//         }).toList();

//     if (filteredCampsites.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return _buildMobileList(filteredCampsites, mapState.selectedCampsiteId);
//   }

//   Widget _buildMobileList(
//     List<Campsite> campsites,
//     String? selectedCampsiteId,
//   ) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       controller: _horizontalScrollController,
//       child: Row(
//         children:
//             campsites.map((campsite) {
//               final isSelected = selectedCampsiteId == campsite.id;
//               return HorizontalCampsiteCard(
//                 campsite: campsite,
//                 isSelected: isSelected,
//                 onTap: () {
//                   // Select campsite when tapped from list
//                   ref
//                       .read(mapControllerProvider.notifier)
//                       .selectCampsite(campsite.id);
//                   _animateToLocation(
//                     LatLng(
//                       campsite.geoLocation.latitude,
//                       campsite.geoLocation.longitude,
//                     ),
//                   );
//                   _navigateToCampsiteDetail(campsite);
//                 },
//               );
//             }).toList(),
//       ),
//     );
//   }

//   Campsite? _getSelectedCampsite(CampsiteState state, String campsiteId) {
//     try {
//       return state.filteredCampsites.firstWhere((c) => c.id == campsiteId);
//     } catch (e) {
//       return null;
//     }
//   }

//   Widget _buildGoogleMap(MapState mapState, CampsiteState campsiteState) {
//     if (campsiteState.errorMessage != null) {
//       return Center(
//         child: AppErrorWidget(
//           message: campsiteState.errorMessage ?? Strings.genericError,
//           onRetry:
//               () =>
//                   ref.read(campsiteControllerProvider.notifier).loadCampsites(),
//         ),
//       );
//     }

//     return GoogleMap(
//       onMapCreated: (GoogleMapController controller) {
//         _mapController.complete(controller);
//         ref.read(mapControllerProvider.notifier).setMapController(controller);
//       },
//       initialCameraPosition: mapState.initialCameraPosition,
//       markers: _buildMarkers(campsiteState.filteredCampsites),
//       onTap: (LatLng position) {
//         // Clear selection when tapping empty area
//         ref.read(mapControllerProvider.notifier).clearSelection();
//       },
//       myLocationEnabled: true,
//       myLocationButtonEnabled: false, // We have custom button
//       zoomControlsEnabled: false, // We have custom controls
//       mapToolbarEnabled: false,
//       compassEnabled: true,
//       rotateGesturesEnabled: true,
//       scrollGesturesEnabled: true,
//       tiltGesturesEnabled: true,
//       zoomGesturesEnabled: true,
//       mapType: mapState.mapType,
//     );
//   }

//   Set<Marker> _buildMarkers(List<Campsite> campsites) {
//     return campsites.map((campsite) {
//       return Marker(
//         markerId: MarkerId(campsite.id),
//         position: LatLng(
//           campsite.geoLocation.latitude,
//           campsite.geoLocation.longitude,
//         ),
//         infoWindow: InfoWindow(
//           title: campsite.label,
//           snippet: '€${campsite.pricePerNight}/night',
//         ),
//         onTap: () {
//           ref.read(mapControllerProvider.notifier).selectCampsite(campsite.id);
//           _animateToLocation(
//             LatLng(
//               campsite.geoLocation.latitude,
//               campsite.geoLocation.longitude,
//             ),
//           );
//           _scrollToCampsiteItem(campsite.id, campsites);
//         },
//         icon: _getMarkerIcon(campsite),
//       );
//     }).toSet();
//   }

//   BitmapDescriptor _getMarkerIcon(Campsite campsite) {
//     // Using available hue colors from Google Maps
//     return BitmapDescriptor.defaultMarkerWithHue(
//       campsite.pricePerNight > 40
//           ? BitmapDescriptor.hueOrange
//           : BitmapDescriptor.hueGreen,
//     );
//   }

//   Widget _buildSelectedCampsiteCard(Campsite? campsite) {
//     if (campsite == null) return const SizedBox.shrink();

//     return Positioned(
//       left: Dimensions.paddingM,
//       right: Dimensions.paddingM,
//       bottom: Dimensions.paddingM,
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColors.surfaceWhite,
//           borderRadius: BorderRadius.circular(Dimensions.radiusL),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: CompactCampsiteCard(
//           campsite: campsite,
//           onTap: () => _navigateToCampsiteDetail(campsite),
//         ),
//       ),
//     );
//   }

//   Widget _buildFloatingActionButtons() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         FloatingActionButton(
//           heroTag: "zoom_in",
//           mini: true,
//           onPressed: () => _zoomIn(),
//           backgroundColor: AppColors.surfaceWhite,
//           foregroundColor: AppColors.textPrimary,
//           child: const Icon(Icons.zoom_in),
//         ),
//         const SizedBox(height: Dimensions.spaceS),
//         FloatingActionButton(
//           heroTag: "zoom_out",
//           mini: true,
//           onPressed: () => _zoomOut(),
//           backgroundColor: AppColors.surfaceWhite,
//           foregroundColor: AppColors.textPrimary,
//           child: const Icon(Icons.zoom_out),
//         ),
//         const SizedBox(height: Dimensions.spaceL),
//         FloatingActionButton(
//           heroTag: "list_view",
//           onPressed: () => _navigateToListView(),
//           backgroundColor: AppColors.primaryGreen,
//           foregroundColor: AppColors.textOnPrimary,
//           child: const Icon(Icons.list),
//         ),
//       ],
//     );
//   }

//   Future<void> _moveToCurrentLocation() async {
//     // TODO: Implement location services
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Location services coming soon!')),
//     );
//   }

//   Future<void> _animateToLocation(LatLng location) async {
//     final controller = await _mapController.future;
//     await controller.animateCamera(CameraUpdate.newLatLngZoom(location, 15.0));
//   }

//   Future<void> _zoomIn() async {
//     final controller = await _mapController.future;
//     await controller.animateCamera(CameraUpdate.zoomIn());
//   }

//   Future<void> _zoomOut() async {
//     final controller = await _mapController.future;
//     await controller.animateCamera(CameraUpdate.zoomOut());
//   }

//   void _showFilterOptions() {
//     // TODO: Implement filter bottom sheet integration
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Filter options coming soon!')),
//     );
//   }

//   void _navigateToCampsiteDetail(Campsite campsite) {
//     // Navigate to detail page using GoRouter
//     context.go('/campsite/${campsite.id}');
//   }

//   void _navigateToListView() {
//     // Switch to list view tab (index 0) in bottom navigation
//     // This will be handled by the parent navigation widget
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Switch to Home tab to see list view')),
//     );
//   }

//   /// Scroll horizontal list to the selected campsite item
//   void _scrollToCampsiteItem(String campsiteId, List<Campsite> campsites) {
//     final index = campsites.indexWhere((campsite) => campsite.id == campsiteId);
//     if (index != -1) {
//       // Calculate the offset to scroll to the item
//       // Each card is approximately 220px wide (200px + margins)
//       const double cardWidth = 220.0;
//       final double targetOffset = index * cardWidth;

//       // Scroll to the target position with animation
//       _horizontalScrollController.animateTo(
//         targetOffset,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   Widget _buildSearchOverlay() {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _scaleAnimation.value,
//           child: Container(
//             margin: const EdgeInsets.all(Dimensions.paddingM),
//             padding: const EdgeInsets.symmetric(
//               horizontal: Dimensions.paddingM,
//               vertical: Dimensions.paddingS,
//             ),
//             decoration: BoxDecoration(
//               color: AppColors.surfaceWhite,
//               borderRadius: BorderRadius.circular(Dimensions.radiusL),
//               border: Border.all(
//                 color: _borderAnimation.value ?? AppColors.border,
//                 width: _isSearchFocused ? 2.0 : 1.0,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color:
//                       _isSearchFocused
//                           ? AppColors.primaryGreen.withOpacity(0.1)
//                           : Colors.black.withOpacity(0.1),
//                   blurRadius: _shadowAnimation.value,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 AnimatedBuilder(
//                   animation: _typingAnimationController,
//                   builder: (context, child) {
//                     return Transform.scale(
//                       scale:
//                           _isTyping
//                               ? 1.0 + (_typingAnimation.value * 0.1)
//                               : 1.0,
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 200),
//                         child: Icon(
//                           Icons.search,
//                           color:
//                               _isSearchFocused
//                                   ? AppColors.primaryGreen
//                                   : AppColors.textSecondary,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(width: Dimensions.spaceS),
//                 Expanded(
//                   child: TextField(
//                     controller: _searchController,
//                     focusNode: _searchFocusNode,
//                     decoration: const InputDecoration(
//                       hintText: Strings.searchCampsites,
//                       border: InputBorder.none,
//                       isDense: true,
//                       filled: false,
//                       enabledBorder: InputBorder.none,
//                       focusedBorder: InputBorder.none,
//                       errorBorder: InputBorder.none,
//                       disabledBorder: InputBorder.none,
//                     ),
//                     onChanged: (query) {
//                       setState(() {
//                         _searchQuery = query;
//                         _isTyping = query.isNotEmpty;
//                       });

//                       // Trigger typing animation
//                       if (query.isNotEmpty) {
//                         _typingAnimationController.repeat(reverse: true);
//                       } else {
//                         _typingAnimationController.stop();
//                         _typingAnimationController.reset();
//                       }
//                     },
//                   ),
//                 ),
//                 if (_searchQuery.isNotEmpty)
//                   AnimatedScale(
//                     scale: _searchQuery.isNotEmpty ? 1.0 : 0.0,
//                     duration: const Duration(milliseconds: 150),
//                     child: IconButton(
//                       onPressed: () {
//                         _searchController.clear();
//                         setState(() {
//                           _searchQuery = '';
//                         });
//                       },
//                       icon: Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: AppColors.textSecondary.withOpacity(0.8),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.close,
//                           color: AppColors.surfaceWhite,
//                           size: 12,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFilterChips(
//     BuildContext context,
//     bool hasActiveFilters,
//     int activeFilterCount,
//   ) {
//     return Container(
//       margin: const EdgeInsets.only(
//         left: Dimensions.paddingM,
//         right: Dimensions.paddingM,
//         bottom: Dimensions.spaceS,
//       ),
//       child: Wrap(
//         spacing: Dimensions.spaceS,
//         children: [
//           FilterChipButton(
//             icon: Icons.calendar_today,
//             label: 'Dates',
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Date picker coming soon!')),
//               );
//             },
//           ),
//           FilterChipButton(
//             icon: Icons.people,
//             label: 'Guests',
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Guest picker coming soon!')),
//               );
//             },
//           ),
//           FilterChipButton(
//             icon: Icons.tune,
//             label:
//                 hasActiveFilters ? 'Filters ($activeFilterCount)' : 'Filters',
//             isActive: hasActiveFilters,
//             onTap: () => showFilterBottomSheet(context),
//           ),
//         ],
//       ),
//     );
//   }
// }
