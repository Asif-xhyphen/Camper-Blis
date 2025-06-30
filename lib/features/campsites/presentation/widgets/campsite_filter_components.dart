import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/filter_controller.dart';
import '../controllers/campsite_controller.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../../../shared/theme/colors.dart';

// Mobile Filter Chips Component
class CampsiteFilterChips extends ConsumerWidget {
  const CampsiteFilterChips({super.key, this.onMoreFiltersPressed});

  final VoidCallback? onMoreFiltersPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterControllerProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(
              label: 'Nearby',
              icon: Icons.location_on,
              isSelected: true, // Always selected for nearby
              onTap: () {
                // Nearby is default, could trigger location-based sorting
              },
            ),
            const SizedBox(width: 12),
            _FilterChip(
              label: 'Lakeside',
              icon: Icons.water_drop,
              isSelected: filterState.isCloseToWater == true,
              onTap: () => _toggleWaterProximity(ref, filterState),
            ),
            const SizedBox(width: 12),
            _FilterChip(
              label: 'Campfire',
              icon: Icons.local_fire_department,
              isSelected: filterState.isCampFireAllowed == true,
              onTap: () => _toggleCampfireAllowed(ref, filterState),
            ),
            const SizedBox(width: 12),
            _FilterChip(
              label: 'More',
              icon: Icons.tune,
              isSelected: ref.watch(hasActiveFiltersProvider),
              onTap: onMoreFiltersPressed ?? () {},
            ),
          ],
        ),
      ),
    );
  }

  void _toggleWaterProximity(WidgetRef ref, filterState) {
    final newValue = filterState.isCloseToWater == true ? null : true;
    ref.read(filterControllerProvider.notifier).updateWaterProximity(newValue);
    ref
        .read(campsiteControllerProvider.notifier)
        .applyFilters(ref.read(filterControllerProvider));
  }

  void _toggleCampfireAllowed(WidgetRef ref, filterState) {
    final newValue = filterState.isCampFireAllowed == true ? null : true;
    ref.read(filterControllerProvider.notifier).updateCampfireAllowed(newValue);
    ref
        .read(campsiteControllerProvider.notifier)
        .applyFilters(ref.read(filterControllerProvider));
  }
}

// Individual Filter Chip Widget
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
}

// Web Filter Sidebar Component
class CampsiteFilterSidebar extends ConsumerWidget {
  const CampsiteFilterSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterControllerProvider);

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 280 - 48,
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filters',
                style: AppTextStyles.headingMedium.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Location filters
              _FilterSection(
                title: 'Location Type',
                children: [
                  _FilterOption(
                    label: 'Nearby',
                    isSelected: true,
                    onTap: () {},
                  ),
                  _FilterOption(
                    label: 'Lakeside',
                    isSelected: filterState.isCloseToWater == true,
                    onTap: () => _toggleWaterProximity(ref, filterState),
                  ),
                  _FilterOption(
                    label: 'Riverside',
                    isSelected: false,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Amenities
              _FilterSection(
                title: 'Amenities',
                children: [
                  _FilterOption(
                    label: 'Campfire Allowed',
                    isSelected: filterState.isCampFireAllowed == true,
                    onTap: () => _toggleCampfireAllowed(ref, filterState),
                  ),
                  _FilterOption(
                    label: 'Restrooms',
                    isSelected: false,
                    onTap: () {},
                  ),
                  _FilterOption(
                    label: 'Showers',
                    isSelected: false,
                    onTap: () {},
                  ),
                  _FilterOption(label: 'WiFi', isSelected: false, onTap: () {}),
                ],
              ),

              const Spacer(flex: 1),

              // Clear filters
              if (ref.watch(hasActiveFiltersProvider))
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _clearAllFilters(ref),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Clear All Filters',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.primary,
                        ),
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

  void _toggleWaterProximity(WidgetRef ref, filterState) {
    final newValue = filterState.isCloseToWater == true ? null : true;
    ref.read(filterControllerProvider.notifier).updateWaterProximity(newValue);
    ref
        .read(campsiteControllerProvider.notifier)
        .applyFilters(ref.read(filterControllerProvider));
  }

  void _toggleCampfireAllowed(WidgetRef ref, filterState) {
    final newValue = filterState.isCampFireAllowed == true ? null : true;
    ref.read(filterControllerProvider.notifier).updateCampfireAllowed(newValue);
    ref
        .read(campsiteControllerProvider.notifier)
        .applyFilters(ref.read(filterControllerProvider));
  }

  void _clearAllFilters(WidgetRef ref) {
    ref.read(filterControllerProvider.notifier).clearAllFilters();
    ref.read(campsiteControllerProvider.notifier).loadCampsites();
  }
}

// Filter Section Widget
class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headingSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

// Filter Option Widget
class _FilterOption extends StatelessWidget {
  const _FilterOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child:
                    isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 12)
                        : null,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
