import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/text_styles.dart';
import '../controllers/campsite_controller.dart';
import '../controllers/filter_controller.dart';
import '../widgets/campsite_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/web_filter_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/constants/dimensions.dart';
import '../../../../shared/constants/strings.dart';

class CampsiteListPage extends ConsumerStatefulWidget {
  const CampsiteListPage({super.key});

  @override
  ConsumerState<CampsiteListPage> createState() => _CampsiteListPageState();
}

class _CampsiteListPageState extends ConsumerState<CampsiteListPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';

  late AnimationController _animationController;
  late AnimationController _typingAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderAnimation;
  late Animation<double> _shadowAnimation;
  late Animation<double> _typingAnimation;

  bool _isSearchFocused = false;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

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

    // Listen to focus changes
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
    _animationController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final campsiteState = ref.watch(campsiteControllerProvider);
    final hasActiveFilters = ref.watch(hasActiveFiltersProvider);
    final activeFilterCount = ref.watch(activeFilterCountProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(Strings.appName),
        foregroundColor: AppColors.surfaceWhite,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          _searchFocusNode.unfocus();
        },
        child: ResponsiveConstraints(
          child: Column(
            children: [
              _buildSearchOverlay(),
              _buildFilterChips(context, hasActiveFilters, activeFilterCount),
              if (ResponsiveLayout.isDesktop(context)) const WebFilterBar(),
              Expanded(child: _buildCampsiteList(campsiteState, _searchQuery)),
            ],
          ),
        ),
      ),
      floatingActionButton:
          ResponsiveLayout.isMobile(context) ||
                  ResponsiveLayout.isTablet(context)
              ? FloatingActionButton.extended(
                onPressed: () => showFilterBottomSheet(context),
                icon: Icon(
                  Icons.filter_list,
                  color:
                      hasActiveFilters
                          ? AppColors.primaryGreen
                          : AppColors.surfaceWhite,
                ),
                label: Text(
                  hasActiveFilters ? 'Filters ($activeFilterCount)' : 'Filter',
                  style: TextStyle(
                    color:
                        hasActiveFilters
                            ? AppColors.primaryGreen
                            : AppColors.surfaceWhite,
                  ),
                ),
                backgroundColor:
                    hasActiveFilters
                        ? AppColors.surfaceWhite
                        : AppColors.primaryGreen,
              )
              : null,
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

  Widget _buildFilterChips(
    BuildContext context,
    bool hasActiveFilters,
    int activeFilterCount,
  ) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(
        left: Dimensions.paddingM,
        right: Dimensions.paddingM,
        bottom: Dimensions.spaceS,
      ),
      child: Wrap(
        spacing: Dimensions.spaceS,
        children: [
          FilterChipButton(
            icon: Icons.calendar_today,
            label: 'Dates',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Date picker coming soon!')),
              );
            },
          ),
          FilterChipButton(
            icon: Icons.people,
            label: 'Guests',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Guest picker coming soon!')),
              );
            },
          ),
          FilterChipButton(
            icon: Icons.tune,
            label:
                hasActiveFilters ? 'Filters ($activeFilterCount)' : 'Filters',
            isActive: hasActiveFilters,
            onTap: () => showFilterBottomSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCampsiteList(CampsiteState state, String searchQuery) {
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
      return _buildEmptyState(searchQuery);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(campsiteControllerProvider.notifier).refreshCampsites();
      },
      child: ResponsiveLayout(
        mobile: _buildMobileList(filteredCampsites),
        desktop: _buildGridView(filteredCampsites),
      ),
    );
  }

  Widget _buildMobileList(List<dynamic> campsites) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: Dimensions.paddingS),
      itemCount: campsites.length,
      itemBuilder: (context, index) {
        final campsite = campsites[index];
        return CampsiteCard(
          campsite: campsite,
          onTap: () => _navigateToCampsiteDetail(campsite.id),
          isGridView: false,
        );
      },
    );
  }

  Widget _buildGridView(List<dynamic> campsites) {
    return GridView.builder(
      padding: const EdgeInsets.all(Dimensions.paddingM),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveLayout.getColumns(context),
        crossAxisSpacing: Dimensions.paddingM,
        mainAxisSpacing: Dimensions.paddingM,
        childAspectRatio: 0.75,
      ),
      itemCount: campsites.length,
      itemBuilder: (context, index) {
        final campsite = campsites[index];
        return CampsiteCard(
          campsite: campsite,
          onTap: () => _navigateToCampsiteDetail(campsite.id),
          isGridView: true,
        );
      },
    );
  }

  Widget _buildEmptyState(String searchQuery) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              searchQuery.isNotEmpty ? Icons.search_off : Icons.explore_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: Dimensions.spaceM),
            Text(
              searchQuery.isNotEmpty
                  ? 'No campsites found for "$searchQuery"'
                  : 'No campsites match your filters',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.spaceS),
            Text(
              searchQuery.isNotEmpty
                  ? 'Try adjusting your search terms or filters'
                  : 'Try adjusting your filter criteria',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.spaceL),
            if (ref.watch(hasActiveFiltersProvider))
              ElevatedButton(
                onPressed: () {
                  ref.read(filterControllerProvider.notifier).clearAllFilters();
                  ref.read(campsiteControllerProvider.notifier).clearFilters();
                },
                child: const Text('Clear Filters'),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToCampsiteDetail(String campsiteId) {
    context.go('/campsite-list/campsite/$campsiteId');
  }
}

class CompactCampsiteListView extends ConsumerWidget {
  const CompactCampsiteListView({
    super.key,
    required this.campsites,
    this.onCampsiteTap,
  });

  final List<dynamic> campsites;
  final Function(String)? onCampsiteTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (campsites.isEmpty) {
      return const Center(
        child: Text(
          'No campsites available',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      itemCount: campsites.length,
      itemBuilder: (context, index) {
        final campsite = campsites[index];
        return CompactCampsiteCard(
          campsite: campsite,
          onTap: () => onCampsiteTap?.call(campsite.id),
        );
      },
    );
  }
}

class CampsiteSearchBar extends StatefulWidget {
  const CampsiteSearchBar({
    super.key,
    this.onSearchChanged,
    this.initialValue = '',
  });

  final ValueChanged<String>? onSearchChanged;
  final String initialValue;

  @override
  State<CampsiteSearchBar> createState() => _CampsiteSearchBarState();
}

class _CampsiteSearchBarState extends State<CampsiteSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(Dimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search campsites...',
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon:
              _controller.text.isNotEmpty
                  ? IconButton(
                    onPressed: () {
                      _controller.clear();
                      widget.onSearchChanged?.call('');
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.textSecondary,
                    ),
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingM,
            vertical: Dimensions.paddingS,
          ),
        ),
      ),
    );
  }
}

class FilterChipButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const FilterChipButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isActive
                  ? AppColors.primaryGreen.withOpacity(0.08)
                  : AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive ? AppColors.primaryGreen : AppColors.border,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color:
                  isActive ? AppColors.primaryGreen : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color:
                    isActive ? AppColors.primaryGreen : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
