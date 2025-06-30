import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'campsite_search_bar.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/widgets/responsive_layout.dart';

class CampsiteHeader extends ConsumerWidget {
  const CampsiteHeader({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onSearchClear,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Return the appropriate widget directly based on screen size
    // This avoids the ResponsiveLayout wrapper that causes Sliver issues
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1024) {
      return _buildWebHeader();
    } else {
      return _buildMobileHeader();
    }
  }

  Widget _buildMobileHeader() {
    return SliverAppBar(
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
                Expanded(child: _buildHeaderBackground()),
                const SizedBox(height: 85),
              ],
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: _buildFloatingSearchBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebHeader() {
    return Container(
      height: 280,
      child: Stack(
        children: [
          Container(height: 240, child: _buildHeaderBackground()),
          Positioned(
            bottom: 10,
            left: 24,
            right: 24,
            child: ResponsiveConstraints(child: _buildFloatingSearchBar()),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBackground() {
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
        SafeArea(child: _buildHeaderContent()),
      ],
    );
  }

  Widget _buildHeaderContent() {
    return ResponsiveConstraints(
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

  Widget _buildFloatingSearchBar() {
    return CampsiteSearchBar(
      controller: searchController,
      onChanged: onSearchChanged,
      onClear: onSearchClear,
      searchQuery: searchQuery,
      isFloating: true,
    );
  }
}
