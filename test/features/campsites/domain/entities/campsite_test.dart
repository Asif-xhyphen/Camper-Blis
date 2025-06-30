import 'package:flutter_test/flutter_test.dart';
import 'package:camper_blis/features/campsites/domain/entities/campsite.dart';
import 'package:camper_blis/features/campsites/domain/entities/geo_location.dart';

void main() {
  group('Campsite', () {
    late Campsite testCampsite;

    setUp(() {
      testCampsite = Campsite(
        id: 'test_id',
        label: 'Beautiful Mountain Campsite',
        geoLocation: const GeoLocation(latitude: 46.8, longitude: 8.2),
        createdAt: DateTime(2024, 1, 15),
        isCloseToWater: true,
        isCampFireAllowed: false,
        hostLanguages: const ['en', 'de', 'fr'],
        pricePerNight: 35.50,
        photo: 'https://example.com/campsite.jpg',
        suitableFor: const ['tent', 'rv'],
      );
    });

    group('constructor', () {
      test('should create campsite with all required fields', () {
        expect(testCampsite.id, 'test_id');
        expect(testCampsite.label, 'Beautiful Mountain Campsite');
        expect(testCampsite.geoLocation.latitude, 46.8);
        expect(testCampsite.geoLocation.longitude, 8.2);
        expect(testCampsite.createdAt, DateTime(2024, 1, 15));
        expect(testCampsite.isCloseToWater, true);
        expect(testCampsite.isCampFireAllowed, false);
        expect(testCampsite.hostLanguages, ['en', 'de', 'fr']);
        expect(testCampsite.pricePerNight, 35.50);
        expect(testCampsite.photo, 'https://example.com/campsite.jpg');
        expect(testCampsite.suitableFor, ['tent', 'rv']);
      });

      test('should create campsite with different configurations', () {
        final campsite = Campsite(
          id: 'different_id',
          label: 'Budget Campsite',
          geoLocation: const GeoLocation(latitude: 0.0, longitude: 0.0),
          createdAt: DateTime(2023, 12, 1),
          isCloseToWater: false,
          isCampFireAllowed: true,
          hostLanguages: const ['es'],
          pricePerNight: 15.0,
          photo: 'https://different.com/photo.jpg',
          suitableFor: const ['tent'],
        );

        expect(campsite.id, 'different_id');
        expect(campsite.isCloseToWater, false);
        expect(campsite.isCampFireAllowed, true);
        expect(campsite.hostLanguages.length, 1);
        expect(campsite.pricePerNight, 15.0);
      });
    });

    group('formattedPrice', () {
      test('should format price with Euro symbol and no decimals', () {
        expect(testCampsite.formattedPrice, '€36 / night');
      });

      test('should format whole number prices correctly', () {
        final campsite = testCampsite.copyWith(pricePerNight: 25.0);
        expect(campsite.formattedPrice, '€25 / night');
      });

      test('should round decimal prices to nearest whole number', () {
        final campsite1 = testCampsite.copyWith(pricePerNight: 25.4);
        final campsite2 = testCampsite.copyWith(pricePerNight: 25.6);

        expect(campsite1.formattedPrice, '€25 / night');
        expect(campsite2.formattedPrice, '€26 / night');
      });

      test('should handle zero price', () {
        final campsite = testCampsite.copyWith(pricePerNight: 0.0);
        expect(campsite.formattedPrice, '€0 / night');
      });

      test('should handle very high prices', () {
        final campsite = testCampsite.copyWith(pricePerNight: 999.99);
        expect(campsite.formattedPrice, '€1000 / night');
      });
    });

    group('amenities', () {
      test('should return both amenities when both are true', () {
        final campsite = testCampsite.copyWith(
          isCloseToWater: true,
          isCampFireAllowed: true,
        );
        final amenities = campsite.amenities;

        expect(amenities.length, 2);
        expect(amenities, contains('Close to Water'));
        expect(amenities, contains('Campfire Allowed'));
      });

      test('should return only water amenity when only water is true', () {
        final campsite = testCampsite.copyWith(
          isCloseToWater: true,
          isCampFireAllowed: false,
        );
        final amenities = campsite.amenities;

        expect(amenities.length, 1);
        expect(amenities, contains('Close to Water'));
        expect(amenities, isNot(contains('Campfire Allowed')));
      });

      test(
        'should return only campfire amenity when only campfire is true',
        () {
          final campsite = testCampsite.copyWith(
            isCloseToWater: false,
            isCampFireAllowed: true,
          );
          final amenities = campsite.amenities;

          expect(amenities.length, 1);
          expect(amenities, contains('Campfire Allowed'));
          expect(amenities, isNot(contains('Close to Water')));
        },
      );

      test('should return empty list when no amenities are available', () {
        final campsite = testCampsite.copyWith(
          isCloseToWater: false,
          isCampFireAllowed: false,
        );
        final amenities = campsite.amenities;

        expect(amenities.isEmpty, true);
      });
    });

    group('matchesSearchTerm', () {
      test('should match search term in label (case insensitive)', () {
        expect(testCampsite.matchesSearchTerm('mountain'), true);
        expect(testCampsite.matchesSearchTerm('MOUNTAIN'), true);
        expect(testCampsite.matchesSearchTerm('Mountain'), true);
        expect(testCampsite.matchesSearchTerm('beautiful'), true);
        expect(testCampsite.matchesSearchTerm('campsite'), true);
      });

      test('should match search term in host languages', () {
        expect(testCampsite.matchesSearchTerm('en'), true);
        expect(testCampsite.matchesSearchTerm('de'), true);
        expect(testCampsite.matchesSearchTerm('fr'), true);
        expect(testCampsite.matchesSearchTerm('EN'), true);
      });

      test('should not match search term not in label or languages', () {
        expect(testCampsite.matchesSearchTerm('beach'), false);
        expect(testCampsite.matchesSearchTerm('spanish'), false);
        expect(testCampsite.matchesSearchTerm('es'), false);
        expect(testCampsite.matchesSearchTerm('xyz'), false);
      });

      test('should handle empty search term', () {
        expect(testCampsite.matchesSearchTerm(''), true);
      });

      test('should handle partial matches in label', () {
        expect(testCampsite.matchesSearchTerm('beauti'), true);
        expect(testCampsite.matchesSearchTerm('mount'), true);
        expect(testCampsite.matchesSearchTerm('site'), true);
      });

      test('should handle whitespace in search terms', () {
        expect(testCampsite.matchesSearchTerm(' mountain '), true);
        expect(testCampsite.matchesSearchTerm('  beautiful  '), true);
      });

      test('should handle special characters', () {
        final campsite = testCampsite.copyWith(
          label: 'Café & Restaurant Campsite',
        );
        expect(campsite.matchesSearchTerm('café'), true);
        expect(campsite.matchesSearchTerm('restaurant'), true);
        expect(campsite.matchesSearchTerm('&'), true);
      });
    });

    group('briefDescription', () {
      test('should describe waterfront and campfire features', () {
        final campsite = testCampsite.copyWith(
          isCloseToWater: true,
          isCampFireAllowed: true,
        );
        expect(
          campsite.briefDescription,
          'Campsite with waterfront and campfire features',
        );
      });

      test('should describe only waterfront feature', () {
        final campsite = testCampsite.copyWith(
          isCloseToWater: true,
          isCampFireAllowed: false,
        );
        expect(campsite.briefDescription, 'Campsite with waterfront features');
      });

      test('should describe only campfire feature', () {
        final campsite = testCampsite.copyWith(
          isCloseToWater: false,
          isCampFireAllowed: true,
        );
        expect(campsite.briefDescription, 'Campsite with campfire features');
      });

      test('should describe host languages when no special features', () {
        final campsite = testCampsite.copyWith(
          isCloseToWater: false,
          isCampFireAllowed: false,
          hostLanguages: ['en', 'de'],
        );
        expect(
          campsite.briefDescription,
          'Campsite with en, de speaking hosts',
        );
      });

      test('should handle single host language', () {
        final campsite = testCampsite.copyWith(
          isCloseToWater: false,
          isCampFireAllowed: false,
          hostLanguages: ['es'],
        );
        expect(campsite.briefDescription, 'Campsite with es speaking hosts');
      });

      test('should handle empty host languages', () {
        final campsite = testCampsite.copyWith(
          isCloseToWater: false,
          isCampFireAllowed: false,
          hostLanguages: [],
        );
        expect(campsite.briefDescription, 'Campsite with  speaking hosts');
      });
    });

    group('primaryHostLanguage', () {
      test('should return first host language when available', () {
        expect(testCampsite.primaryHostLanguage, 'en');
      });

      test('should return first language from different list', () {
        final campsite = testCampsite.copyWith(
          hostLanguages: ['fr', 'it', 'es'],
        );
        expect(campsite.primaryHostLanguage, 'fr');
      });

      test('should return "en" when host languages list is empty', () {
        final campsite = testCampsite.copyWith(hostLanguages: []);
        expect(campsite.primaryHostLanguage, 'en');
      });

      test('should handle single language', () {
        final campsite = testCampsite.copyWith(hostLanguages: ['zh']);
        expect(campsite.primaryHostLanguage, 'zh');
      });
    });

    group('equality and copying', () {
      test('should be equal when all properties are the same', () {
        final campsite1 = Campsite(
          id: 'test',
          label: 'Test Campsite',
          geoLocation: const GeoLocation(latitude: 1.0, longitude: 2.0),
          createdAt: DateTime(2024, 1, 1),
          isCloseToWater: true,
          isCampFireAllowed: false,
          hostLanguages: const ['en'],
          pricePerNight: 25.0,
          photo: 'photo.jpg',
          suitableFor: const ['tent'],
        );

        final campsite2 = Campsite(
          id: 'test',
          label: 'Test Campsite',
          geoLocation: const GeoLocation(latitude: 1.0, longitude: 2.0),
          createdAt: DateTime(2024, 1, 1),
          isCloseToWater: true,
          isCampFireAllowed: false,
          hostLanguages: const ['en'],
          pricePerNight: 25.0,
          photo: 'photo.jpg',
          suitableFor: const ['tent'],
        );

        expect(campsite1, equals(campsite2));
      });

      test('should not be equal when properties differ', () {
        final campsite1 = testCampsite;
        final campsite2 = testCampsite.copyWith(id: 'different_id');

        expect(campsite1, isNot(equals(campsite2)));
      });

      test('should copy with changed properties', () {
        final copiedCampsite = testCampsite.copyWith(
          label: 'New Label',
          pricePerNight: 50.0,
        );

        expect(copiedCampsite.id, testCampsite.id); // unchanged
        expect(copiedCampsite.label, 'New Label'); // changed
        expect(copiedCampsite.pricePerNight, 50.0); // changed
        expect(
          copiedCampsite.isCloseToWater,
          testCampsite.isCloseToWater,
        ); // unchanged
      });
    });

    group('edge cases and validation', () {
      test('should handle very long labels', () {
        final longLabel = 'A' * 1000;
        final campsite = testCampsite.copyWith(label: longLabel);

        expect(campsite.label, longLabel);
        expect(campsite.matchesSearchTerm('A'), true);
        expect(campsite.briefDescription, contains('features'));
      });

      test('should handle many host languages', () {
        final manyLanguages = List.generate(50, (index) => 'lang$index');
        final campsite = testCampsite.copyWith(
          hostLanguages: manyLanguages,
          isCloseToWater: false,
          isCampFireAllowed: false,
        );

        expect(campsite.hostLanguages.length, 50);
        expect(campsite.primaryHostLanguage, 'lang0');
        expect(campsite.briefDescription, contains('speaking hosts'));
      });

      test('should handle extreme coordinates', () {
        final campsite = testCampsite.copyWith(
          geoLocation: const GeoLocation(latitude: -90.0, longitude: -180.0),
        );

        expect(campsite.geoLocation.latitude, -90.0);
        expect(campsite.geoLocation.longitude, -180.0);
      });

      test('should handle future dates', () {
        final futureDate = DateTime(2030, 12, 31);
        final campsite = testCampsite.copyWith(createdAt: futureDate);

        expect(campsite.createdAt, futureDate);
      });
    });
  });
}
