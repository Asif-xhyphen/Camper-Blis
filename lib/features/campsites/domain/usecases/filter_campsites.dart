import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/campsite.dart';
import '../entities/filter_criteria.dart';
import '../repositories/campsite_repository.dart';

/// Use case for filtering campsites based on criteria
/// Implements the business logic for applying filters to campsite data
class FilterCampsites {
  final CampsiteRepository _repository;

  const FilterCampsites(this._repository);

  /// Execute the use case to filter campsites
  ///
  /// This use case implements the following business logic:
  /// 1. Validate filter criteria
  /// 2. Apply filters to cached data for performance
  /// 3. Return filtered results
  /// 4. Handle edge cases (empty results, invalid filters)
  Future<Either<Failure, List<Campsite>>> call(
    FilterCriteria filterCriteria,
  ) async {
    try {
      // If no filters are active, return all campsites
      if (!filterCriteria.hasActiveFilters) {
        return await _repository.getCampsites();
      }

      // Apply filters using repository
      final result = await _repository.getFilteredCampsites(filterCriteria);

      return result.fold((failure) => Left(failure), (campsites) {
        // Sort filtered results by name for consistent ordering
        final sortedCampsites = List<Campsite>.from(campsites)
          ..sort((a, b) => a.label.compareTo(b.label));
        return Right(sortedCampsites);
      });
    } catch (e) {
      return Left(
        GeneralFailure('Failed to filter campsites: ${e.toString()}'),
      );
    }
  }

  /// Get unique values for filter options
  Future<Either<Failure, FilterOptions>> getFilterOptions() async {
    try {
      final campsitesResult = await _repository.getCampsites();

      return campsitesResult.fold((failure) => Left(failure), (campsites) {
        final languages =
            campsites.expand((c) => c.hostLanguages).toSet().toList()..sort();
        final prices = campsites.map((c) => c.pricePerNight).toList();

        final minPrice =
            prices.isEmpty ? 0.0 : prices.reduce((a, b) => a < b ? a : b);
        final maxPrice =
            prices.isEmpty ? 100.0 : prices.reduce((a, b) => a > b ? a : b);

        return Right(
          FilterOptions(
            hostLanguages: languages,
            minPrice: minPrice,
            maxPrice: maxPrice,
          ),
        );
      });
    } catch (e) {
      return Left(
        GeneralFailure('Failed to get filter options: ${e.toString()}'),
      );
    }
  }

  /// Apply filters to a list of campsites
  List<Campsite> _applyFilters(
    List<Campsite> campsites,
    FilterCriteria filters,
  ) {
    return campsites.where((campsite) {
      // Water proximity filter
      if (filters.isCloseToWater != null &&
          campsite.isCloseToWater != filters.isCloseToWater) {
        return false;
      }

      // Campfire allowed filter
      if (filters.isCampFireAllowed != null &&
          campsite.isCampFireAllowed != filters.isCampFireAllowed) {
        return false;
      }

      // Host languages filter
      if (filters.hostLanguages.isNotEmpty &&
          !filters.hostLanguages.any(
            (lang) => campsite.hostLanguages.contains(lang),
          )) {
        return false;
      }

      // Price range filter
      if (filters.minPrice != null &&
          campsite.pricePerNight < filters.minPrice!) {
        return false;
      }

      if (filters.maxPrice != null &&
          campsite.pricePerNight > filters.maxPrice!) {
        return false;
      }

      return true;
    }).toList();
  }
}

/// Data class for filter options
class FilterOptions {
  final List<String> hostLanguages;
  final double minPrice;
  final double maxPrice;

  const FilterOptions({
    required this.hostLanguages,
    required this.minPrice,
    required this.maxPrice,
  });
}
