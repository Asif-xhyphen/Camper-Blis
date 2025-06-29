import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/filter_controller.dart';
import '../controllers/campsite_controller.dart';
import '../../domain/entities/filter_criteria.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/constants/dimensions.dart';
import '../../../../shared/theme/text_styles.dart';

/// Web-optimized filter bar for larger screens
class WebFilterBar extends ConsumerWidget {
  const WebFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterControllerProvider);
    final hasActiveFilters = ref.watch(hasActiveFiltersProvider);
    final activeFilterCount = ref.watch(activeFilterCountProvider);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingM,
        vertical: Dimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: Dimensions.spaceM,
        runSpacing: Dimensions.spaceS,
        alignment: WrapAlignment.center,
        children: [
          // Languages filter
          _buildFilterChip(
            label: 'Languages',
            isActive: filterState.hostLanguages.isNotEmpty,
            count: filterState.hostLanguages.length,
            onTap: () => _showLanguageDialog(context, ref),
          ),

          // Price range filter
          _buildFilterChip(
            label: 'Price',
            isActive:
                filterState.maxPrice != null || filterState.minPrice != null,
            onTap: () => _showPriceDialog(context, ref),
          ),

          // Amenities filter
          _buildFilterChip(
            label: 'Amenities',
            isActive: _hasAmenityFilters(filterState),
            onTap: () => _showAmenitiesDialog(context, ref),
          ),

          // Clear filters
          if (hasActiveFilters)
            TextButton.icon(
              onPressed: () {
                ref.read(filterControllerProvider.notifier).clearAllFilters();
                ref
                    .read(campsiteControllerProvider.notifier)
                    .applyFilters(const FilterCriteria());
              },
              icon: const Icon(Icons.clear, size: 16),
              label: Text('Clear All ($activeFilterCount)'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingS,
                  vertical: Dimensions.paddingXS,
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _hasAmenityFilters(FilterCriteria filterState) {
    return filterState.isCloseToWater == true ||
        filterState.isCampFireAllowed == true;
  }

  Widget _buildFilterChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    int? count,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radiusS),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingM,
          vertical: Dimensions.paddingS,
        ),
        decoration: BoxDecoration(
          color:
              isActive
                  ? AppColors.primaryGreen.withOpacity(0.1)
                  : AppColors.surface,
          borderRadius: BorderRadius.circular(Dimensions.radiusS),
          border: Border.all(
            color: isActive ? AppColors.primaryGreen : AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count != null && count > 0 ? '$label ($count)' : label,
              style: AppTextStyles.bodySmall.copyWith(
                color:
                    isActive ? AppColors.primaryGreen : AppColors.textPrimary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: Dimensions.spaceXS),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color:
                  isActive ? AppColors.primaryGreen : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final availableLanguages = ref.read(availableLanguagesProvider);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter by Language'),
            content: SizedBox(
              width: 300,
              height: 300,
              child: Consumer(
                builder: (context, ref, child) {
                  final filterState = ref.watch(filterControllerProvider);

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children:
                          availableLanguages.map((language) {
                            final isSelected = filterState.hostLanguages
                                .contains(language);
                            return CheckboxListTile(
                              title: Text(language),
                              value: isSelected,
                              onChanged: (bool? value) {
                                ref
                                    .read(filterControllerProvider.notifier)
                                    .toggleLanguage(language);
                                ref
                                    .read(campsiteControllerProvider.notifier)
                                    .applyFilters(
                                      ref.read(filterControllerProvider),
                                    );
                              },
                            );
                          }).toList(),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }

  void _showPriceDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter by Price'),
            content: SizedBox(
              width: 300,
              child: Consumer(
                builder: (context, ref, child) {
                  final filterState = ref.watch(filterControllerProvider);
                  final priceRange = ref.read(priceRangeBoundsProvider);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RangeSlider(
                        values: RangeValues(
                          filterState.minPrice ?? priceRange.min,
                          filterState.maxPrice ?? priceRange.max,
                        ),
                        min: priceRange.min,
                        max: priceRange.max,
                        divisions: 20,
                        labels: RangeLabels(
                          '€${(filterState.minPrice ?? priceRange.min).toInt()}',
                          '€${(filterState.maxPrice ?? priceRange.max).toInt()}',
                        ),
                        onChanged: (RangeValues values) {
                          ref
                              .read(filterControllerProvider.notifier)
                              .updatePriceRange(
                                minPrice: values.start,
                                maxPrice: values.end,
                              );
                          ref
                              .read(campsiteControllerProvider.notifier)
                              .applyFilters(ref.read(filterControllerProvider));
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '€${(filterState.minPrice ?? priceRange.min).toInt()}',
                          ),
                          Text(
                            '€${(filterState.maxPrice ?? priceRange.max).toInt()}',
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }

  void _showAmenitiesDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter by Amenities'),
            content: SizedBox(
              width: 300,
              child: Consumer(
                builder: (context, ref, child) {
                  final filterState = ref.watch(filterControllerProvider);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CheckboxListTile(
                        title: const Text('Close to Water'),
                        value: filterState.isCloseToWater == true,
                        onChanged: (bool? value) {
                          ref
                              .read(filterControllerProvider.notifier)
                              .updateWaterProximity(value);
                          ref
                              .read(campsiteControllerProvider.notifier)
                              .applyFilters(ref.read(filterControllerProvider));
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Campfire Allowed'),
                        value: filterState.isCampFireAllowed == true,
                        onChanged: (bool? value) {
                          ref
                              .read(filterControllerProvider.notifier)
                              .updateCampfireAllowed(value);
                          ref
                              .read(campsiteControllerProvider.notifier)
                              .applyFilters(ref.read(filterControllerProvider));
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }
}
