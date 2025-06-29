import 'package:flutter_test/flutter_test.dart';
import 'package:camper_blis/core/utils/coordinate_utils.dart';
import 'package:camper_blis/features/campsites/domain/entities/geo_location.dart';

void main() {
  group('CoordinateUtils', () {
    group('calculateDistance', () {
      test('should calculate distance correctly between two points', () {
        // Berlin to Paris
        final distance = CoordinateUtils.calculateDistance(
          52.5200,
          13.4050, // Berlin
          48.8566,
          2.3522, // Paris
        );
        expect(distance, closeTo(878, 50)); // Allow 50km tolerance

        // Distance to same point should be 0
        final samePointDistance = CoordinateUtils.calculateDistance(
          52.5200,
          13.4050,
          52.5200,
          13.4050,
        );
        expect(samePointDistance, closeTo(0, 0.1));
      });

      test('should handle antipodal points', () {
        final distance = CoordinateUtils.calculateDistance(
          45.0,
          0.0,
          -45.0,
          180.0,
        );
        expect(distance, greaterThan(15000)); // Should be more than 15,000 km
      });
    });

    group('calculateCenter', () {
      test('should calculate center point correctly', () {
        final coordinates = [
          {'latitude': 52.0, 'longitude': 13.0},
          {'latitude': 53.0, 'longitude': 14.0},
          {'latitude': 51.0, 'longitude': 12.0},
        ];

        final center = CoordinateUtils.calculateCenter(coordinates);
        expect(center, isNotNull);
        expect(center!['latitude'], closeTo(52.0, 0.1));
        expect(center['longitude'], closeTo(13.0, 0.1));
      });

      test('should return null for empty list', () {
        final center = CoordinateUtils.calculateCenter([]);
        expect(center, isNull);
      });

      test('should handle invalid coordinates', () {
        final coordinates = [
          {'latitude': 100.0, 'longitude': 200.0}, // Invalid
          {'latitude': 52.0, 'longitude': 13.0}, // Valid
        ];

        final center = CoordinateUtils.calculateCenter(coordinates);
        expect(center, isNotNull);
        expect(center!['latitude'], closeTo(52.0, 0.1));
        expect(center['longitude'], closeTo(13.0, 0.1));
      });
    });

    group('getFallbackCoordinates', () {
      test('should return correct coordinates for known countries', () {
        final germanyCoords = CoordinateUtils.getFallbackCoordinates('Germany');
        expect(germanyCoords['latitude'], 51.1657);
        expect(germanyCoords['longitude'], 10.4515);

        final franceCoords = CoordinateUtils.getFallbackCoordinates('France');
        expect(franceCoords['latitude'], 46.6034);
        expect(franceCoords['longitude'], 1.8883);
      });

      test('should handle case insensitive country names', () {
        final germanyCoords = CoordinateUtils.getFallbackCoordinates('GERMANY');
        expect(germanyCoords['latitude'], 51.1657);
        expect(germanyCoords['longitude'], 10.4515);
      });

      test('should return default coordinates for unknown countries', () {
        final unknownCoords = CoordinateUtils.getFallbackCoordinates(
          'Unknown Country',
        );
        expect(unknownCoords, isNotNull);
        expect(unknownCoords['latitude'], isA<double>());
        expect(unknownCoords['longitude'], isA<double>());
      });
    });

    group('sanitizeCoordinates', () {
      test('should return original valid coordinates', () {
        final result = CoordinateUtils.sanitizeCoordinates(
          latitude: 52.5200,
          longitude: 13.4050,
          country: 'Germany',
        );

        expect(result['latitude'], 52.5200);
        expect(result['longitude'], 13.4050);
      });

      test('should return fallback for null coordinates', () {
        final result = CoordinateUtils.sanitizeCoordinates(
          latitude: null,
          longitude: null,
          country: 'Germany',
        );

        expect(result['latitude'], 51.1657);
        expect(result['longitude'], 10.4515);
      });

      test('should return fallback for invalid coordinates', () {
        final result = CoordinateUtils.sanitizeCoordinates(
          latitude: 100.0, // Invalid
          longitude: 200.0, // Invalid
          country: 'Germany',
        );

        expect(result['latitude'], 51.1657);
        expect(result['longitude'], 10.4515);
      });
    });

    group('isWithinBounds', () {
      test('should return true for coordinates within bounds', () {
        final result = CoordinateUtils.isWithinBounds(
          latitude: 52.5,
          longitude: 13.4,
          northBound: 53.0,
          southBound: 52.0,
          eastBound: 14.0,
          westBound: 13.0,
        );

        expect(result, true);
      });

      test('should return false for coordinates outside bounds', () {
        final result = CoordinateUtils.isWithinBounds(
          latitude: 54.0, // Outside north bound
          longitude: 13.4,
          northBound: 53.0,
          southBound: 52.0,
          eastBound: 14.0,
          westBound: 13.0,
        );

        expect(result, false);
      });
    });

    group('calculateBoundingBox', () {
      test('should calculate bounding box correctly', () {
        final boundingBox = CoordinateUtils.calculateBoundingBox(
          centerLat: 52.5200,
          centerLon: 13.4050,
          radiusKm: 10.0,
        );

        expect(boundingBox, isNotNull);
        expect(boundingBox['northBound'], greaterThan(52.5200));
        expect(boundingBox['southBound'], lessThan(52.5200));
        expect(boundingBox['eastBound'], greaterThan(13.4050));
        expect(boundingBox['westBound'], lessThan(13.4050));
      });
    });

    group('formatCoordinates', () {
      test('should format coordinates correctly', () {
        expect(
          CoordinateUtils.formatCoordinates(52.5200, 13.4050),
          '52.5200°N, 13.4050°E',
        );

        expect(
          CoordinateUtils.formatCoordinates(-33.8688, -151.2093),
          '33.8688°S, 151.2093°W',
        );

        expect(
          CoordinateUtils.formatCoordinates(0.0, 0.0),
          '0.0000°N, 0.0000°E',
        );
      });
    });

    group('generateRandomCoordinatesInCountry', () {
      test('should generate coordinates near country center', () {
        final randomCoords = CoordinateUtils.generateRandomCoordinatesInCountry(
          'Germany',
        );
        final germanyCenter = CoordinateUtils.getFallbackCoordinates('Germany');

        expect(randomCoords, isNotNull);
        expect(randomCoords['latitude'], isA<double>());
        expect(randomCoords['longitude'], isA<double>());

        // Should be within reasonable distance of country center
        final distance = CoordinateUtils.calculateDistance(
          randomCoords['latitude']!,
          randomCoords['longitude']!,
          germanyCenter['latitude']!,
          germanyCenter['longitude']!,
        );
        expect(distance, lessThan(100)); // Within 100km of center
      });
    });

    group('validateAndCorrect', () {
      test('should return original coordinates if valid', () {
        final result = CoordinateUtils.validateAndCorrect(
          52.5200,
          13.4050,
          'Germany',
        );
        expect(result.latitude, 52.5200);
        expect(result.longitude, 13.4050);
      });

      test('should return fallback for null coordinates', () {
        final result = CoordinateUtils.validateAndCorrect(
          null,
          null,
          'Germany',
        );
        expect(result, isA<GeoLocation>());
        expect(result.isValid, true);
      });

      test('should return fallback for invalid coordinates', () {
        final result = CoordinateUtils.validateAndCorrect(
          100.0,
          200.0,
          'Germany',
        );
        expect(result, isA<GeoLocation>());
        expect(result.isValid, true);
      });
    });

    group('calculateDistanceGeoLocation', () {
      test('should calculate distance between GeoLocation objects', () {
        const berlin = GeoLocation(latitude: 52.5200, longitude: 13.4050);
        const paris = GeoLocation(latitude: 48.8566, longitude: 2.3522);

        final distance = CoordinateUtils.calculateDistanceGeoLocation(
          berlin,
          paris,
        );
        expect(distance, closeTo(878, 50)); // Allow 50km tolerance
      });
    });

    group('isWithinRadius', () {
      test('should detect points within radius', () {
        const center = GeoLocation(latitude: 52.5200, longitude: 13.4050);
        const nearby = GeoLocation(latitude: 52.5210, longitude: 13.4060);
        const faraway = GeoLocation(latitude: 48.8566, longitude: 2.3522);

        expect(CoordinateUtils.isWithinRadius(center, nearby, 1.0), true);
        expect(CoordinateUtils.isWithinRadius(center, faraway, 1.0), false);
        expect(CoordinateUtils.isWithinRadius(center, faraway, 1000.0), true);
      });
    });

    group('Edge Cases', () {
      test('should handle extreme coordinate values', () {
        final distance = CoordinateUtils.calculateDistance(
          90.0,
          0.0,
          -90.0,
          0.0,
        );
        expect(distance, greaterThan(19000)); // Pole to pole distance

        final formatted = CoordinateUtils.formatCoordinates(90.0, 180.0);
        expect(formatted, contains('90.0000°N'));
        expect(formatted, contains('180.0000°E'));
      });

      test('should handle empty coordinate list', () {
        final center = CoordinateUtils.calculateCenter([]);
        expect(center, isNull);
      });

      test('should handle invalid coordinate data in list', () {
        final coordinates = <Map<String, double>>[
          {'latitude': 52.0, 'longitude': 13.0},
        ];

        final center = CoordinateUtils.calculateCenter(coordinates);
        expect(center, isNotNull);
        expect(center!['latitude'], 52.0);
        expect(center['longitude'], 13.0);
      });
    });

    test('should calculate distance correctly', () {
      const double lat1 = 47.3769;
      const double lon1 = 8.5417;
      const double lat2 = 46.9481;
      const double lon2 = 7.4474;

      final double distance = CoordinateUtils.calculateDistance(
        lat1,
        lon1,
        lat2,
        lon2,
      );

      expect(distance, greaterThan(0));
      expect(distance, lessThan(200)); // Should be within reasonable range
    });

    test(
      'should get consistent hardcoded coordinates for same campsite ID',
      () {
        const String campsiteId = 'test-campsite-123';

        final coordinates1 = CoordinateUtils.getHardcodedCoordinatesForCampsite(
          campsiteId,
        );
        final coordinates2 = CoordinateUtils.getHardcodedCoordinatesForCampsite(
          campsiteId,
        );

        expect(coordinates1['latitude'], equals(coordinates2['latitude']));
        expect(coordinates1['longitude'], equals(coordinates2['longitude']));
      },
    );

    test('should return different coordinates for different campsite IDs', () {
      const String campsiteId1 = 'campsite-001';
      const String campsiteId2 = 'campsite-002';

      final coordinates1 = CoordinateUtils.getHardcodedCoordinatesForCampsite(
        campsiteId1,
      );
      final coordinates2 = CoordinateUtils.getHardcodedCoordinatesForCampsite(
        campsiteId2,
      );

      // They should likely be different (though not guaranteed due to hash collisions)
      expect(coordinates1 != coordinates2, isTrue);
    });

    test('should return valid European coordinates', () {
      const String campsiteId = 'test-campsite-456';

      final coordinates = CoordinateUtils.getHardcodedCoordinatesForCampsite(
        campsiteId,
      );
      final double lat = coordinates['latitude']!;
      final double lon = coordinates['longitude']!;

      // Should be within European bounds (roughly)
      expect(lat, greaterThan(35.0)); // Southern Europe
      expect(lat, lessThan(72.0)); // Northern Europe
      expect(lon, greaterThan(-25.0)); // Western Europe
      expect(lon, lessThan(45.0)); // Eastern Europe
    });

    test('should return exactly 50 hardcoded coordinates', () {
      final allCoordinates = CoordinateUtils.getAllHardcodedCoordinates();

      expect(allCoordinates.length, equals(50));

      // Verify each coordinate has required fields
      for (final coordinate in allCoordinates) {
        expect(coordinate.containsKey('latitude'), isTrue);
        expect(coordinate.containsKey('longitude'), isTrue);
        expect(coordinate['latitude'], isA<double>());
        expect(coordinate['longitude'], isA<double>());
      }
    });

    test('should use hardcoded coordinates within valid ranges', () {
      final allCoordinates = CoordinateUtils.getAllHardcodedCoordinates();

      for (final coordinate in allCoordinates) {
        final double lat = coordinate['latitude']!;
        final double lon = coordinate['longitude']!;

        // Should be valid latitude/longitude values
        expect(lat, greaterThanOrEqualTo(-90.0));
        expect(lat, lessThanOrEqualTo(90.0));
        expect(lon, greaterThanOrEqualTo(-180.0));
        expect(lon, lessThanOrEqualTo(180.0));
      }
    });
  });
}
