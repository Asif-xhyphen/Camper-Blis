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

  void updateWaterProximity(bool? isCloseToWater) {
    state = state.copyWith(isCloseToWater: isCloseToWater);
  }

  void updateCampfireAllowed(bool? isCampFireAllowed) {
    state = state.copyWith(isCampFireAllowed: isCampFireAllowed);
  }

  void updateHostLanguages(List<String> languages) {
    state = state.copyWith(hostLanguages: languages);
  }

  void toggleLanguage(String language) {
    final List<String> currentLanguages = List.from(state.hostLanguages);
    if (currentLanguages.contains(language)) {
      currentLanguages.remove(language);
    } else {
      currentLanguages.add(language);
    }
    state = state.copyWith(hostLanguages: currentLanguages);
  }

  void updatePriceRange({double? minPrice, double? maxPrice}) {
    state = state.copyWith(minPrice: minPrice, maxPrice: maxPrice);
  }

  void clearAllFilters() {
    state = const FilterCriteria();
  }

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

@riverpod
bool hasActiveFilters(Ref ref) {
  final filter = ref.watch(filterControllerProvider);
  return filter.hasActiveFilters;
}

@riverpod
int activeFilterCount(Ref ref) {
  final filter = ref.watch(filterControllerProvider);
  return filter.activeFilterCount;
}

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

@riverpod
({double min, double max}) priceRangeBounds(Ref ref) {
  return (min: 0.0, max: 100000.0);
}
