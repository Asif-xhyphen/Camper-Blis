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
}
