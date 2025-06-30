import 'dart:ui';
import 'package:camper_blis/features/campsites/domain/entities/campsite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/text_styles.dart';
import '../controllers/campsite_controller.dart';
import '../controllers/filter_controller.dart';
import '../widgets/campsite_card.dart';
import '../widgets/campsite_card_unified.dart';
import '../widgets/campsite_filter_components.dart';
import '../widgets/campsite_grid_layout.dart';
import '../widgets/campsite_header.dart';
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

class _CampsiteListPageState extends ConsumerState<CampsiteListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campsiteState = ref.watch(campsiteControllerProvider);

    return ResponsiveLayout(
      mobile: _buildMobileLayout(campsiteState),
      desktop: _buildWebLayout(campsiteState),
    );
  }

  // Event Handlers
  void _handleSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _handleSearchClear() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  Widget _buildMobileLayout(campsiteState) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: CustomScrollView(
        slivers: [
          CampsiteHeader(
            searchController: _searchController,
            searchQuery: _searchQuery,
            onSearchChanged: _handleSearchChanged,
            onSearchClear: _handleSearchClear,
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildFilterChips(),
                if (_searchQuery.isNotEmpty)
                  _buildSearchResults(campsiteState, _searchQuery)
                else ...[
                  _buildFeaturedCampsites(campsiteState),
                  _buildAllCampsites(campsiteState),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebLayout(campsiteState) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Column(
        children: [
          CampsiteHeader(
            searchController: _searchController,
            searchQuery: _searchQuery,
            onSearchChanged: _handleSearchChanged,
            onSearchClear: _handleSearchClear,
          ),
          Expanded(
            child: ResponsiveConstraints(
              child: Row(
                children: [
                  // Sidebar with filters
                  Container(
                    width: 280,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border(
                        right: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: const CampsiteFilterSidebar(),
                  ),
                  // Main content area
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.all(24),
                          sliver: SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_searchQuery.isNotEmpty)
                                  _buildWebSearchResults(campsiteState)
                                else ...[
                                  _buildWebFeaturedSection(campsiteState),
                                  const SizedBox(height: 32),
                                  _buildWebAllCampsites(campsiteState),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filterState = ref.watch(filterControllerProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              'Nearby',
              Icons.location_on,
              isSelected: true,
              onTap: () {},
            ),
            const SizedBox(width: 12),
            _buildFilterChip(
              'Lakeside',
              Icons.water_drop,
              isSelected: filterState.isCloseToWater == true,
              onTap: () {
                final newValue =
                    filterState.isCloseToWater == true ? null : true;
                ref
                    .read(filterControllerProvider.notifier)
                    .updateWaterProximity(newValue);
                ref
                    .read(campsiteControllerProvider.notifier)
                    .applyFilters(ref.read(filterControllerProvider));
              },
            ),
            const SizedBox(width: 12),
            _buildFilterChip(
              'Campfire',
              Icons.local_fire_department,
              isSelected: filterState.isCampFireAllowed == true,
              onTap: () {
                final newValue =
                    filterState.isCampFireAllowed == true ? null : true;
                ref
                    .read(filterControllerProvider.notifier)
                    .updateCampfireAllowed(newValue);
                ref
                    .read(campsiteControllerProvider.notifier)
                    .applyFilters(ref.read(filterControllerProvider));
              },
            ),
            const SizedBox(width: 12),
            _buildFilterChip(
              'More',
              Icons.tune,
              isSelected: ref.watch(hasActiveFiltersProvider),
              onTap: () => showFilterBottomSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    IconData icon, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCampsites(CampsiteState state) {
    if (state.campsites.isEmpty) return const SizedBox.shrink();

    final featuredCampsites =
        state.filteredCampsites
            .take(ResponsiveLayout.isDesktop(context) ? 6 : 8)
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Campsites',
                style: AppTextStyles.headingMedium.copyWith(fontSize: 20),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See all',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (ResponsiveLayout.isDesktop(context))
          CampsiteGridLayout(
            campsites: featuredCampsites,
            onCampsiteSelected: _navigateToCampsiteDetail,
            layout: CampsiteCardLayout.grid,
            padding: const EdgeInsets.symmetric(horizontal: 20),
          )
        else
          SizedBox(
            height: 320,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 20),
              scrollDirection: Axis.horizontal,
              itemCount: featuredCampsites.length,
              itemBuilder: (context, index) {
                final campsite = featuredCampsites[index];
                return CampsiteCardUnified(
                  campsite: campsite,
                  layout: CampsiteCardLayout.featured,
                  onTap: () => _navigateToCampsiteDetail(campsite.id),
                );
              },
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAllCampsites(CampsiteState state) {
    if (state.campsites.isEmpty) return const SizedBox.shrink();

    final allCampsites = state.filteredCampsites;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Text(
            ResponsiveLayout.isDesktop(context)
                ? 'All Campsites (${allCampsites.length})'
                : 'All Campsites',
            style:
                ResponsiveLayout.isDesktop(context)
                    ? AppTextStyles.headingLarge.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    )
                    : AppTextStyles.headingMedium.copyWith(fontSize: 20),
          ),
        ),
        CampsiteGridLayout(
          campsites: allCampsites,
          onCampsiteSelected: _navigateToCampsiteDetail,
          layout: CampsiteCardLayout.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSearchResults(CampsiteState state, String searchQuery) {
    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: LoadingWidget(message: 'Searching campsites...')),
      );
    }

    if (state.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: AppErrorWidget(
            message: state.errorMessage!,
            onRetry: () {
              ref.read(campsiteControllerProvider.notifier).loadCampsites();
            },
          ),
        ),
      );
    }

    final filteredCampsites =
        state.filteredCampsites.where((campsite) {
          return campsite.matchesSearchTerm(searchQuery);
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Text(
            'Search Results (${filteredCampsites.length})',
            style: AppTextStyles.headingMedium.copyWith(fontSize: 20),
          ),
        ),
        if (filteredCampsites.isEmpty)
          _buildEmptySearchState(searchQuery)
        else
          CampsiteGridLayout(
            campsites: filteredCampsites,
            onCampsiteSelected: _navigateToCampsiteDetail,
            layout:
                ResponsiveLayout.isDesktop(context)
                    ? CampsiteCardLayout.grid
                    : CampsiteCardLayout.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEmptySearchState(String searchQuery) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No campsites found for "$searchQuery"',
              style: AppTextStyles.headingSmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms or browse our recommendations below',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Clear Search',
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCampsiteDetail(String campsiteId) {
    context.go('/campsite-list/campsite/$campsiteId');
  }

  Widget _buildWebSearchResults(CampsiteState campsiteState) {
    final filteredCampsites =
        campsiteState.campsites.where((campsite) {
          return campsite.matchesSearchTerm(_searchQuery);
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Results (${filteredCampsites.length})',
          style: AppTextStyles.headingLarge.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        if (filteredCampsites.isEmpty)
          _buildEmptySearchState(_searchQuery)
        else
          _buildWebCampsiteGrid(filteredCampsites),
      ],
    );
  }

  Widget _buildWebFeaturedSection(campsiteState) {
    if (campsiteState.campsites.isEmpty) return const SizedBox.shrink();

    final featuredCampsites = campsiteState.filteredCampsites.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Campsites',
              style: AppTextStyles.headingLarge.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See all featured',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildWebCampsiteGrid(featuredCampsites),
      ],
    );
  }

  Widget _buildWebAllCampsites(campsiteState) {
    if (campsiteState.campsites.isEmpty) return const SizedBox.shrink();

    final allCampsites = campsiteState.filteredCampsites;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Campsites (${allCampsites.length})',
          style: AppTextStyles.headingLarge.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        _buildWebCampsiteGrid(allCampsites),
      ],
    );
  }

  Widget _buildWebCampsiteGrid(List<dynamic> campsites) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / 400).floor().clamp(1, 3);
        final itemWidth = (constraints.maxWidth - (columns - 1) * 24) / columns;

        return Wrap(
          spacing: 24,
          runSpacing: 24,
          children:
              campsites.map((campsite) {
                return SizedBox(
                  width: itemWidth,
                  child: _buildWebCampsiteCard(campsite),
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildWebCampsiteCard(dynamic campsite) {
    return GestureDetector(
      onTap: () => _navigateToCampsiteDetail(campsite.id),
      child: Container(
        height: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.network(
                  campsite.photo.replaceFirst('http://', 'https://'),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.border,
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSecondary,
                        size: 48,
                      ),
                    );
                  },
                ),
              ),
              // Favorite Button
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              // Bottom Content Overlay
              Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title and Price Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                campsite.label,
                                style: AppTextStyles.headingMedium.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              campsite.formattedPrice,
                              style: AppTextStyles.headingMedium.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Location Row
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'National Park',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Rating Row
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.9',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(2.8k)',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
