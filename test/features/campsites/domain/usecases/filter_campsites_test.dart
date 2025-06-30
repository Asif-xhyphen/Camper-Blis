import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:camper_blis/core/error/failures.dart';
import 'package:camper_blis/features/campsites/domain/entities/campsite.dart';
import 'package:camper_blis/features/campsites/domain/entities/geo_location.dart';
import 'package:camper_blis/features/campsites/domain/entities/filter_criteria.dart';
import 'package:camper_blis/features/campsites/domain/repositories/campsite_repository.dart';
import 'package:camper_blis/features/campsites/domain/usecases/filter_campsites.dart';

import 'filter_campsites_test.mocks.dart';

@GenerateMocks([CampsiteRepository])
void main() {
  late FilterCampsites usecase;
  late MockCampsiteRepository mockRepository;

  setUp(() {
    mockRepository = MockCampsiteRepository();
    usecase = FilterCampsites(mockRepository);
  });

  group('FilterCampsites', () {
    final tCampsites = [
      Campsite(
        id: '1',
        label: 'Alpine Lake Campsite',
        geoLocation: const GeoLocation(latitude: 46.8, longitude: 8.2),
        createdAt: DateTime(2024, 1, 1),
        isCloseToWater: true,
        isCampFireAllowed: false,
        hostLanguages: const ['en', 'de'],
        pricePerNight: 25.0,
        photo: 'https://example.com/alpine.jpg',
        suitableFor: const ['tent'],
      ),
      Campsite(
        id: '2',
        label: 'Forest Retreat',
        geoLocation: const GeoLocation(latitude: 47.8, longitude: 9.2),
        createdAt: DateTime(2024, 1, 2),
        isCloseToWater: false,
        isCampFireAllowed: true,
        hostLanguages: const ['en', 'fr'],
        pricePerNight: 30.0,
        photo: 'https://example.com/forest.jpg',
        suitableFor: const ['rv'],
      ),
      Campsite(
        id: '3',
        label: 'Beachside Paradise',
        geoLocation: const GeoLocation(latitude: 43.7, longitude: 7.4),
        createdAt: DateTime(2024, 1, 3),
        isCloseToWater: true,
        isCampFireAllowed: true,
        hostLanguages: const ['en', 'es'],
        pricePerNight: 45.0,
        photo: 'https://example.com/beach.jpg',
        suitableFor: const ['tent', 'rv'],
      ),
    ];

    final filteredCampsites = [
      tCampsites[0],
      tCampsites[2],
    ]; // Water-close campsites

    group('call with no active filters', () {
      test('should return all campsites when no filters are active', () async {
        // arrange
        const filterCriteria = FilterCriteria();
        when(
          mockRepository.getCampsites(),
        ).thenAnswer((_) async => Right(tCampsites));

        // act
        final result = await usecase.call(filterCriteria);

        // assert
        expect(result, Right(tCampsites));
        verify(mockRepository.getCampsites());
        verifyNever(mockRepository.getFilteredCampsites(any));
      });

      test('should return failure when getting all campsites fails', () async {
        // arrange
        const filterCriteria = FilterCriteria();
        const tFailure = NetworkFailure('Network connection failed');
        when(
          mockRepository.getCampsites(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase.call(filterCriteria);

        // assert
        expect(result, const Left(tFailure));
        verify(mockRepository.getCampsites());
      });
    });

    group('call with active filters', () {
      test(
        'should return filtered campsites when filters are active',
        () async {
          // arrange
          const filterCriteria = FilterCriteria(isCloseToWater: true);
          when(
            mockRepository.getFilteredCampsites(filterCriteria),
          ).thenAnswer((_) async => Right(filteredCampsites));

          // act
          final result = await usecase.call(filterCriteria);

          // assert
          expect(result, isA<Right<Failure, List<Campsite>>>());
          final campsites = result.fold((l) => null, (r) => r);
          expect(campsites!.length, 2);
          // Results should be sorted by name
          expect(campsites.first.label, 'Alpine Lake Campsite');
          expect(campsites.last.label, 'Beachside Paradise');
          verify(mockRepository.getFilteredCampsites(filterCriteria));
          verifyNever(mockRepository.getCampsites());
        },
      );

      test('should return failure when filtered search fails', () async {
        // arrange
        const filterCriteria = FilterCriteria(isCloseToWater: true);
        const tFailure = CacheFailure('Cache read failed');
        when(
          mockRepository.getFilteredCampsites(filterCriteria),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase.call(filterCriteria);

        // assert
        expect(result, const Left(tFailure));
        verify(mockRepository.getFilteredCampsites(filterCriteria));
      });

      test('should sort filtered results by label', () async {
        // arrange
        const filterCriteria = FilterCriteria(isCampFireAllowed: true);
        final unsortedResults = [tCampsites[2], tCampsites[1]]; // Beach, Forest
        when(
          mockRepository.getFilteredCampsites(filterCriteria),
        ).thenAnswer((_) async => Right(unsortedResults));

        // act
        final result = await usecase.call(filterCriteria);

        // assert
        expect(result, isA<Right<Failure, List<Campsite>>>());
        final campsites = result.fold((l) => null, (r) => r);
        expect(campsites!.length, 2);
        expect(
          campsites.first.label,
          'Beachside Paradise',
        ); // Should come before 'Forest Retreat'
        expect(campsites.last.label, 'Forest Retreat');
      });

      test('should handle empty filtered results', () async {
        // arrange
        const filterCriteria = FilterCriteria(
          minPrice: 100.0,
        ); // No campsites match
        when(
          mockRepository.getFilteredCampsites(filterCriteria),
        ).thenAnswer((_) async => const Right([]));

        // act
        final result = await usecase.call(filterCriteria);

        // assert
        expect(result.fold((l) => null, (r) => r), isEmpty);
        verify(mockRepository.getFilteredCampsites(filterCriteria));
      });
    });

    group('filter criteria scenarios', () {
      test('should handle water filter', () async {
        // arrange
        const filterCriteria = FilterCriteria(isCloseToWater: true);
        when(
          mockRepository.getFilteredCampsites(filterCriteria),
        ).thenAnswer((_) async => Right(filteredCampsites));

        // act
        final result = await usecase.call(filterCriteria);

        // assert
        expect(result, isA<Right<Failure, List<Campsite>>>());
        verify(mockRepository.getFilteredCampsites(filterCriteria));
      });

      test('should handle campfire filter', () async {
        // arrange
        const filterCriteria = FilterCriteria(isCampFireAllowed: true);
        final campfireCampsites = [tCampsites[1], tCampsites[2]];
        when(
          mockRepository.getFilteredCampsites(filterCriteria),
        ).thenAnswer((_) async => Right(campfireCampsites));

        // act
        final result = await usecase.call(filterCriteria);

        // assert
        expect(result, isA<Right<Failure, List<Campsite>>>());
        verify(mockRepository.getFilteredCampsites(filterCriteria));
      });

      test('should handle language filter', () async {
        // arrange
        const filterCriteria = FilterCriteria(hostLanguages: ['de']);
        final germanCampsites = [tCampsites[0]];
        when(
          mockRepository.getFilteredCampsites(filterCriteria),
        ).thenAnswer((_) async => Right(germanCampsites));

        // act
        final result = await usecase.call(filterCriteria);

        // assert
        expect(result, isA<Right<Failure, List<Campsite>>>());
        verify(mockRepository.getFilteredCampsites(filterCriteria));
      });

      test('should handle price range filter', () async {
        // arrange
        const filterCriteria = FilterCriteria(minPrice: 20.0, maxPrice: 35.0);
        final priceRangeCampsites = [tCampsites[0], tCampsites[1]];
        when(
          mockRepository.getFilteredCampsites(filterCriteria),
        ).thenAnswer((_) async => Right(priceRangeCampsites));

        // act
        final result = await usecase.call(filterCriteria);

        // assert
        expect(result, isA<Right<Failure, List<Campsite>>>());
        verify(mockRepository.getFilteredCampsites(filterCriteria));
      });

      test('should handle combined filters', () async {
        // arrange
        const filterCriteria = FilterCriteria(
          isCloseToWater: true,
          isCampFireAllowed: true,
          maxPrice: 50.0,
        );
        final combinedResults = [tCampsites[2]]; // Only beachside matches all
        when(
          mockRepository.getFilteredCampsites(filterCriteria),
        ).thenAnswer((_) async => Right(combinedResults));

        // act
        final result = await usecase.call(filterCriteria);

        // assert
        expect(result, isA<Right<Failure, List<Campsite>>>());
        final campsites = result.fold((l) => null, (r) => r);
        expect(campsites!.length, 1);
        expect(campsites.first.label, 'Beachside Paradise');
        verify(mockRepository.getFilteredCampsites(filterCriteria));
      });
    });

    group('error handling', () {
      test('should handle exception and return GeneralFailure', () async {
        // arrange
        const filterCriteria = FilterCriteria(isCloseToWater: true);
        when(
          mockRepository.getFilteredCampsites(filterCriteria),
        ).thenThrow(Exception('Database connection failed'));

        // act
        final result = await usecase.call(filterCriteria);

        // assert
        expect(result, isA<Left<Failure, List<Campsite>>>());
        final failure = result.fold((l) => l, (r) => null);
        expect(failure, isA<GeneralFailure>());
        expect(failure!.message, contains('Failed to filter campsites'));
        verify(mockRepository.getFilteredCampsites(filterCriteria));
      });

      test('should handle validation failure from repository', () async {
        // arrange
        const filterCriteria = FilterCriteria(minPrice: -10.0); // Invalid price
        const tFailure = ValidationFailure('Invalid price range');
        when(
          mockRepository.getFilteredCampsites(filterCriteria),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase.call(filterCriteria);

        // assert
        expect(result, const Left(tFailure));
        verify(mockRepository.getFilteredCampsites(filterCriteria));
      });

      test('should handle server failure during filtering', () async {
        // arrange
        const filterCriteria = FilterCriteria(hostLanguages: ['en']);
        const tFailure = ServerFailure(
          'Internal server error',
          statusCode: 500,
        );
        when(
          mockRepository.getFilteredCampsites(filterCriteria),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase.call(filterCriteria);

        // assert
        expect(result, const Left(tFailure));
        verify(mockRepository.getFilteredCampsites(filterCriteria));
      });
    });

    group('performance and edge cases', () {
      test('should handle large result sets', () async {
        // arrange
        const filterCriteria = FilterCriteria(hostLanguages: ['en']);
        final largeCampsiteList = List.generate(
          1000,
          (index) => tCampsites[0].copyWith(
            id: 'campsite_$index',
            label: 'Campsite $index',
          ),
        );
        when(
          mockRepository.getFilteredCampsites(filterCriteria),
        ).thenAnswer((_) async => Right(largeCampsiteList));

        // act
        final result = await usecase.call(filterCriteria);

        // assert
        expect(result, isA<Right<Failure, List<Campsite>>>());
        final campsites = result.fold((l) => null, (r) => r);
        expect(campsites!.length, 1000);
        verify(mockRepository.getFilteredCampsites(filterCriteria));
      });

      test('should handle concurrent filter requests', () async {
        // arrange
        const filterCriteria1 = FilterCriteria(isCloseToWater: true);
        const filterCriteria2 = FilterCriteria(isCampFireAllowed: true);

        when(
          mockRepository.getFilteredCampsites(filterCriteria1),
        ).thenAnswer((_) async => Right([tCampsites[0]]));
        when(
          mockRepository.getFilteredCampsites(filterCriteria2),
        ).thenAnswer((_) async => Right([tCampsites[1]]));

        // act
        final futures = [
          usecase.call(filterCriteria1),
          usecase.call(filterCriteria2),
        ];
        final results = await Future.wait(futures);

        // assert
        expect(results[0], isA<Right<Failure, List<Campsite>>>());
        expect(results[1], isA<Right<Failure, List<Campsite>>>());
        verify(mockRepository.getFilteredCampsites(filterCriteria1));
        verify(mockRepository.getFilteredCampsites(filterCriteria2));
      });
    });
  });
}
