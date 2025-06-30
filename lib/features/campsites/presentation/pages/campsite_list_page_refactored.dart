import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Controllers
import '../controllers/campsite_controller.dart';
import '../controllers/filter_controller.dart';

// Widgets
import '../widgets/campsite_header.dart';
import '../widgets/campsite_search_bar.dart';
import '../widgets/campsite_card_unified.dart';
import '../widgets/campsite_grid_layout.dart';
import '../widgets/campsite_filter_components.dart';
import '../widgets/filter_bottom_sheet.dart';

// Shared
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';

class CampsiteListPageRefactored extends ConsumerStatefulWidget {
  const CampsiteListPageRefactored({super.key});

  @override
  ConsumerState<CampsiteListPageRefactored> createState() =>
      _CampsiteListPageRefactoredState();
}

class _CampsiteListPageRefactoredState
    extends ConsumerState<CampsiteListPageRefactored> {
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
      desktop: _buildDesktopLayout(campsiteState),
    );
  }

  // Mobile Layout
  Widget _buildMobileLayout(campsiteState) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: CustomScrollView(
        slivers: [
          // Use SliverAppBar directly for mobile to avoid Sliver issues
          SliverAppBar(
            expandedHeight: 350.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: _buildMobileHeaderBackground()),
                      const SizedBox(height: 85),
                    ],
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: CampsiteSearchBar(
                      controller: _searchController,
                      onChanged: _handleSearchChanged,
                      onClear: _handleSearchClear,
                      searchQuery: _searchQuery,
                      isFloating: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                CampsiteFilterChips(
                  onMoreFiltersPressed: () => _showFilterBottomSheet(context),
                ),
                if (_searchQuery.isNotEmpty)
                  _buildSearchResults(campsiteState)
                else ...[
                  _buildFeaturedSection(campsiteState),
                  _buildAllCampsitesSection(campsiteState),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Desktop Layout
  Widget _buildDesktopLayout(campsiteState) {
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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child:
                          _searchQuery.isNotEmpty
                              ? _buildSearchResults(campsiteState)
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildFeaturedSection(campsiteState),
                                  const SizedBox(height: 32),
                                  _buildAllCampsitesSection(campsiteState),
                                ],
                              ),
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

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  void _navigateToCampsiteDetail(String campsiteId) {
    context.go('/campsite-list/campsite/$campsiteId');
  }

  // Mobile Header Background
  Widget _buildMobileHeaderBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Forest background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800&auto=format&fit=crop&q=80',
              ),
              fit: BoxFit.cover,
              opacity: 0.2,
            ),
          ),
        ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                Colors.black.withOpacity(0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Header content
        SafeArea(
          child: ResponsiveConstraints(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row with branding and profile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_buildBranding(), _buildProfileButton()],
                  ),
                  const Spacer(),
                  // Welcome text
                  Text(
                    'Hello, Asif 👋',
                    style: AppTextStyles.headingLargeWith(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Text(
                      'Discover your ideal campsite—nearby, lakeside, or riverside—start your adventure today!',
                      style: AppTextStyles.bodyLargeWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBranding() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.location_on, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          'Camper Blis',
          style: AppTextStyles.headingMediumWith(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Icon(Icons.person, color: AppColors.primary, size: 24),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Search Results
  Widget _buildSearchResults(campsiteState) {
    if (campsiteState.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: LoadingWidget(message: 'Searching campsites...')),
      );
    }

    final filteredCampsites =
        campsiteState.campsites.where((campsite) {
          return campsite.matchesSearchTerm(_searchQuery);
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Text(
            'Search Results (${filteredCampsites.length})',
            style:
                ResponsiveLayout.isDesktop(context)
                    ? AppTextStyles.headingLarge.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    )
                    : AppTextStyles.headingMedium.copyWith(fontSize: 20),
          ),
        ),
        if (filteredCampsites.isEmpty)
          _buildEmptySearchState()
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
      ],
    );
  }

  // Featured Section
  Widget _buildFeaturedSection(campsiteState) {
    if (campsiteState.campsites.isEmpty) return const SizedBox.shrink();

    final featuredCampsites =
        campsiteState.filteredCampsites
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
                style:
                    ResponsiveLayout.isDesktop(context)
                        ? AppTextStyles.headingLarge.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        )
                        : AppTextStyles.headingMedium.copyWith(fontSize: 20),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  ResponsiveLayout.isDesktop(context)
                      ? 'See all featured'
                      : 'See all',
                  style: AppTextStyles.bodyLarge.copyWith(
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

  // All Campsites Section
  Widget _buildAllCampsitesSection(campsiteState) {
    if (campsiteState.campsites.isEmpty) return const SizedBox.shrink();

    final allCampsites = campsiteState.filteredCampsites;

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

  Widget _buildEmptySearchState() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No campsites found for "$_searchQuery"',
              style: AppTextStyles.headingSmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms or browse our recommendations',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleSearchClear,
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
}
