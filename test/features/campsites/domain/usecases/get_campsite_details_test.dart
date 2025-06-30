import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:camper_blis/core/error/failures.dart';
import 'package:camper_blis/features/campsites/domain/entities/campsite.dart';
import 'package:camper_blis/features/campsites/domain/entities/geo_location.dart';
import 'package:camper_blis/features/campsites/domain/repositories/campsite_repository.dart';
import 'package:camper_blis/features/campsites/domain/usecases/get_campsite_details.dart';

import 'get_campsite_details_test.mocks.dart';

@GenerateMocks([CampsiteRepository])
void main() {
  late GetCampsiteDetails usecase;
  late MockCampsiteRepository mockRepository;

  setUp(() {
    mockRepository = MockCampsiteRepository();
    usecase = GetCampsiteDetails(mockRepository);
  });

  group('GetCampsiteDetails', () {
    const tCampsiteId = 'test_campsite_id';
    final tCampsite = Campsite(
      id: tCampsiteId,
      label: 'Beautiful Lakeside Campsite',
      geoLocation: const GeoLocation(latitude: 52.5, longitude: 13.4),
      createdAt: DateTime(2024, 1, 1),
      isCloseToWater: true,
      isCampFireAllowed: true,
      hostLanguages: const ['en', 'de', 'fr'],
      pricePerNight: 35.0,
      photo: 'https://example.com/beautiful-campsite.jpg',
      suitableFor: const ['tent', 'rv', 'cabin'],
    );

    group('call', () {
      test(
        'should return campsite when repository call is successful',
        () async {
          // arrange
          when(
            mockRepository.getCampsiteById(tCampsiteId),
          ).thenAnswer((_) async => Right(tCampsite));

          // act
          final result = await usecase.call(tCampsiteId);

          // assert
          expect(result, Right(tCampsite));
          verify(mockRepository.getCampsiteById(tCampsiteId));
          verifyNoMoreInteractions(mockRepository);
        },
      );

      test(
        'should return ValidationFailure when campsite ID is empty',
        () async {
          // arrange
          const emptyId = '';

          // act
          final result = await usecase.call(emptyId);

          // assert
          expect(result, isA<Left<Failure, Campsite>>());
          final failure = result.fold((l) => l, (r) => null);
          expect(failure, isA<ValidationFailure>());
          expect(failure!.message, 'Campsite ID cannot be empty');
          verifyNever(mockRepository.getCampsiteById(any));
        },
      );

      test(
        'should return ValidationFailure when campsite ID is whitespace only',
        () async {
          // arrange
          const whitespaceId = '   ';

          // act
          final result = await usecase.call(whitespaceId);

          // assert
          expect(result, isA<Left<Failure, Campsite>>());
          final failure = result.fold((l) => l, (r) => null);
          expect(failure, isA<ValidationFailure>());
          expect(failure!.message, 'Campsite ID cannot be empty');
          verifyNever(mockRepository.getCampsiteById(any));
        },
      );

      test('should return failure when repository call fails', () async {
        // arrange
        const tFailure = NetworkFailure('Network connection failed');
        when(
          mockRepository.getCampsiteById(tCampsiteId),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase.call(tCampsiteId);

        // assert
        expect(result, const Left(tFailure));
        verify(mockRepository.getCampsiteById(tCampsiteId));
      });

      test('should return GeneralFailure when campsite not found', () async {
        // arrange
        const tFailure = GeneralFailure('Campsite not found');
        when(
          mockRepository.getCampsiteById(tCampsiteId),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase.call(tCampsiteId);

        // assert
        expect(result, const Left(tFailure));
        verify(mockRepository.getCampsiteById(tCampsiteId));
      });

      test('should handle exception and return GeneralFailure', () async {
        // arrange
        when(
          mockRepository.getCampsiteById(tCampsiteId),
        ).thenThrow(Exception('Database connection failed'));

        // act
        final result = await usecase.call(tCampsiteId);

        // assert
        expect(result, isA<Left<Failure, Campsite>>());
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<GeneralFailure>());
        expect(failure!.message, contains('Failed to get campsite details'));
        verify(mockRepository.getCampsiteById(tCampsiteId));
      });

      test(
        'should handle cache failure and return appropriate error',
        () async {
          // arrange
          const tFailure = CacheFailure('Cache read failed');
          when(
            mockRepository.getCampsiteById(tCampsiteId),
          ).thenAnswer((_) async => const Left(tFailure));

          // act
          final result = await usecase.call(tCampsiteId);

          // assert
          expect(result, const Left(tFailure));
          verify(mockRepository.getCampsiteById(tCampsiteId));
        },
      );

      test(
        'should handle server failure and return appropriate error',
        () async {
          // arrange
          const tFailure = ServerFailure(
            'Internal server error',
            statusCode: 500,
          );
          when(
            mockRepository.getCampsiteById(tCampsiteId),
          ).thenAnswer((_) async => const Left(tFailure));

          // act
          final result = await usecase.call(tCampsiteId);

          // assert
          expect(result, const Left(tFailure));
          verify(mockRepository.getCampsiteById(tCampsiteId));
        },
      );

      test(
        'should return different campsite details for different IDs',
        () async {
          // arrange
          const tCampsiteId1 = 'campsite_1';
          const tCampsiteId2 = 'campsite_2';

          final tCampsite1 = tCampsite.copyWith(
            id: tCampsiteId1,
            label: 'Campsite 1',
          );
          final tCampsite2 = tCampsite.copyWith(
            id: tCampsiteId2,
            label: 'Campsite 2',
          );

          when(
            mockRepository.getCampsiteById(tCampsiteId1),
          ).thenAnswer((_) async => Right(tCampsite1));
          when(
            mockRepository.getCampsiteById(tCampsiteId2),
          ).thenAnswer((_) async => Right(tCampsite2));

          // act
          final result1 = await usecase.call(tCampsiteId1);
          final result2 = await usecase.call(tCampsiteId2);

          // assert
          expect(result1, Right(tCampsite1));
          expect(result2, Right(tCampsite2));
          verify(mockRepository.getCampsiteById(tCampsiteId1));
          verify(mockRepository.getCampsiteById(tCampsiteId2));
        },
      );
    });

    group('input validation edge cases', () {
      test('should handle special characters in campsite ID', () async {
        // arrange
        const specialId = 'campsite-123_test@example.com';
        final specialCampsite = tCampsite.copyWith(id: specialId);
        when(
          mockRepository.getCampsiteById(specialId),
        ).thenAnswer((_) async => Right(specialCampsite));

        // act
        final result = await usecase.call(specialId);

        // assert
        expect(result, Right(specialCampsite));
        verify(mockRepository.getCampsiteById(specialId));
      });

      test('should handle very long campsite ID', () async {
        // arrange
        final longId = 'a' * 1000; // Very long ID
        final longIdCampsite = tCampsite.copyWith(id: longId);
        when(
          mockRepository.getCampsiteById(longId),
        ).thenAnswer((_) async => Right(longIdCampsite));

        // act
        final result = await usecase.call(longId);

        // assert
        expect(result, Right(longIdCampsite));
        verify(mockRepository.getCampsiteById(longId));
      });
    });

    group('performance and concurrency', () {
      test(
        'should handle multiple concurrent requests for same campsite',
        () async {
          // arrange
          when(
            mockRepository.getCampsiteById(tCampsiteId),
          ).thenAnswer((_) async => Right(tCampsite));

          // act
          final futures = List.generate(5, (_) => usecase.call(tCampsiteId));
          final results = await Future.wait(futures);

          // assert
          for (final result in results) {
            expect(result, Right(tCampsite));
          }
          verify(mockRepository.getCampsiteById(tCampsiteId)).called(5);
        },
      );

      test('should handle timeout scenarios', () async {
        // arrange
        when(mockRepository.getCampsiteById(tCampsiteId)).thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 1));
          throw Exception('Request timeout');
        });

        // act
        final result = await usecase.call(tCampsiteId);

        // assert
        expect(result, isA<Left<Failure, Campsite>>());
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<GeneralFailure>());
      });
    });
  });
}
