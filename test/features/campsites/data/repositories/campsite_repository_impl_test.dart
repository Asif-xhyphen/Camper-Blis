import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:camper_blis/core/error/failures.dart';
import 'package:camper_blis/features/campsites/data/models/campsite_model.dart';
import 'package:camper_blis/features/campsites/data/models/geo_location_model.dart';
import 'package:camper_blis/features/campsites/data/datasources/local/campsite_local_datasource.dart';
import 'package:camper_blis/features/campsites/data/datasources/remote/campsite_remote_datasource.dart';
import 'package:camper_blis/features/campsites/data/repositories/campsite_repository_impl.dart';
import 'package:camper_blis/features/campsites/domain/entities/campsite.dart';
import 'package:camper_blis/features/campsites/domain/entities/filter_criteria.dart';
import 'package:camper_blis/features/campsites/domain/entities/geo_location.dart';

import 'campsite_repository_impl_test.mocks.dart';

@GenerateMocks([CampsiteRemoteDataSource, CampsiteLocalDataSource])
void main() {
  late CampsiteRepositoryImpl repository;
  late MockCampsiteRemoteDataSource mockRemoteDataSource;
  late MockCampsiteLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockCampsiteRemoteDataSource();
    mockLocalDataSource = MockCampsiteLocalDataSource();
    repository = CampsiteRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
    );
  });

  group('CampsiteRepositoryImpl', () {
    final tCampsiteModels = [
      const CampsiteModel(
        id: '1',
        label: 'Test Campsite 1',
        geoLocation: GeoLocationModel(latitude: 52.5, longitude: 13.4),
        createdAt: '2024-01-01T00:00:00.000Z',
        isCloseToWater: true,
        isCampFireAllowed: false,
        hostLanguages: ['en', 'de'],
        pricePerNight: 25.0,
        photo: 'https://example.com/photo1.jpg',
        suitableFor: ['tent'],
      ),
      const CampsiteModel(
        id: '2',
        label: 'Test Campsite 2',
        geoLocation: GeoLocationModel(latitude: 53.5, longitude: 14.4),
        createdAt: '2024-01-02T00:00:00.000Z',
        isCloseToWater: false,
        isCampFireAllowed: true,
        hostLanguages: ['en'],
        pricePerNight: 30.0,
        photo: 'https://example.com/photo2.jpg',
        suitableFor: ['rv'],
      ),
    ];

    final tCampsites =
        tCampsiteModels.map((model) => model.toDomain()).toList();

    group('getCampsites', () {
      test('should return cached campsites when cache is available', () async {
        // arrange
        when(
          mockLocalDataSource.getCachedCampsites(),
        ).thenAnswer((_) async => Right(tCampsiteModels));

        // act
        final result = await repository.getCampsites();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (campsites) => expect(campsites, equals(tCampsites)),
        );
        verify(mockLocalDataSource.getCachedCampsites());
        verifyNever(mockRemoteDataSource.getCampsites());
      });

      test('should fetch from remote when cache is empty', () async {
        // arrange
        when(
          mockLocalDataSource.getCachedCampsites(),
        ).thenAnswer((_) async => const Right(<CampsiteModel>[]));
        when(
          mockRemoteDataSource.getCampsites(),
        ).thenAnswer((_) async => Right(tCampsiteModels));
        when(
          mockLocalDataSource.cacheCampsites(tCampsiteModels),
        ).thenAnswer((_) async => const Right(null));

        // act
        final result = await repository.getCampsites();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (campsites) => expect(campsites, equals(tCampsites)),
        );
        verify(mockLocalDataSource.getCachedCampsites());
        verify(mockRemoteDataSource.getCampsites());
        verify(mockLocalDataSource.cacheCampsites(tCampsiteModels));
      });

      test('should fetch from remote when cache fails', () async {
        // arrange
        const tFailure = CacheFailure('Cache read failed');
        when(
          mockLocalDataSource.getCachedCampsites(),
        ).thenAnswer((_) async => const Left(tFailure));
        when(
          mockRemoteDataSource.getCampsites(),
        ).thenAnswer((_) async => Right(tCampsiteModels));
        when(
          mockLocalDataSource.cacheCampsites(tCampsiteModels),
        ).thenAnswer((_) async => const Right(null));

        // act
        final result = await repository.getCampsites();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (campsites) => expect(campsites, equals(tCampsites)),
        );
        verify(mockLocalDataSource.getCachedCampsites());
        verify(mockRemoteDataSource.getCampsites());
        verify(mockLocalDataSource.cacheCampsites(tCampsiteModels));
      });

      test('should return failure when both cache and remote fail', () async {
        // arrange
        const tCacheFailure = CacheFailure('Cache read failed');
        const tNetworkFailure = NetworkFailure('Network connection failed');
        when(
          mockLocalDataSource.getCachedCampsites(),
        ).thenAnswer((_) async => const Left(tCacheFailure));
        when(
          mockRemoteDataSource.getCampsites(),
        ).thenAnswer((_) async => const Left(tNetworkFailure));

        // act
        final result = await repository.getCampsites();

        // assert
        expect(result, const Left<Failure, List<Campsite>>(tNetworkFailure));
        verify(mockLocalDataSource.getCachedCampsites());
        verify(mockRemoteDataSource.getCampsites());
        verifyNever(mockLocalDataSource.cacheCampsites(any));
      });

      test('should return data even when caching fails', () async {
        // arrange
        const tCacheFailure = CacheFailure('Cache write failed');
        when(
          mockLocalDataSource.getCachedCampsites(),
        ).thenAnswer((_) async => const Right(<CampsiteModel>[]));
        when(
          mockRemoteDataSource.getCampsites(),
        ).thenAnswer((_) async => Right(tCampsiteModels));
        when(
          mockLocalDataSource.cacheCampsites(tCampsiteModels),
        ).thenAnswer((_) async => const Left(tCacheFailure));

        // act
        final result = await repository.getCampsites();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (campsites) => expect(campsites, equals(tCampsites)),
        );
        verify(mockLocalDataSource.getCachedCampsites());
        verify(mockRemoteDataSource.getCampsites());
        verify(mockLocalDataSource.cacheCampsites(tCampsiteModels));
      });

      test('should handle exception and return GeneralFailure', () async {
        // arrange
        when(
          mockLocalDataSource.getCachedCampsites(),
        ).thenThrow(Exception('Unexpected error'));

        // act
        final result = await repository.getCampsites();

        // assert
        expect(result, isA<Either<Failure, List<Campsite>>>());
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<GeneralFailure>());
        expect(failure!.message, contains('Failed to get campsites'));
      });
    });

    group('getCampsiteById', () {
      const tCampsiteId = 'test_id';
      final tCampsiteModel = tCampsiteModels.first.copyWith(id: tCampsiteId);
      final tCampsite = tCampsiteModel.toDomain();

      test('should return campsite from cache when available', () async {
        // arrange
        when(
          mockLocalDataSource.getCachedCampsite(tCampsiteId),
        ).thenAnswer((_) async => Right(tCampsiteModel));

        // act
        final result = await repository.getCampsiteById(tCampsiteId);

        // assert
        expect(result, Right<Failure, Campsite>(tCampsite));
        verify(mockLocalDataSource.getCachedCampsite(tCampsiteId));
        verifyNever(mockRemoteDataSource.getCampsiteById(any));
      });

      test('should fetch from remote when not found in cache', () async {
        // arrange
        const tCacheFailure = CacheFailure('Not found in cache');
        when(
          mockLocalDataSource.getCachedCampsite(tCampsiteId),
        ).thenAnswer((_) async => const Left(tCacheFailure));
        when(
          mockRemoteDataSource.getCampsiteById(tCampsiteId),
        ).thenAnswer((_) async => Right(tCampsiteModel));
        when(
          mockLocalDataSource.cacheCampsites([tCampsiteModel]),
        ).thenAnswer((_) async => const Right(null));

        // act
        final result = await repository.getCampsiteById(tCampsiteId);

        // assert
        expect(result, Right<Failure, Campsite>(tCampsite));
        verify(mockLocalDataSource.getCachedCampsite(tCampsiteId));
        verify(mockRemoteDataSource.getCampsiteById(tCampsiteId));
        verify(mockLocalDataSource.cacheCampsites([tCampsiteModel]));
      });

      test('should return failure when campsite not found remotely', () async {
        // arrange
        const tCacheFailure = CacheFailure('Not found in cache');
        const tNetworkFailure = GeneralFailure('Campsite not found');
        when(
          mockLocalDataSource.getCachedCampsite(tCampsiteId),
        ).thenAnswer((_) async => const Left(tCacheFailure));
        when(
          mockRemoteDataSource.getCampsiteById(tCampsiteId),
        ).thenAnswer((_) async => const Left(tNetworkFailure));

        // act
        final result = await repository.getCampsiteById(tCampsiteId);

        // assert
        expect(result, const Left<Failure, Campsite>(tNetworkFailure));
        verify(mockLocalDataSource.getCachedCampsite(tCampsiteId));
        verify(mockRemoteDataSource.getCampsiteById(tCampsiteId));
      });

      test('should return failure when cached campsite is null', () async {
        // arrange
        when(
          mockLocalDataSource.getCachedCampsite(tCampsiteId),
        ).thenAnswer((_) async => const Right(null));

        // act
        final result = await repository.getCampsiteById(tCampsiteId);

        // assert
        expect(result, isA<Either<Failure, Campsite>>());
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<GeneralFailure>());
        expect(failure!.message, 'Campsite not found');
      });

      test('should handle exception and return GeneralFailure', () async {
        // arrange
        when(
          mockLocalDataSource.getCachedCampsite(tCampsiteId),
        ).thenThrow(Exception('Database error'));

        // act
        final result = await repository.getCampsiteById(tCampsiteId);

        // assert
        expect(result, isA<Either<Failure, Campsite>>());
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<GeneralFailure>());
        expect(failure!.message, contains('Failed to get campsite by ID'));
      });
    });

    group('getFilteredCampsites', () {
      const tFilterCriteria = FilterCriteria(isCloseToWater: true);
      final tFilteredModels = [tCampsiteModels.first];
      final tFilteredCampsites =
          tFilteredModels.map((model) => model.toDomain()).toList();

      test('should return filtered campsites from local datasource', () async {
        // arrange
        when(
          mockLocalDataSource.getFilteredCampsites(tFilterCriteria),
        ).thenAnswer((_) async => Right(tFilteredModels));

        // act
        final result = await repository.getFilteredCampsites(tFilterCriteria);

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (campsites) => expect(campsites, equals(tFilteredCampsites)),
        );
        verify(mockLocalDataSource.getFilteredCampsites(tFilterCriteria));
        verifyNever(mockRemoteDataSource.getCampsites());
      });

      test('should return failure when filtering fails', () async {
        // arrange
        const tFailure = CacheFailure('Filter operation failed');
        when(
          mockLocalDataSource.getFilteredCampsites(tFilterCriteria),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await repository.getFilteredCampsites(tFilterCriteria);

        // assert
        expect(result, const Left<Failure, List<Campsite>>(tFailure));
        verify(mockLocalDataSource.getFilteredCampsites(tFilterCriteria));
      });

      test('should handle empty filter results', () async {
        // arrange
        when(
          mockLocalDataSource.getFilteredCampsites(tFilterCriteria),
        ).thenAnswer((_) async => const Right(<CampsiteModel>[]));

        // act
        final result = await repository.getFilteredCampsites(tFilterCriteria);

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (campsites) => expect(campsites, equals(<Campsite>[])),
        );
        verify(mockLocalDataSource.getFilteredCampsites(tFilterCriteria));
      });

      test('should handle exception and return GeneralFailure', () async {
        // arrange
        when(
          mockLocalDataSource.getFilteredCampsites(tFilterCriteria),
        ).thenThrow(Exception('Filter error'));

        // act
        final result = await repository.getFilteredCampsites(tFilterCriteria);

        // assert
        expect(result, isA<Either<Failure, List<Campsite>>>());
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<GeneralFailure>());
        expect(failure!.message, contains('Failed to get filtered campsites'));
      });
    });

    group('searchCampsites', () {
      const tSearchTerm = 'mountain';
      final tSearchResults = [tCampsiteModels.first];
      final tSearchCampsites =
          tSearchResults.map((model) => model.toDomain()).toList();

      test('should return search results when successful', () async {
        // arrange
        when(
          mockLocalDataSource.searchCampsites(tSearchTerm),
        ).thenAnswer((_) async => Right(tSearchResults));

        // act
        final result = await repository.searchCampsites(tSearchTerm);

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (campsites) => expect(campsites, equals(tSearchCampsites)),
        );
        verify(mockLocalDataSource.searchCampsites(tSearchTerm));
      });

      test('should return ValidationFailure for empty search term', () async {
        // arrange
        const emptySearchTerm = '';

        // act
        final result = await repository.searchCampsites(emptySearchTerm);

        // assert
        expect(result, isA<Either<Failure, List<Campsite>>>());
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<ValidationFailure>());
        expect(failure!.message, 'Search term cannot be empty');
        verifyNever(mockLocalDataSource.searchCampsites(any));
      });

      test('should return failure when search fails', () async {
        // arrange
        const tFailure = CacheFailure('Search operation failed');
        when(
          mockLocalDataSource.searchCampsites(tSearchTerm),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await repository.searchCampsites(tSearchTerm);

        // assert
        expect(result, const Left<Failure, List<Campsite>>(tFailure));
        verify(mockLocalDataSource.searchCampsites(tSearchTerm));
      });

      test('should handle empty search results', () async {
        // arrange
        when(
          mockLocalDataSource.searchCampsites(tSearchTerm),
        ).thenAnswer((_) async => const Right(<CampsiteModel>[]));

        // act
        final result = await repository.searchCampsites(tSearchTerm);

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (campsites) => expect(campsites, equals(<Campsite>[])),
        );
        verify(mockLocalDataSource.searchCampsites(tSearchTerm));
      });

      test('should handle exception and return GeneralFailure', () async {
        // arrange
        when(
          mockLocalDataSource.searchCampsites(tSearchTerm),
        ).thenThrow(Exception('Search error'));

        // act
        final result = await repository.searchCampsites(tSearchTerm);

        // assert
        expect(result, isA<Either<Failure, List<Campsite>>>());
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<GeneralFailure>());
        expect(failure!.message, contains('Failed to search campsites'));
      });
    });

    group('refreshCampsites', () {
      test('should fetch fresh data from remote and cache it', () async {
        // arrange
        when(
          mockRemoteDataSource.getCampsites(),
        ).thenAnswer((_) async => Right(tCampsiteModels));
        when(
          mockLocalDataSource.cacheCampsites(tCampsiteModels),
        ).thenAnswer((_) async => const Right(null));

        // act
        final result = await repository.refreshCampsites();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (campsites) => expect(campsites, equals(tCampsites)),
        );
        verify(mockRemoteDataSource.getCampsites());
        verify(mockLocalDataSource.cacheCampsites(tCampsiteModels));
      });

      test('should return failure when remote fetch fails', () async {
        // arrange
        const tFailure = NetworkFailure('Network connection failed');
        when(
          mockRemoteDataSource.getCampsites(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await repository.refreshCampsites();

        // assert
        expect(result, const Left<Failure, List<Campsite>>(tFailure));
        verify(mockRemoteDataSource.getCampsites());
        verifyNever(mockLocalDataSource.cacheCampsites(any));
      });

      test('should return data even when caching fails', () async {
        // arrange
        const tCacheFailure = CacheFailure('Cache write failed');
        when(
          mockRemoteDataSource.getCampsites(),
        ).thenAnswer((_) async => Right(tCampsiteModels));
        when(
          mockLocalDataSource.cacheCampsites(tCampsiteModels),
        ).thenAnswer((_) async => const Left(tCacheFailure));

        // act
        final result = await repository.refreshCampsites();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (campsites) => expect(campsites, equals(tCampsites)),
        );
        verify(mockRemoteDataSource.getCampsites());
        verify(mockLocalDataSource.cacheCampsites(tCampsiteModels));
      });
    });

    group('clearCache', () {
      test('should clear cache successfully', () async {
        // arrange
        when(
          mockLocalDataSource.clearCache(),
        ).thenAnswer((_) async => const Right(null));

        // act
        final result = await repository.clearCache();

        // assert
        expect(result, const Right<Failure, Unit>(unit));
        verify(mockLocalDataSource.clearCache());
      });

      test('should return failure when cache clear fails', () async {
        // arrange
        const tFailure = CacheFailure('Cache clear failed');
        when(
          mockLocalDataSource.clearCache(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await repository.clearCache();

        // assert
        expect(result, const Left<Failure, Unit>(tFailure));
        verify(mockLocalDataSource.clearCache());
      });

      test('should handle exception and return GeneralFailure', () async {
        // arrange
        when(
          mockLocalDataSource.clearCache(),
        ).thenThrow(Exception('Clear cache error'));

        // act
        final result = await repository.clearCache();

        // assert
        expect(result, isA<Either<Failure, Unit>>());
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<GeneralFailure>());
        expect(failure!.message, contains('Failed to clear cache'));
      });
    });

    group('hasFreshCache', () {
      test('should return true when cache is not expired', () async {
        // arrange
        when(
          mockLocalDataSource.isCacheExpired(),
        ).thenAnswer((_) async => false);

        // act
        final result = await repository.hasFreshCache();

        // assert
        expect(result, true);
        verify(mockLocalDataSource.isCacheExpired());
      });

      test('should return false when cache is expired', () async {
        // arrange
        when(
          mockLocalDataSource.isCacheExpired(),
        ).thenAnswer((_) async => true);

        // act
        final result = await repository.hasFreshCache();

        // assert
        expect(result, false);
        verify(mockLocalDataSource.isCacheExpired());
      });

      test('should return false when cache check throws exception', () async {
        // arrange
        when(
          mockLocalDataSource.isCacheExpired(),
        ).thenThrow(Exception('Cache check error'));

        // act
        final result = await repository.hasFreshCache();

        // assert
        expect(result, false);
        verify(mockLocalDataSource.isCacheExpired());
      });
    });

    group('getCacheStats', () {
      test('should return cache statistics', () async {
        // arrange
        final tCacheStats = {
          'count': 10,
          'lastUpdated': '2024-01-01T00:00:00.000Z',
          'sizeInMB': 2.5,
        };
        when(
          mockLocalDataSource.getCacheStats(),
        ).thenAnswer((_) async => tCacheStats);

        // act
        final result = await repository.getCacheStats();

        // assert
        expect(result, tCacheStats);
        verify(mockLocalDataSource.getCacheStats());
      });
    });
  });
}
