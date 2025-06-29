import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/filter_criteria.dart';
import '../controllers/filter_controller.dart';
import '../controllers/campsite_controller.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/constants/dimensions.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late FilterCriteria _tempFilters;
  RangeValues _priceRange = const RangeValues(0, 100);

  @override
  void initState() {
    super.initState();
    _tempFilters = ref.read(filterControllerProvider);
    final bounds = ref.read(priceRangeBoundsProvider);
    _priceRange = RangeValues(
      _tempFilters.minPrice ?? bounds.min,
      _tempFilters.maxPrice ?? bounds.max,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final availableCountries = ref.watch(availableCountriesProvider);
    final availableLanguages = ref.watch(availableLanguagesProvider);
    final languageDisplayNames = ref.watch(languageDisplayNamesProvider);
    final bounds = ref.watch(priceRangeBoundsProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radiusL),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingS),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingM,
            ),
            child: Row(
              children: [
                Text(
                  'Filter Campsites',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Dimensions.spaceL),
                  _FilterSection(
                    title: 'Close to Water',
                    child: SwitchListTile(
                      title: Text('Near water'),
                      value: _tempFilters.isCloseToWater == true,
                      onChanged: (value) {
                        setState(() {
                          _tempFilters = _tempFilters.copyWith(
                            isCloseToWater: value ? true : null,
                          );
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: Dimensions.spaceL),
                  _FilterSection(
                    title: 'Campfire Allowed',
                    child: SwitchListTile(
                      title: Text('Campfire allowed'),
                      value: _tempFilters.isCampFireAllowed == true,
                      onChanged: (value) {
                        setState(() {
                          _tempFilters = _tempFilters.copyWith(
                            isCampFireAllowed: value ? true : null,
                          );
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: Dimensions.spaceL),

                  _FilterSection(
                    title: 'Host Languages',
                    child: _LanguageFilter(
                      availableLanguages: availableLanguages,
                      languageDisplayNames: languageDisplayNames,
                      selectedLanguages: _tempFilters.hostLanguages,
                      onSelectionChanged: (languages) {
                        setState(() {
                          _tempFilters = _tempFilters.copyWith(
                            hostLanguages: languages,
                          );
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: Dimensions.spaceL),

                  _FilterSection(
                    title: 'Price per Night',
                    child: _PriceRangeFilter(
                      range: _priceRange,
                      min: bounds.min,
                      max: bounds.max,
                      onChanged: (range) {
                        setState(() {
                          _priceRange = range;
                          _tempFilters = _tempFilters.copyWith(
                            minPrice: range.start,
                            maxPrice: range.end,
                          );
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: Dimensions.spaceXL),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(Dimensions.paddingM),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.divider, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: Dimensions.spaceM),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _tempFilters = const FilterCriteria();
      final bounds = ref.read(priceRangeBoundsProvider);
      _priceRange = RangeValues(bounds.min, bounds.max);
    });
  }

  void _applyFilters() {
    final filterController = ref.read(filterControllerProvider.notifier);
    final campsiteController = ref.read(campsiteControllerProvider.notifier);

    filterController.clearAllFilters();

    filterController.updateWaterProximity(_tempFilters.isCloseToWater);
    filterController.updateCampfireAllowed(_tempFilters.isCampFireAllowed);
    filterController.updateHostLanguages(_tempFilters.hostLanguages);
    filterController.updatePriceRange(
      minPrice: _tempFilters.minPrice,
      maxPrice: _tempFilters.maxPrice,
    );

    campsiteController.applyFilters(_tempFilters);

    Navigator.of(context).pop();
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: Dimensions.spaceS),
        child,
      ],
    );
  }
}

class _CountryFilter extends StatelessWidget {
  const _CountryFilter({
    required this.availableCountries,
    required this.selectedCountries,
    required this.onCountriesChanged,
  });

  final List<String> availableCountries;
  final List<String> selectedCountries;
  final ValueChanged<List<String>> onCountriesChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Dimensions.spaceS,
      runSpacing: Dimensions.spaceS,
      children:
          availableCountries.map((country) {
            final isSelected = selectedCountries.contains(country);
            return FilterChip(
              label: Text(country),
              selected: isSelected,
              onSelected: (selected) {
                final List<String> newSelection = List.from(selectedCountries);
                if (selected) {
                  newSelection.add(country);
                } else {
                  newSelection.remove(country);
                }
                onCountriesChanged(newSelection);
              },
              selectedColor: AppColors.primaryGreenLight.withOpacity(0.2),
              checkmarkColor: AppColors.primaryGreen,
            );
          }).toList(),
    );
  }
}

class _LanguageFilter extends StatelessWidget {
  const _LanguageFilter({
    required this.availableLanguages,
    required this.languageDisplayNames,
    required this.selectedLanguages,
    required this.onSelectionChanged,
  });

  final List<String> availableLanguages;
  final Map<String, String> languageDisplayNames;
  final List<String> selectedLanguages;
  final ValueChanged<List<String>> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Dimensions.spaceS,
      runSpacing: Dimensions.spaceS,
      children:
          availableLanguages.map((language) {
            final isSelected = selectedLanguages.contains(language);
            return FilterChip(
              label: Text(languageDisplayNames[language] ?? language),
              selected: isSelected,
              onSelected: (selected) {
                final List<String> newSelection = List.from(selectedLanguages);
                if (selected) {
                  newSelection.add(language);
                } else {
                  newSelection.remove(language);
                }
                onSelectionChanged(newSelection);
              },
              selectedColor: AppColors.primaryGreenLight.withOpacity(0.2),
              checkmarkColor: AppColors.primaryGreen,
            );
          }).toList(),
    );
  }
}

class _PriceRangeFilter extends StatelessWidget {
  const _PriceRangeFilter({
    required this.range,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final RangeValues range;
  final double min;
  final double max;
  final ValueChanged<RangeValues> onChanged;

  String _formatPrice(double price) {
    if (price >= 1000) {
      return '€${(price / 1000).toStringAsFixed(0)}k';
    }
    return '€${price.round()}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatPrice(range.start),
              style: textTheme.labelLarge?.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _formatPrice(range.end),
              style: textTheme.labelLarge?.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: range,
          min: min,
          max: max,
          divisions: 100,
          onChanged: onChanged,
          activeColor: AppColors.primaryGreen,
          inactiveColor: AppColors.border,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatPrice(min),
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              _formatPrice(max),
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

void showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const FilterBottomSheet(),
  );
}
