import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/campsite.dart';
import '../repositories/campsite_repository.dart';

/// Use case for retrieving all campsites
/// Implements the business logic for getting campsites with proper caching strategy
class GetCampsites {
  final CampsiteRepository _repository;

  const GetCampsites(this._repository);

  /// Execute the use case to get all campsites
  ///
  /// This use case implements the following business logic:
  /// 1. Check if fresh cached data is available
  /// 2. If yes, return cached data
  /// 3. If no, fetch from remote API and cache the result
  /// 4. Handle all errors appropriately
  Future<Either<Failure, List<Campsite>>> call() async {
    try {
      // Check if we have fresh cached data
      final hasFreshCache = await _repository.hasFreshCache();

      if (hasFreshCache) {
        // Return cached data if available and fresh
        return await _repository.getCampsites();
      } else {
        // Fetch fresh data from remote API
        return await _repository.refreshCampsites();
      }
    } catch (e) {
      return Left(GeneralFailure('Failed to get campsites: ${e.toString()}'));
    }
  }

  /// Force refresh campsites from remote API
  /// Bypasses cache and fetches fresh data
  Future<Either<Failure, List<Campsite>>> refresh() async {
    try {
      return await _repository.refreshCampsites();
    } catch (e) {
      return Left(
        GeneralFailure('Failed to refresh campsites: ${e.toString()}'),
      );
    }
  }
}
