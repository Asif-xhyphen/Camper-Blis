import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/campsite.dart';
import '../../domain/entities/filter_criteria.dart';
import '../../domain/repositories/campsite_repository.dart';
import '../datasources/local/campsite_local_datasource.dart';
import '../datasources/remote/campsite_remote_datasource.dart';

/// Implementation of [CampsiteRepository] that coordinates between remote and local data sources
/// Implements the repository pattern with caching and offline support
class CampsiteRepositoryImpl implements CampsiteRepository {
  final CampsiteRemoteDataSource _remoteDataSource;
  final CampsiteLocalDataSource _localDataSource;

  const CampsiteRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, List<Campsite>>> getCampsites() async {
    try {
      // Try to get cached data first
      final cachedResult = await _localDataSource.getCachedCampsites();
      return cachedResult.fold((failure) => _fetchFromRemoteAndCache(), (
        cachedCampsites,
      ) {
        if (cachedCampsites.isNotEmpty) {
          // Convert models to domain entities
          final domainCampsites =
              cachedCampsites.map((model) => model.toDomain()).toList();
          return Right(domainCampsites);
        } else {
          // No cached data, fetch from remote
          return _fetchFromRemoteAndCache();
        }
      });
    } catch (e) {
      return Left(GeneralFailure('Failed to get campsites: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Campsite>> getCampsiteById(String id) async {
    try {
      // Try to get from cache first
      final cachedResult = await _localDataSource.getCachedCampsite(id);

      return cachedResult.fold(
        (cacheFailure) async {
          // Not found in cache, try remote
          final remoteResult = await _remoteDataSource.getCampsiteById(id);

          return remoteResult.fold((failure) => Left(failure), (
            campsiteModel,
          ) async {
            // Cache the fetched campsite for future use
            await _localDataSource.cacheCampsites([campsiteModel]);
            return Right(campsiteModel.toDomain());
          });
        },
        (campsiteModel) {
          if (campsiteModel != null) {
            return Right(campsiteModel.toDomain());
          } else {
            return Left(GeneralFailure('Campsite not found'));
          }
        },
      );
    } catch (e) {
      return Left(
        GeneralFailure('Failed to get campsite by ID: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Campsite>>> getFilteredCampsites(
    FilterCriteria filterCriteria,
  ) async {
    try {
      // Apply filters to local data for performance
      final filteredResult = await _localDataSource.getFilteredCampsites(
        filterCriteria,
      );

      return filteredResult.fold((failure) => Left(failure), (
        filteredCampsites,
      ) {
        // Convert models to domain entities
        final domainCampsites =
            filteredCampsites.map((model) => model.toDomain()).toList();
        return Right(domainCampsites);
      });
    } catch (e) {
      return Left(
        GeneralFailure('Failed to get filtered campsites: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Campsite>>> searchCampsites(
    String searchTerm,
  ) async {
    try {
      // Validate search term
      if (searchTerm.isEmpty) {
        return const Left(ValidationFailure('Search term cannot be empty'));
      }

      // Search in local cache for performance
      final searchResult = await _localDataSource.searchCampsites(searchTerm);

      return searchResult.fold((failure) => Left(failure), (searchResults) {
        // Convert models to domain entities
        final domainCampsites =
            searchResults.map((model) => model.toDomain()).toList();
        return Right(domainCampsites);
      });
    } catch (e) {
      return Left(
        GeneralFailure('Failed to search campsites: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Campsite>>> refreshCampsites() async {
    return _fetchFromRemoteAndCache();
  }

  @override
  Future<Either<Failure, Unit>> clearCache() async {
    try {
      final result = await _localDataSource.clearCache();
      return result.fold((failure) => Left(failure), (_) => const Right(unit));
    } catch (e) {
      return Left(GeneralFailure('Failed to clear cache: ${e.toString()}'));
    }
  }

  @override
  Future<bool> hasFreshCache() async {
    try {
      final isExpired = await _localDataSource.isCacheExpired();
      return !isExpired;
    } catch (e) {
      // If there's an error checking cache, assume it's not fresh
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getCacheStats() async {
    return await _localDataSource.getCacheStats();
  }

  /// Private helper method to fetch from remote and cache the results
  Future<Either<Failure, List<Campsite>>> _fetchFromRemoteAndCache() async {
    try {
      // Fetch from remote API
      final remoteResult = await _remoteDataSource.getCampsites();

      return remoteResult.fold((failure) => Left(failure), (
        campsiteModels,
      ) async {
        // Cache the fetched data
        final cacheResult = await _localDataSource.cacheCampsites(
          campsiteModels,
        );

        return cacheResult.fold(
          (cacheFailure) {
            // Even if caching fails, return the remote data
            // But log the cache failure for monitoring
            final domainCampsites =
                campsiteModels.map((model) => model.toDomain()).toList();
            return Right(domainCampsites);
          },
          (_) {
            // Successfully cached, return domain entities
            final domainCampsites =
                campsiteModels.map((model) => model.toDomain()).toList();
            return Right(domainCampsites);
          },
        );
      });
    } catch (e) {
      return Left(
        GeneralFailure('Failed to fetch and cache campsites: ${e.toString()}'),
      );
    }
  }
}
