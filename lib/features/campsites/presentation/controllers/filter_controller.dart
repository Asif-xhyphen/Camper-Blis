import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/filter_criteria.dart';

part 'filter_controller.g.dart';

@riverpod
class FilterController extends _$FilterController {
  @override
  FilterCriteria build() {
    return const FilterCriteria();
  }

  /// Update water proximity filter
  void updateWaterProximity(bool? isCloseToWater) {
    state = state.copyWith(isCloseToWater: isCloseToWater);
  }

  /// Update campfire allowed filter
  void updateCampfireAllowed(bool? isCampFireAllowed) {
    state = state.copyWith(isCampFireAllowed: isCampFireAllowed);
  }

  /// Update host languages filter
  void updateHostLanguages(List<String> languages) {
    state = state.copyWith(hostLanguages: languages);
  }

  /// Toggle a language in the selection
  void toggleLanguage(String language) {
    final List<String> currentLanguages = List.from(state.hostLanguages);
    if (currentLanguages.contains(language)) {
      currentLanguages.remove(language);
    } else {
      currentLanguages.add(language);
    }
    state = state.copyWith(hostLanguages: currentLanguages);
  }

  /// Update price range filter
  void updatePriceRange({double? minPrice, double? maxPrice}) {
    state = state.copyWith(minPrice: minPrice, maxPrice: maxPrice);
  }

  /// Clear all filters
  void clearAllFilters() {
    state = const FilterCriteria();
  }

  /// Reset a specific filter
  void resetFilter(String filterType) {
    switch (filterType) {
      case 'water':
        state = state.copyWith(isCloseToWater: null);
        break;
      case 'campfire':
        state = state.copyWith(isCampFireAllowed: null);
        break;
      case 'languages':
        state = state.copyWith(hostLanguages: []);
        break;
      case 'price':
        state = state.copyWith(minPrice: null, maxPrice: null);
        break;
    }
  }
}

/// Provider for checking if filters are active
@riverpod
bool hasActiveFilters(Ref ref) {
  final filter = ref.watch(filterControllerProvider);
  return filter.hasActiveFilters;
}

/// Provider for active filter count
@riverpod
int activeFilterCount(Ref ref) {
  final filter = ref.watch(filterControllerProvider);
  return filter.activeFilterCount;
}

/// Provider for available countries
@riverpod
List<String> availableCountries(Ref ref) {
  return [
    'Germany',
    'France',
    'Spain',
    'Italy',
    'Switzerland',
    'Austria',
    'Netherlands',
    'Belgium',
    'Portugal',
    'Denmark',
    'Sweden',
    'Norway',
  ];
}

/// Provider for available languages
@riverpod
List<String> availableLanguages(Ref ref) {
  return [
    'en', // English
    'de', // German
    'fr', // French
    'es', // Spanish
    'it', // Italian
    'nl', // Dutch
    'pt', // Portuguese
    'da', // Danish
    'sv', // Swedish
    'no', // Norwegian
  ];
}

/// Provider for language display names
@riverpod
Map<String, String> languageDisplayNames(Ref ref) {
  return {
    'en': 'English',
    'de': 'German',
    'fr': 'French',
    'es': 'Spanish',
    'it': 'Italian',
    'nl': 'Dutch',
    'pt': 'Portuguese',
    'da': 'Danish',
    'sv': 'Swedish',
    'no': 'Norwegian',
  };
}

/// Provider for price range bounds
@riverpod
({double min, double max}) priceRangeBounds(Ref ref) {
  // Based on the actual data range from JSON response
  return (min: 0.0, max: 100000.0);
}
