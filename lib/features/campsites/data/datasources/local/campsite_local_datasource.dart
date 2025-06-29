import 'package:drift/drift.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../models/campsite_model.dart';
import '../../models/geo_location_model.dart';
import '../../../domain/entities/filter_criteria.dart';
import 'database.dart';

/// Local data source for campsite data using Drift
class CampsiteLocalDataSource {
  final CampsiteDatabase _database;

  CampsiteLocalDataSource(this._database);

  /// Get all cached campsites
  Future<Either<Failure, List<CampsiteModel>>> getCachedCampsites() async {
    try {
      final campsiteEntries = await _database.select(_database.campsites).get();
      final campsiteModels = campsiteEntries.map(_mapToModel).toList();
      return Right(campsiteModels);
    } catch (e) {
      return Left(CacheFailure('Failed to get cached campsites: $e'));
    }
  }

  /// Cache campsites locally
  Future<Either<Failure, void>> cacheCampsites(
    List<CampsiteModel> campsites,
  ) async {
    try {
      await _database.transaction(() async {
        // Clear existing data
        await _database.delete(_database.campsites).go();

        // Insert new data
        for (final campsite in campsites) {
          await _database
              .into(_database.campsites)
              .insert(
                CampsitesCompanion.insert(
                  id: campsite.id,
                  label: campsite.label,
                  latitude: campsite.geoLocation.latitude,
                  longitude: campsite.geoLocation.longitude,
                  createdAt: campsite.createdAt,
                  isCloseToWater: campsite.isCloseToWater,
                  isCampFireAllowed: campsite.isCampFireAllowed,
                  hostLanguages: campsite.hostLanguages.join(','),
                  pricePerNight: campsite.pricePerNight,
                  photo: campsite.photo,
                  suitableFor: campsite.suitableFor.join(','),
                ),
              );
        }
      });
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to cache campsites: $e'));
    }
  }

  /// Get filtered campsites from cache
  Future<Either<Failure, List<CampsiteModel>>> getFilteredCampsites(
    FilterCriteria filters,
  ) async {
    try {
      var query = _database.select(_database.campsites);

      // Apply filters
      if (filters.isCloseToWater != null) {
        query =
            query
              ..where((t) => t.isCloseToWater.equals(filters.isCloseToWater!));
      }

      if (filters.isCampFireAllowed != null) {
        query =
            query..where(
              (t) => t.isCampFireAllowed.equals(filters.isCampFireAllowed!),
            );
      }

      if (filters.minPrice != null) {
        query =
            query..where(
              (t) => t.pricePerNight.isBiggerOrEqualValue(filters.minPrice!),
            );
      }

      if (filters.maxPrice != null) {
        query =
            query..where(
              (t) => t.pricePerNight.isSmallerOrEqualValue(filters.maxPrice!),
            );
      }

      // For host languages, we need to check if any of the filter languages
      // are contained in the stored comma-separated string
      if (filters.hostLanguages.isNotEmpty) {
        for (final language in filters.hostLanguages) {
          query = query..where((t) => t.hostLanguages.contains(language));
        }
      }

      final results = await query.get();
      final campsiteModels = results.map(_mapToModel).toList();
      return Right(campsiteModels);
    } catch (e) {
      return Left(CacheFailure('Failed to get filtered campsites: $e'));
    }
  }

  /// Get a specific campsite by ID
  Future<Either<Failure, CampsiteModel?>> getCachedCampsite(String id) async {
    try {
      final result =
          await (_database.select(_database.campsites)
            ..where((t) => t.id.equals(id))).getSingleOrNull();

      if (result != null) {
        return Right(_mapToModel(result));
      } else {
        return const Right(null);
      }
    } catch (e) {
      return Left(CacheFailure('Failed to get cached campsite: $e'));
    }
  }

  /// Clear all cached data
  Future<Either<Failure, void>> clearCache() async {
    try {
      await _database.delete(_database.campsites).go();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear cache: $e'));
    }
  }

  /// Search campsites by label
  Future<Either<Failure, List<CampsiteModel>>> searchCampsites(
    String searchTerm,
  ) async {
    try {
      final lowercaseSearch = searchTerm.toLowerCase();
      final results =
          await (_database.select(_database.campsites)
            ..where((t) => t.label.lower().contains(lowercaseSearch))).get();

      final campsiteModels = results.map(_mapToModel).toList();
      return Right(campsiteModels);
    } catch (e) {
      return Left(CacheFailure('Failed to search campsites: $e'));
    }
  }

  /// Check if cache is expired (simplified - always return false for now)
  Future<bool> isCacheExpired() async {
    // Simple implementation - could be enhanced with timestamp checking
    return false;
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final count =
          await (_database.selectOnly(_database.campsites)
            ..addColumns([_database.campsites.id.count()])).getSingle();

      return {
        'totalCampsites': count.read(_database.campsites.id.count()) ?? 0,
        'lastUpdated': DateTime.now().toIso8601String(),
        'isExpired': false,
      };
    } catch (e) {
      return {'totalCampsites': 0, 'lastUpdated': null, 'isExpired': true};
    }
  }

  /// Map database entry to model
  CampsiteModel _mapToModel(CampsiteDbModel dbCampsite) {
    return CampsiteModel(
      id: dbCampsite.id,
      label: dbCampsite.label,
      geoLocation: GeoLocationModel(
        latitude: dbCampsite.latitude,
        longitude: dbCampsite.longitude,
      ),
      createdAt: dbCampsite.createdAt,
      isCloseToWater: dbCampsite.isCloseToWater,
      isCampFireAllowed: dbCampsite.isCampFireAllowed,
      hostLanguages:
          dbCampsite.hostLanguages
              .split(',')
              .where((s) => s.isNotEmpty)
              .toList(),
      pricePerNight: dbCampsite.pricePerNight,
      photo: dbCampsite.photo,
      suitableFor:
          dbCampsite.suitableFor.split(',').where((s) => s.isNotEmpty).toList(),
    );
  }
}
