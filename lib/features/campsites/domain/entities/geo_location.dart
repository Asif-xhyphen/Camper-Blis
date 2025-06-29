import 'dart:math' as math;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'geo_location.freezed.dart';

/// Domain entity representing geographical coordinates
@freezed
class GeoLocation with _$GeoLocation {
  const factory GeoLocation({
    required double latitude,
    required double longitude,
  }) = _GeoLocation;

  const GeoLocation._();

  /// Check if coordinates are valid
  bool get isValid {
    return latitude >= -90.0 &&
        latitude <= 90.0 &&
        longitude >= -180.0 &&
        longitude <= 180.0;
  }

  /// Get human-readable coordinates string
  String get displayCoordinates {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  /// Calculate distance to another location in kilometers
  double distanceTo(GeoLocation other) {
    // Haversine formula for calculating distance between two points on Earth
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double dLat = _degreesToRadians(other.latitude - latitude);
    final double dLon = _degreesToRadians(other.longitude - longitude);

    final double a =
        (math.sin(dLat / 2) * math.sin(dLat / 2)) +
        (math.cos(_degreesToRadians(latitude)) *
            math.cos(_degreesToRadians(other.latitude)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2));

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}
