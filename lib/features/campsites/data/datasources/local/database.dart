import 'package:camper_blis/features/campsites/data/datasources/local/native.dart'
    as native;
// import 'package:camper_blis/features/campsites/data/datasources/local/web.dart'
//     as web;
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/config/app_config.dart';

part 'database.g.dart';

/// Campsite table definition for Drift database
@DataClassName('CampsiteDbModel')
class Campsites extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get createdAt => text()(); // Store as ISO string
  BoolColumn get isCloseToWater => boolean()();
  BoolColumn get isCampFireAllowed => boolean()();
  TextColumn get hostLanguages => text()(); // Store as comma-separated string
  RealColumn get pricePerNight => real()();
  TextColumn get photo => text()();
  TextColumn get suitableFor => text()(); // Store as comma-separated string
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cache metadata table for tracking data freshness
@DataClassName('CacheMetadataDbModel')
class CacheMetadata extends Table {
  TextColumn get key => text()();
  DateTimeColumn get lastUpdated => dateTime()();
  IntColumn get itemCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {key};
}

/// Drift database for local campsite data storage
@DriftDatabase(tables: [Campsites, CacheMetadata])
class CampsiteDatabase extends _$CampsiteDatabase {
  CampsiteDatabase() : super(openConnection());

  @override
  int get schemaVersion => AppConfig.databaseVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();

      // Insert initial cache metadata
      await into(cacheMetadata).insert(
        CacheMetadataCompanion.insert(
          key: 'campsites',
          lastUpdated: DateTime.now(),
          itemCount: Value(0),
        ),
      );
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle database upgrades here
      if (from < 2) {
        // Example upgrade logic for future versions
        // await m.addColumn(campsites, campsites.newColumn);
      }
    },
  );

  /// Get all campsites
  Future<List<CampsiteDbModel>> getAllCampsites() {
    return select(campsites).get();
  }

  /// Get campsite by ID
  Future<CampsiteDbModel?> getCampsiteById(String id) {
    return (select(campsites)
      ..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// Insert or update campsites
  Future<void> insertCampsites(List<CampsiteDbModel> campsiteList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(campsites, campsiteList);
    });

    // Update cache metadata
    await updateCacheMetadata('campsites', campsiteList.length);
  }

  /// Insert single campsite
  Future<int> insertCampsite(CampsiteDbModel campsite) {
    return into(campsites).insertOnConflictUpdate(campsite);
  }

  /// Update campsite
  Future<bool> updateCampsite(CampsiteDbModel campsite) {
    return update(campsites).replace(campsite);
  }

  /// Delete campsite by ID
  Future<int> deleteCampsite(String id) {
    return (delete(campsites)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Clear all campsites
  Future<int> clearAllCampsites() async {
    final deletedCount = await delete(campsites).go();
    await updateCacheMetadata('campsites', 0);
    return deletedCount;
  }

  /// Get campsites with water proximity
  Future<List<CampsiteDbModel>> getCampsitesNearWater() {
    return (select(campsites)
      ..where((tbl) => tbl.isCloseToWater.equals(true))).get();
  }

  /// Get campsites with campfire allowed
  Future<List<CampsiteDbModel>> getCampsitesWithCampfire() {
    return (select(campsites)
      ..where((tbl) => tbl.isCampFireAllowed.equals(true))).get();
  }

  /// Get campsites within price range
  Future<List<CampsiteDbModel>> getCampsitesInPriceRange(
    double minPrice,
    double maxPrice,
  ) {
    return (select(campsites)..where(
      (tbl) => tbl.pricePerNight.isBetweenValues(minPrice, maxPrice),
    )).get();
  }

  /// Search campsites by label
  Future<List<CampsiteDbModel>> searchCampsites(String searchTerm) {
    final lowercaseSearch = searchTerm.toLowerCase();
    return (select(campsites)
      ..where((tbl) => tbl.label.lower().contains(lowercaseSearch))).get();
  }

  /// Get cache metadata
  Future<CacheMetadataDbModel?> getCacheMetadata(String key) {
    return (select(cacheMetadata)
      ..where((tbl) => tbl.key.equals(key))).getSingleOrNull();
  }

  /// Update cache metadata
  Future<void> updateCacheMetadata(String key, int itemCount) async {
    await into(cacheMetadata).insertOnConflictUpdate(
      CacheMetadataCompanion.insert(
        key: key,
        lastUpdated: DateTime.now(),
        itemCount: Value(itemCount),
      ),
    );
  }

  /// Check if cache is expired
  Future<bool> isCacheExpired(String key) async {
    final metadata = await getCacheMetadata(key);
    if (metadata == null) return true;

    final now = DateTime.now();
    final cacheAge = now.difference(metadata.lastUpdated);
    return cacheAge > AppConfig.cacheExpiration;
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    final campsiteCount =
        await (selectOnly(campsites)
          ..addColumns([campsites.id.count()])).getSingle();

    final metadata = await getCacheMetadata('campsites');

    return {
      'totalCampsites': campsiteCount.read(campsites.id.count()) ?? 0,
      'lastUpdated': metadata?.lastUpdated,
      'isExpired': await isCacheExpired('campsites'),
    };
  }
}

openConnection() {
  // import respoctive connect from web.dart or native.dart
  // if (kIsWeb) {
  //   return web.connect();
  // }
  return native.connect();
}
