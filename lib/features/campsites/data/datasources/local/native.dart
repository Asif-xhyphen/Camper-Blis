import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../../../../core/config/app_config.dart';

/// Database connection setup
LazyDatabase connect() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConfig.databaseName));
    return NativeDatabase(file);
  });
}

Future<File> get databaseFile async {
  // We use `path_provider` to find a suitable path to store our data in.
  final appDir = await getApplicationDocumentsDirectory();
  final dbPath = p.join(appDir.path, AppConfig.databaseName);
  return File(dbPath);
}

Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
  // This method validates that the actual schema of the opened database matches
  // the tables, views, triggers and indices for which drift_dev has generated
  // code.
  // Validating the database's schema after opening it is generally a good idea,
  // since it allows us to get an early warning if we change a table definition
  // without writing a schema migration for it.
  //
  // For details, see: https://drift.simonbinder.eu/docs/advanced-features/migrations/#verifying-a-database-schema-at-runtime
  if (kDebugMode) {
    await VerifySelf(database).validateDatabaseSchema();
  }
}
