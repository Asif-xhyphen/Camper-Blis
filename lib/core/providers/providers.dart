import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_client.dart';
import '../../features/campsites/data/datasources/remote/campsite_remote_datasource.dart';
import '../../features/campsites/data/datasources/local/campsite_local_datasource.dart';
import '../../features/campsites/data/datasources/local/database.dart';
import '../../features/campsites/data/repositories/campsite_repository_impl.dart';
import '../../features/campsites/domain/repositories/campsite_repository.dart';
import '../../features/campsites/domain/usecases/get_campsites.dart';
import '../../features/campsites/domain/usecases/get_campsite_details.dart';
import '../../features/campsites/domain/usecases/filter_campsites.dart';

/// Core provider for Dio HTTP client
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

/// Database provider for local storage
final databaseProvider = Provider<CampsiteDatabase>((ref) {
  return CampsiteDatabase();
});

/// Remote data source provider
final campsiteRemoteDataSourceProvider = Provider<CampsiteRemoteDataSource>((
  ref,
) {
  final dioClient = ref.watch(dioClientProvider);
  return CampsiteRemoteDataSourceImpl(dioClient);
});

/// Local data source provider
final campsiteLocalDataSourceProvider = Provider<CampsiteLocalDataSource>((
  ref,
) {
  final database = ref.watch(databaseProvider);
  return CampsiteLocalDataSource(database);
});

/// Repository provider
final campsiteRepositoryProvider = Provider<CampsiteRepository>((ref) {
  final remoteDataSource = ref.watch(campsiteRemoteDataSourceProvider);
  final localDataSource = ref.watch(campsiteLocalDataSourceProvider);
  return CampsiteRepositoryImpl(remoteDataSource, localDataSource);
});

/// Use case providers
final getCampsitesUseCaseProvider = Provider<GetCampsites>((ref) {
  final repository = ref.watch(campsiteRepositoryProvider);
  return GetCampsites(repository);
});

final getCampsiteDetailsUseCaseProvider = Provider<GetCampsiteDetails>((ref) {
  final repository = ref.watch(campsiteRepositoryProvider);
  return GetCampsiteDetails(repository);
});

final filterCampsitesUseCaseProvider = Provider<FilterCampsites>((ref) {
  final repository = ref.watch(campsiteRepositoryProvider);
  return FilterCampsites(repository);
});
