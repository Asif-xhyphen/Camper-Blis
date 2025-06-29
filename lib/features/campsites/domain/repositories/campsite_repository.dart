import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/campsite.dart';
import '../entities/filter_criteria.dart';

/// Repository interface for campsite-related operations
/// This interface defines the contract that data layer must implement
abstract class CampsiteRepository {
  /// Get all campsites
  /// Returns campsites from local cache if available and not expired,
  /// otherwise fetches from remote API and caches the result
  Future<Either<Failure, List<Campsite>>> getCampsites();

  /// Get campsite by ID
  /// Tries local cache first, then remote API if not found locally
  Future<Either<Failure, Campsite>> getCampsiteById(String id);

  /// Get filtered campsites
  /// Applies filtering logic to cached data for performance
  Future<Either<Failure, List<Campsite>>> getFilteredCampsites(
    FilterCriteria filterCriteria,
  );

  /// Search campsites by text
  /// Searches through campsite labels, countries, and other searchable fields
  Future<Either<Failure, List<Campsite>>> searchCampsites(String searchTerm);

  /// Refresh campsites from remote API
  /// Forces a refresh of campsite data from the remote source
  Future<Either<Failure, List<Campsite>>> refreshCampsites();

  /// Clear cached data
  /// Removes all cached campsite data from local storage
  Future<Either<Failure, Unit>> clearCache();

  /// Check if cached data is available and not expired
  Future<bool> hasFreshCache();

  /// Get cache statistics
  /// Returns information about cached data including count and last update time
  Future<Map<String, dynamic>> getCacheStats();
}
