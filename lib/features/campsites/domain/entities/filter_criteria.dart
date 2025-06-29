import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_criteria.freezed.dart';

@freezed
class FilterCriteria with _$FilterCriteria {
  const factory FilterCriteria({
    @Default(null) bool? isCloseToWater,
    @Default(null) bool? isCampFireAllowed,
    @Default(<String>[]) List<String> hostLanguages,
    @Default(null) double? minPrice,
    @Default(null) double? maxPrice,
  }) = _FilterCriteria;

  const FilterCriteria._();

  bool get hasActiveFilters {
    return isCloseToWater != null ||
        isCampFireAllowed != null ||
        hostLanguages.isNotEmpty ||
        minPrice != null ||
        maxPrice != null;
  }

  int get activeFilterCount {
    int count = 0;
    if (isCloseToWater != null) count++;
    if (isCampFireAllowed != null) count++;
    if (hostLanguages.isNotEmpty) count++;
    if (minPrice != null) count++;
    if (maxPrice != null) count++;
    return count;
  }

  FilterCriteria clearAll() {
    return const FilterCriteria();
  }

  bool isPriceInRange(double price) {
    final bool aboveMin = minPrice == null || price >= minPrice!;
    final bool belowMax = maxPrice == null || price <= maxPrice!;
    return aboveMin && belowMax;
  }
}
