import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:camper_blis/features/campsites/domain/entities/geo_location.dart';

void main() {
  group('GeoLocation', () {
    group('constructor', () {
      test('should create GeoLocation with valid coordinates', () {
        const geoLocation = GeoLocation(latitude: 52.5, longitude: 13.4);

        expect(geoLocation.latitude, 52.5);
        expect(geoLocation.longitude, 13.4);
      });

      test('should create GeoLocation with boundary coordinates', () {
        const maxCoords = GeoLocation(latitude: 90.0, longitude: 180.0);
        const minCoords = GeoLocation(latitude: -90.0, longitude: -180.0);

        expect(maxCoords.latitude, 90.0);
        expect(maxCoords.longitude, 180.0);
        expect(minCoords.latitude, -90.0);
        expect(minCoords.longitude, -180.0);
      });

      test('should create GeoLocation with zero coordinates', () {
        const geoLocation = GeoLocation(latitude: 0.0, longitude: 0.0);

        expect(geoLocation.latitude, 0.0);
        expect(geoLocation.longitude, 0.0);
      });
    });

    group('isValid', () {
      test('should return true for valid coordinates', () {
        const validLocations = [
          GeoLocation(latitude: 0.0, longitude: 0.0),
          GeoLocation(latitude: 52.5, longitude: 13.4),
          GeoLocation(latitude: -33.8, longitude: 151.2),
          GeoLocation(latitude: 90.0, longitude: 180.0),
          GeoLocation(latitude: -90.0, longitude: -180.0),
        ];

        for (final location in validLocations) {
          expect(
            location.isValid,
            true,
            reason: 'Location $location should be valid',
          );
        }
      });

      test('should return false for invalid latitude', () {
        const invalidLatitudes = [
          GeoLocation(latitude: 91.0, longitude: 0.0),
          GeoLocation(latitude: -91.0, longitude: 0.0),
          GeoLocation(latitude: 180.0, longitude: 0.0),
          GeoLocation(latitude: -180.0, longitude: 0.0),
        ];

        for (final location in invalidLatitudes) {
          expect(
            location.isValid,
            false,
            reason: 'Location $location should be invalid',
          );
        }
      });

      test('should return false for invalid longitude', () {
        const invalidLongitudes = [
          GeoLocation(latitude: 0.0, longitude: 181.0),
          GeoLocation(latitude: 0.0, longitude: -181.0),
          GeoLocation(latitude: 0.0, longitude: 360.0),
          GeoLocation(latitude: 0.0, longitude: -360.0),
        ];

        for (final location in invalidLongitudes) {
          expect(
            location.isValid,
            false,
            reason: 'Location $location should be invalid',
          );
        }
      });

      test('should return false when both coordinates are invalid', () {
        const invalidLocations = [
          GeoLocation(latitude: 91.0, longitude: 181.0),
          GeoLocation(latitude: -91.0, longitude: -181.0),
          GeoLocation(latitude: 100.0, longitude: 200.0),
        ];

        for (final location in invalidLocations) {
          expect(
            location.isValid,
            false,
            reason: 'Location $location should be invalid',
          );
        }
      });
    });

    group('displayCoordinates', () {
      test('should format coordinates with 6 decimal places', () {
        const geoLocation = GeoLocation(latitude: 52.5, longitude: 13.4);
        expect(geoLocation.displayCoordinates, '52.500000, 13.400000');
      });

      test('should format coordinates with proper precision', () {
        const geoLocation = GeoLocation(
          latitude: 52.123456789,
          longitude: 13.987654321,
        );
        expect(geoLocation.displayCoordinates, '52.123457, 13.987654');
      });

      test('should format negative coordinates correctly', () {
        const geoLocation = GeoLocation(
          latitude: -33.8568,
          longitude: -151.2153,
        );
        expect(geoLocation.displayCoordinates, '-33.856800, -151.215300');
      });

      test('should format zero coordinates correctly', () {
        const geoLocation = GeoLocation(latitude: 0.0, longitude: 0.0);
        expect(geoLocation.displayCoordinates, '0.000000, 0.000000');
      });

      test('should format boundary coordinates correctly', () {
        const maxCoords = GeoLocation(latitude: 90.0, longitude: 180.0);
        const minCoords = GeoLocation(latitude: -90.0, longitude: -180.0);

        expect(maxCoords.displayCoordinates, '90.000000, 180.000000');
        expect(minCoords.displayCoordinates, '-90.000000, -180.000000');
      });
    });

    group('distanceTo', () {
      test('should return zero distance for same location', () {
        const location1 = GeoLocation(latitude: 52.5, longitude: 13.4);
        const location2 = GeoLocation(latitude: 52.5, longitude: 13.4);

        final distance = location1.distanceTo(location2);
        expect(distance, closeTo(0.0, 0.001));
      });

      test('should calculate distance between Berlin and Paris correctly', () {
        // Berlin: 52.5200° N, 13.4050° E
        const berlin = GeoLocation(latitude: 52.5200, longitude: 13.4050);
        // Paris: 48.8566° N, 2.3522° E
        const paris = GeoLocation(latitude: 48.8566, longitude: 2.3522);

        final distance = berlin.distanceTo(paris);
        // Expected distance is approximately 878 km
        expect(distance, closeTo(878, 5)); // Allow 5km tolerance
      });

      test(
        'should calculate distance between New York and London correctly',
        () {
          // New York: 40.7128° N, 74.0060° W
          const newYork = GeoLocation(latitude: 40.7128, longitude: -74.0060);
          // London: 51.5074° N, 0.1278° W
          const london = GeoLocation(latitude: 51.5074, longitude: -0.1278);

          final distance = newYork.distanceTo(london);
          // Expected distance is approximately 5585 km
          expect(distance, closeTo(5585, 50)); // Allow 50km tolerance
        },
      );

      test(
        'should calculate distance between Sydney and Melbourne correctly',
        () {
          // Sydney: -33.8688° S, 151.2093° E
          const sydney = GeoLocation(latitude: -33.8688, longitude: 151.2093);
          // Melbourne: -37.8136° S, 144.9631° E
          const melbourne = GeoLocation(
            latitude: -37.8136,
            longitude: 144.9631,
          );

          final distance = sydney.distanceTo(melbourne);
          // Expected distance is approximately 714 km
          expect(distance, closeTo(714, 10)); // Allow 10km tolerance
        },
      );

      test('should be symmetric (distance A to B equals distance B to A)', () {
        const location1 = GeoLocation(latitude: 52.5, longitude: 13.4);
        const location2 = GeoLocation(latitude: 48.8, longitude: 2.3);

        final distance1to2 = location1.distanceTo(location2);
        final distance2to1 = location2.distanceTo(location1);

        expect(distance1to2, closeTo(distance2to1, 0.001));
      });

      test('should handle locations across the date line', () {
        // Location in Russia (east of 180°)
        const eastLocation = GeoLocation(latitude: 55.0, longitude: 179.0);
        // Location in Alaska (west of -180°)
        const westLocation = GeoLocation(latitude: 55.0, longitude: -179.0);

        final distance = eastLocation.distanceTo(westLocation);
        // These locations are actually close (crossing the date line)
        expect(distance, lessThan(500)); // Should be less than 500km
      });

      test('should handle polar coordinates', () {
        const northPole = GeoLocation(latitude: 90.0, longitude: 0.0);
        const southPole = GeoLocation(latitude: -90.0, longitude: 0.0);

        final distance = northPole.distanceTo(southPole);
        // Distance from north to south pole is approximately half Earth's circumference
        expect(distance, closeTo(20015, 100)); // Allow 100km tolerance
      });

      test('should handle equatorial coordinates', () {
        const equator1 = GeoLocation(latitude: 0.0, longitude: 0.0);
        const equator2 = GeoLocation(latitude: 0.0, longitude: 90.0);

        final distance = equator1.distanceTo(equator2);
        // Quarter of Earth's circumference at equator
        expect(distance, closeTo(10007, 50)); // Allow 50km tolerance
      });
    });

    group('edge cases and precision', () {
      test('should handle very small coordinate differences', () {
        const location1 = GeoLocation(latitude: 52.5, longitude: 13.4);
        const location2 = GeoLocation(
          latitude: 52.5000001,
          longitude: 13.4000001,
        );

        final distance = location1.distanceTo(location2);
        expect(distance, lessThan(1.0)); // Should be less than 1km
      });

      test('should handle maximum coordinate values', () {
        const maxLat = GeoLocation(latitude: 90.0, longitude: 180.0);
        const minLat = GeoLocation(latitude: -90.0, longitude: -180.0);

        expect(() => maxLat.distanceTo(minLat), returnsNormally);
        expect(maxLat.isValid, true);
        expect(minLat.isValid, true);
      });

      test('should maintain precision in calculations', () {
        const highPrecisionLocation = GeoLocation(
          latitude: 52.123456789123456,
          longitude: 13.987654321987654,
        );

        expect(highPrecisionLocation.latitude, 52.123456789123456);
        expect(highPrecisionLocation.longitude, 13.987654321987654);
        expect(highPrecisionLocation.isValid, true);
      });
    });

    group('equality and copying', () {
      test('should be equal when coordinates are the same', () {
        const location1 = GeoLocation(latitude: 52.5, longitude: 13.4);
        const location2 = GeoLocation(latitude: 52.5, longitude: 13.4);

        expect(location1, equals(location2));
        expect(location1.hashCode, equals(location2.hashCode));
      });

      test('should not be equal when coordinates differ', () {
        const location1 = GeoLocation(latitude: 52.5, longitude: 13.4);
        const location2 = GeoLocation(latitude: 52.6, longitude: 13.4);
        const location3 = GeoLocation(latitude: 52.5, longitude: 13.5);

        expect(location1, isNot(equals(location2)));
        expect(location1, isNot(equals(location3)));
      });

      test('should handle precision differences in equality', () {
        const location1 = GeoLocation(latitude: 52.5, longitude: 13.4);
        const location2 = GeoLocation(
          latitude: 52.50000000001,
          longitude: 13.4,
        );

        // These should be different due to precision
        expect(location1, isNot(equals(location2)));
      });
    });

    group('toString representation', () {
      test('should have meaningful string representation', () {
        const location = GeoLocation(latitude: 52.5, longitude: 13.4);
        final stringRep = location.toString();

        expect(stringRep, contains('52.5'));
        expect(stringRep, contains('13.4'));
      });
    });
  });
}
