import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/campsite.dart';
import '../repositories/campsite_repository.dart';

/// Use case for retrieving detailed information about a specific campsite
/// Implements the business logic for getting campsite details with caching strategy
class GetCampsiteDetails {
  final CampsiteRepository _repository;

  const GetCampsiteDetails(this._repository);

  /// Execute the use case to get campsite details by ID
  ///
  /// This use case implements the following business logic:
  /// 1. Validate the campsite ID
  /// 2. Try to get from cache first for performance
  /// 3. If not found locally, fetch from remote API
  /// 4. Handle all error scenarios appropriately
  Future<Either<Failure, Campsite>> call(String campsiteId) async {
    try {
      // Validate input - check for empty or whitespace-only strings
      if (campsiteId.trim().isEmpty) {
        return const Left(ValidationFailure('Campsite ID cannot be empty'));
      }

      // Trim whitespace from the ID
      final trimmedId = campsiteId.trim();

      // Get campsite by ID (repository handles cache vs remote logic)
      final result = await _repository.getCampsiteById(trimmedId);

      return result.fold((failure) => Left(failure), (campsite) {
        // Additional business logic can be added here
        // For example, logging view events, updating last viewed timestamp, etc.
        return Right(campsite);
      });
    } catch (e) {
      return Left(
        GeneralFailure('Failed to get campsite details: ${e.toString()}'),
      );
    }
  }
}
