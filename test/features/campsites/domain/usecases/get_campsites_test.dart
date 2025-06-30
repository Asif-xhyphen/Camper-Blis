import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:camper_blis/core/error/failures.dart';
import 'package:camper_blis/features/campsites/domain/entities/campsite.dart';
import 'package:camper_blis/features/campsites/domain/entities/geo_location.dart';
import 'package:camper_blis/features/campsites/domain/repositories/campsite_repository.dart';
import 'package:camper_blis/features/campsites/domain/usecases/get_campsites.dart';

import 'get_campsites_test.mocks.dart';

@GenerateMocks([CampsiteRepository])
void main() {
  late GetCampsites usecase;
  late MockCampsiteRepository mockRepository;

  setUp(() {
    mockRepository = MockCampsiteRepository();
    usecase = GetCampsites(mockRepository);
  });

  group('GetCampsites', () {
    final tCampsites = [
      Campsite(
        id: '1',
        label: 'Test Campsite 1',
        geoLocation: const GeoLocation(latitude: 52.5, longitude: 13.4),
        createdAt: DateTime(2024, 1, 1),
        isCloseToWater: true,
        isCampFireAllowed: false,
        hostLanguages: const ['en', 'de'],
        pricePerNight: 25.0,
        photo: 'https://example.com/photo1.jpg',
        suitableFor: const ['tent', 'rv'],
      ),
      Campsite(
        id: '2',
        label: 'Test Campsite 2',
        geoLocation: const GeoLocation(latitude: 53.5, longitude: 14.4),
        createdAt: DateTime(2024, 1, 2),
        isCloseToWater: false,
        isCampFireAllowed: true,
        hostLanguages: const ['en'],
        pricePerNight: 30.0,
        photo: 'https://example.com/photo2.jpg',
        suitableFor: const ['tent'],
      ),
    ];

    group('call', () {
      test(
        'should return cached campsites when fresh cache is available',
        () async {
          // arrange
          when(mockRepository.hasFreshCache()).thenAnswer((_) async => true);
          when(
            mockRepository.getCampsites(),
          ).thenAnswer((_) async => Right(tCampsites));

          // act
          final result = await usecase.call();

          // assert
          expect(result, Right(tCampsites));
          verify(mockRepository.hasFreshCache());
          verify(mockRepository.getCampsites());
          verifyNever(mockRepository.refreshCampsites());
        },
      );

      test(
        'should refresh campsites when no fresh cache is available',
        () async {
          // arrange
          when(mockRepository.hasFreshCache()).thenAnswer((_) async => false);
          when(
            mockRepository.refreshCampsites(),
          ).thenAnswer((_) async => Right(tCampsites));

          // act
          final result = await usecase.call();

          // assert
          expect(result, Right(tCampsites));
          verify(mockRepository.hasFreshCache());
          verify(mockRepository.refreshCampsites());
          verifyNever(mockRepository.getCampsites());
        },
      );

      test('should return failure when cached data retrieval fails', () async {
        // arrange
        const tFailure = CacheFailure('Cache retrieval failed');
        when(mockRepository.hasFreshCache()).thenAnswer((_) async => true);
        when(
          mockRepository.getCampsites(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase.call();

        // assert
        expect(result, const Left(tFailure));
        verify(mockRepository.hasFreshCache());
        verify(mockRepository.getCampsites());
      });

      test('should return failure when refresh fails', () async {
        // arrange
        const tFailure = NetworkFailure('Network connection failed');
        when(mockRepository.hasFreshCache()).thenAnswer((_) async => false);
        when(
          mockRepository.refreshCampsites(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase.call();

        // assert
        expect(result, const Left(tFailure));
        verify(mockRepository.hasFreshCache());
        verify(mockRepository.refreshCampsites());
      });

      test('should handle exception and return GeneralFailure', () async {
        // arrange
        when(
          mockRepository.hasFreshCache(),
        ).thenThrow(Exception('Unexpected error'));

        // act
        final result = await usecase.call();

        // assert
        expect(result, isA<Left<Failure, List<Campsite>>>());
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<GeneralFailure>());
        expect(failure!.message, contains('Failed to get campsites'));
        verify(mockRepository.hasFreshCache());
      });

      test(
        'should return empty list when repository returns empty list',
        () async {
          // arrange
          when(mockRepository.hasFreshCache()).thenAnswer((_) async => true);
          when(
            mockRepository.getCampsites(),
          ).thenAnswer((_) async => const Right([]));

          // act
          final result = await usecase.call();

          // assert
          expect(result, const Right(<Campsite>[]));
          verify(mockRepository.hasFreshCache());
          verify(mockRepository.getCampsites());
        },
      );
    });

    group('refresh', () {
      test('should force refresh campsites from remote API', () async {
        // arrange
        when(
          mockRepository.refreshCampsites(),
        ).thenAnswer((_) async => Right(tCampsites));

        // act
        final result = await usecase.refresh();

        // assert
        expect(result, Right(tCampsites));
        verify(mockRepository.refreshCampsites());
        verifyNever(mockRepository.hasFreshCache());
        verifyNever(mockRepository.getCampsites());
      });

      test('should return failure when refresh fails', () async {
        // arrange
        const tFailure = ServerFailure('Server error', statusCode: 500);
        when(
          mockRepository.refreshCampsites(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase.refresh();

        // assert
        expect(result, const Left(tFailure));
        verify(mockRepository.refreshCampsites());
      });

      test('should handle exception during refresh', () async {
        // arrange
        when(
          mockRepository.refreshCampsites(),
        ).thenThrow(Exception('Network timeout'));

        // act
        final result = await usecase.refresh();

        // assert
        expect(result, isA<Left<Failure, List<Campsite>>>());
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<GeneralFailure>());
      });
    });

    group('integration scenarios', () {
      test(
        'should handle cache check failure and fallback to refresh',
        () async {
          // arrange
          when(
            mockRepository.hasFreshCache(),
          ).thenThrow(Exception('Cache check failed'));

          // act
          final result = await usecase.call();

          // assert
          expect(result, isA<Left<Failure, List<Campsite>>>());
          verify(mockRepository.hasFreshCache());
        },
      );

      test('should handle concurrent calls correctly', () async {
        // arrange
        when(mockRepository.hasFreshCache()).thenAnswer((_) async => true);
        when(
          mockRepository.getCampsites(),
        ).thenAnswer((_) async => Right(tCampsites));

        // act
        final futures = List.generate(3, (_) => usecase.call());
        final results = await Future.wait(futures);

        // assert
        for (final result in results) {
          expect(result, Right(tCampsites));
        }
        verify(mockRepository.hasFreshCache()).called(3);
        verify(mockRepository.getCampsites()).called(3);
      });
    });
  });
}
