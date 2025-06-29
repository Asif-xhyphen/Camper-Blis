import 'package:flutter_test/flutter_test.dart';
import 'package:camper_blis/features/campsites/domain/entities/campsite.dart';
import 'package:camper_blis/features/campsites/domain/entities/geo_location.dart';

void main() {
  group('Campsite Entity', () {
    late Campsite testCampsite;

    setUp(() {
      testCampsite = Campsite(
        id: '1',
        label: 'Beautiful Forest Campsite',
        geoLocation: const GeoLocation(latitude: 52.5200, longitude: 13.4050),
        createdAt: DateTime.parse('2024-01-15T10:30:00.000Z'),
        isCloseToWater: true,
        isCampFireAllowed: false,
        hostLanguages: const ['English', 'German'],
        pricePerNight: 25.50,
        photo: 'https://example.com/photo.jpg',
        suitableFor: const ['Couples', 'Family'],
      );
    });

    group('Business Logic Methods', () {
      test('formattedPrice should format price correctly', () {
        // Test with decimal price
        expect(testCampsite.formattedPrice, '€26 / night');

        // Test with zero price
        final freeCampsite = testCampsite.copyWith(pricePerNight: 0.0);
        expect(freeCampsite.formattedPrice, '€0 / night');

        // Test with high price
        final expensiveCampsite = testCampsite.copyWith(pricePerNight: 150.75);
        expect(expensiveCampsite.formattedPrice, '€151 / night');
      });

      test('amenities should return correct list based on features', () {
        // Test campsite with both amenities
        final bothAmenitiesCampsite = testCampsite.copyWith(
          isCloseToWater: true,
          isCampFireAllowed: true,
        );
        expect(bothAmenitiesCampsite.amenities, [
          'Close to Water',
          'Campfire Allowed',
        ]);

        // Test campsite with only water
        expect(testCampsite.amenities, ['Close to Water']);

        // Test campsite with only campfire
        final onlyCampfireCampsite = testCampsite.copyWith(
          isCloseToWater: false,
          isCampFireAllowed: true,
        );
        expect(onlyCampfireCampsite.amenities, ['Campfire Allowed']);

        // Test campsite with no amenities
        final noAmenitiesCampsite = testCampsite.copyWith(
          isCloseToWater: false,
          isCampFireAllowed: false,
        );
        expect(noAmenitiesCampsite.amenities, isEmpty);
      });

      test('matchesSearchTerm should work with different search terms', () {
        // Test exact label match
        expect(testCampsite.matchesSearchTerm('Beautiful'), true);
        expect(testCampsite.matchesSearchTerm('Forest'), true);
        expect(testCampsite.matchesSearchTerm('Campsite'), true);

        // Test case insensitive
        expect(testCampsite.matchesSearchTerm('BEAUTIFUL'), true);
        expect(testCampsite.matchesSearchTerm('forest'), true);

        // Test host language match
        expect(testCampsite.matchesSearchTerm('English'), true);
        expect(testCampsite.matchesSearchTerm('german'), true);

        // Test partial matches
        expect(testCampsite.matchesSearchTerm('Beaut'), true);
        expect(testCampsite.matchesSearchTerm('Eng'), true);

        // Test non-matching terms
        expect(testCampsite.matchesSearchTerm('Mountain'), false);
        expect(testCampsite.matchesSearchTerm('Spanish'), false);
        expect(testCampsite.matchesSearchTerm('xyz'), false);

        // Test empty search term
        expect(testCampsite.matchesSearchTerm(''), true);
      });

      test('briefDescription should generate appropriate descriptions', () {
        // Test with both features
        final bothFeaturesCampsite = testCampsite.copyWith(
          isCloseToWater: true,
          isCampFireAllowed: true,
        );
        expect(
          bothFeaturesCampsite.briefDescription,
          'Campsite with waterfront and campfire features',
        );

        // Test with only water
        expect(
          testCampsite.briefDescription,
          'Campsite with waterfront features',
        );

        // Test with only campfire
        final onlyCampfireCampsite = testCampsite.copyWith(
          isCloseToWater: false,
          isCampFireAllowed: true,
        );
        expect(
          onlyCampfireCampsite.briefDescription,
          'Campsite with campfire features',
        );

        // Test with no features
        final noFeaturesCampsite = testCampsite.copyWith(
          isCloseToWater: false,
          isCampFireAllowed: false,
        );
        expect(
          noFeaturesCampsite.briefDescription,
          'Campsite with English, German speaking hosts',
        );

        // Test with no features and single language
        final singleLanguageCampsite = testCampsite.copyWith(
          isCloseToWater: false,
          isCampFireAllowed: false,
          hostLanguages: ['English'],
        );
        expect(
          singleLanguageCampsite.briefDescription,
          'Campsite with English speaking hosts',
        );
      });

      test('primaryHostLanguage should return correct language', () {
        // Test with multiple languages
        expect(testCampsite.primaryHostLanguage, 'English');

        // Test with single language
        final singleLanguageCampsite = testCampsite.copyWith(
          hostLanguages: ['Spanish'],
        );
        expect(singleLanguageCampsite.primaryHostLanguage, 'Spanish');

        // Test with empty languages (fallback to 'en')
        final noLanguagesCampsite = testCampsite.copyWith(hostLanguages: []);
        expect(noLanguagesCampsite.primaryHostLanguage, 'en');
      });
    });

    group('Edge Cases', () {
      test('should handle special characters in search', () {
        final specialCharsCampsite = testCampsite.copyWith(
          label: 'Château & Überraschung Camping',
        );

        expect(specialCharsCampsite.matchesSearchTerm('Château'), true);
        expect(specialCharsCampsite.matchesSearchTerm('Überraschung'), true);
        expect(specialCharsCampsite.matchesSearchTerm('château'), true);
      });

      test('should handle empty and null-like values gracefully', () {
        final minimalCampsite = testCampsite.copyWith(
          hostLanguages: [],
          suitableFor: [],
        );

        expect(minimalCampsite.amenities, isA<List<String>>());
        expect(minimalCampsite.primaryHostLanguage, 'en');
        expect(minimalCampsite.briefDescription, contains('speaking hosts'));
      });

      test('should handle extreme price values', () {
        final freeCampsite = testCampsite.copyWith(pricePerNight: 0.0);
        expect(freeCampsite.formattedPrice, '€0 / night');

        final expensiveCampsite = testCampsite.copyWith(pricePerNight: 999.99);
        expect(expensiveCampsite.formattedPrice, '€1000 / night');
      });

      test('should be immutable (freezed)', () {
        // Verify that the entity is properly frozen
        expect(testCampsite, isA<Campsite>());
        expect(testCampsite.toString(), contains('Campsite'));

        // Test equality
        final identicalCampsite = Campsite(
          id: '1',
          label: 'Beautiful Forest Campsite',
          geoLocation: const GeoLocation(latitude: 52.5200, longitude: 13.4050),
          createdAt: DateTime.parse('2024-01-15T10:30:00.000Z'),
          isCloseToWater: true,
          isCampFireAllowed: false,
          hostLanguages: const ['English', 'German'],
          pricePerNight: 25.50,
          photo: 'https://example.com/photo.jpg',
          suitableFor: const ['Couples', 'Family'],
        );

        expect(testCampsite, equals(identicalCampsite));
        expect(testCampsite.hashCode, equals(identicalCampsite.hashCode));
      });
    });
  });
}
