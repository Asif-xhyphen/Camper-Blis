import 'package:flutter_test/flutter_test.dart';
import 'package:camper_blis/features/campsites/domain/entities/geo_location.dart';

void main() {
  group('GeoLocation Entity', () {
    group('Constructor and Basic Properties', () {
      test('should create GeoLocation with valid coordinates', () {
        // Arrange & Act
        const geoLocation = GeoLocation(latitude: 52.5200, longitude: 13.4050);

        // Assert
        expect(geoLocation.latitude, 52.5200);
        expect(geoLocation.longitude, 13.4050);
      });

      test('should handle extreme valid coordinates', () {
        // Test minimum values
        const minGeoLocation = GeoLocation(latitude: -90.0, longitude: -180.0);
        expect(minGeoLocation.latitude, -90.0);
        expect(minGeoLocation.longitude, -180.0);

        // Test maximum values
        const maxGeoLocation = GeoLocation(latitude: 90.0, longitude: 180.0);
        expect(maxGeoLocation.latitude, 90.0);
        expect(maxGeoLocation.longitude, 180.0);

        // Test zero coordinates
        const zeroGeoLocation = GeoLocation(latitude: 0.0, longitude: 0.0);
        expect(zeroGeoLocation.latitude, 0.0);
        expect(zeroGeoLocation.longitude, 0.0);
      });
    });

    group('Business Logic Methods', () {
      late GeoLocation berlinLocation;
      late GeoLocation parisLocation;
      late GeoLocation newYorkLocation;

      setUp(() {
        berlinLocation = const GeoLocation(
          latitude: 52.5200,
          longitude: 13.4050,
        );
        parisLocation = const GeoLocation(latitude: 48.8566, longitude: 2.3522);
        newYorkLocation = const GeoLocation(
          latitude: 40.7128,
          longitude: -74.0060,
        );
      });

      test('distanceTo should calculate distance correctly', () {
        // Distance from Berlin to Paris (approximately 878 km)
        final distanceBerlinParis = berlinLocation.distanceTo(parisLocation);
        expect(distanceBerlinParis, closeTo(878, 50)); // Allow 50km tolerance

        // Distance from Berlin to New York (approximately 6385 km)
        final distanceBerlinNY = berlinLocation.distanceTo(newYorkLocation);
        expect(distanceBerlinNY, closeTo(6385, 100)); // Allow 100km tolerance

        // Distance to same location should be 0
        final distanceToSelf = berlinLocation.distanceTo(berlinLocation);
        expect(distanceToSelf, closeTo(0, 0.1));
      });

      test('isValid should validate coordinates correctly', () {
        // Valid coordinates
        expect(berlinLocation.isValid, true);
        expect(parisLocation.isValid, true);
        expect(newYorkLocation.isValid, true);

        // Edge valid coordinates
        const validEdge1 = GeoLocation(latitude: 90.0, longitude: 180.0);
        const validEdge2 = GeoLocation(latitude: -90.0, longitude: -180.0);
        expect(validEdge1.isValid, true);
        expect(validEdge2.isValid, true);

        // Invalid coordinates
        const invalidLat1 = GeoLocation(latitude: 91.0, longitude: 0.0);
        const invalidLat2 = GeoLocation(latitude: -91.0, longitude: 0.0);
        const invalidLng1 = GeoLocation(latitude: 0.0, longitude: 181.0);
        const invalidLng2 = GeoLocation(latitude: 0.0, longitude: -181.0);

        expect(invalidLat1.isValid, false);
        expect(invalidLat2.isValid, false);
        expect(invalidLng1.isValid, false);
        expect(invalidLng2.isValid, false);
      });

      test('displayCoordinates should format coordinates correctly', () {
        expect(berlinLocation.displayCoordinates, '52.520000, 13.405000');
        expect(parisLocation.displayCoordinates, '48.856600, 2.352200');
        expect(newYorkLocation.displayCoordinates, '40.712800, -74.006000');

        // Test southern and western coordinates
        const southWestLocation = GeoLocation(
          latitude: -33.8688,
          longitude: -151.2093,
        );
        expect(southWestLocation.displayCoordinates, '-33.868800, -151.209300');

        // Test zero coordinates
        const zeroLocation = GeoLocation(latitude: 0.0, longitude: 0.0);
        expect(zeroLocation.displayCoordinates, '0.000000, 0.000000');
      });

      test('should detect nearby locations using distance calculation', () {
        // Create nearby location (approximately 100m from Berlin)
        const nearbyBerlin = GeoLocation(latitude: 52.5210, longitude: 13.4060);

        // Test if location is nearby using distance calculation
        final distanceToNearby = berlinLocation.distanceTo(nearbyBerlin);
        expect(distanceToNearby, lessThan(1.0)); // Less than 1 km

        final distanceToParis = berlinLocation.distanceTo(parisLocation);
        expect(distanceToParis, greaterThan(100)); // More than 100 km

        final distanceToNewYork = berlinLocation.distanceTo(newYorkLocation);
        expect(distanceToNewYork, greaterThan(1000)); // More than 1000 km
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle very small coordinate differences', () {
        const location1 = GeoLocation(
          latitude: 52.520001,
          longitude: 13.405001,
        );
        const location2 = GeoLocation(
          latitude: 52.520002,
          longitude: 13.405002,
        );

        final distance = location1.distanceTo(location2);
        expect(distance, lessThan(0.01)); // Very small distance
      });

      test('should handle antipodal points correctly', () {
        const location1 = GeoLocation(latitude: 45.0, longitude: 0.0);
        const location2 = GeoLocation(latitude: -45.0, longitude: 180.0);

        final distance = location1.distanceTo(location2);
        expect(distance, greaterThan(15000)); // Should be more than 15,000 km
      });

      test('should be immutable (freezed)', () {
        const geoLocation = GeoLocation(latitude: 52.5200, longitude: 13.4050);

        // Verify that the entity is properly frozen
        expect(geoLocation, isA<GeoLocation>());
        expect(geoLocation.toString(), contains('GeoLocation'));

        // Test equality
        const identicalLocation = GeoLocation(
          latitude: 52.5200,
          longitude: 13.4050,
        );
        expect(geoLocation, equals(identicalLocation));
        expect(geoLocation.hashCode, equals(identicalLocation.hashCode));

        // Test inequality
        const differentLocation = GeoLocation(
          latitude: 52.5201,
          longitude: 13.4050,
        );
        expect(geoLocation, isNot(equals(differentLocation)));
      });

      test('should handle precision in display coordinates', () {
        // Test very precise coordinates
        const preciseLocation = GeoLocation(
          latitude: 52.123456789,
          longitude: 13.987654321,
        );
        expect(preciseLocation.displayCoordinates, '52.123457, 13.987654');

        // Test extreme precision
        const extremePrecisionLocation = GeoLocation(
          latitude: 0.000001,
          longitude: 0.000001,
        );
        expect(
          extremePrecisionLocation.displayCoordinates,
          '0.000001, 0.000001',
        );
      });

      test('should validate coordinates at boundaries', () {
        // Test exactly at boundaries
        const northPole = GeoLocation(latitude: 90.0, longitude: 0.0);
        const southPole = GeoLocation(latitude: -90.0, longitude: 0.0);
        const dateLine1 = GeoLocation(latitude: 0.0, longitude: 180.0);
        const dateLine2 = GeoLocation(latitude: 0.0, longitude: -180.0);

        expect(northPole.isValid, true);
        expect(southPole.isValid, true);
        expect(dateLine1.isValid, true);
        expect(dateLine2.isValid, true);

        // Test just outside boundaries
        const beyondNorth = GeoLocation(latitude: 90.1, longitude: 0.0);
        const beyondSouth = GeoLocation(latitude: -90.1, longitude: 0.0);
        const beyondEast = GeoLocation(latitude: 0.0, longitude: 180.1);
        const beyondWest = GeoLocation(latitude: 0.0, longitude: -180.1);

        expect(beyondNorth.isValid, false);
        expect(beyondSouth.isValid, false);
        expect(beyondEast.isValid, false);
        expect(beyondWest.isValid, false);
      });
    });
  });
}
