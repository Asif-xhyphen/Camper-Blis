import 'dart:math' as math;
import '../config/app_config.dart';
import 'validators.dart';
import '../../features/campsites/domain/entities/geo_location.dart';

/// Coordinate utility functions for geographic operations
class CoordinateUtils {
  /// List of 50 hardcoded European camping coordinates
  /// These will replace the incorrect coordinates from the API
  static const List<Map<String, double>> _hardcodedCampingCoordinates = [
    // Germany
    {'latitude': 47.5596, 'longitude': 7.5886}, // Black Forest, Germany
    {'latitude': 51.4347, 'longitude': 12.2433}, // Near Leipzig, Germany
    {'latitude': 49.4521, 'longitude': 11.0767}, // Nuremberg area, Germany
    {'latitude': 53.5511, 'longitude': 9.9937}, // Hamburg area, Germany
    {'latitude': 50.1109, 'longitude': 8.6821}, // Frankfurt area, Germany
    // France
    {'latitude': 43.6047, 'longitude': 1.4442}, // Near Toulouse, France
    {'latitude': 45.7640, 'longitude': 4.8357}, // Lyon area, France
    {'latitude': 47.2184, 'longitude': -1.5536}, // Nantes area, France
    {'latitude': 49.4944, 'longitude': 0.1079}, // Le Havre area, France
    {'latitude': 44.8378, 'longitude': -0.5792}, // Bordeaux area, France
    // Switzerland
    {'latitude': 46.9481, 'longitude': 7.4474}, // Bern area, Switzerland
    {'latitude': 46.5197, 'longitude': 6.6323}, // Lausanne area, Switzerland
    {'latitude': 47.3769, 'longitude': 8.5417}, // Zurich area, Switzerland
    {'latitude': 46.0037, 'longitude': 8.9511}, // Lugano area, Switzerland
    {'latitude': 46.8182, 'longitude': 8.2275}, // Central Switzerland
    // Austria
    {'latitude': 47.2692, 'longitude': 11.4041}, // Innsbruck area, Austria
    {'latitude': 47.8095, 'longitude': 13.0550}, // Salzburg area, Austria
    {'latitude': 48.2082, 'longitude': 16.3738}, // Vienna area, Austria
    {'latitude': 47.0707, 'longitude': 15.4395}, // Graz area, Austria
    {'latitude': 47.6634, 'longitude': 13.5152}, // Lake region, Austria
    // Italy (Northern)
    {'latitude': 45.4642, 'longitude': 9.1900}, // Milan area, Italy
    {'latitude': 45.0703, 'longitude': 7.6869}, // Turin area, Italy
    {'latitude': 45.4408, 'longitude': 12.3155}, // Venice area, Italy
    {'latitude': 44.4949, 'longitude': 11.3426}, // Bologna area, Italy
    {'latitude': 45.8131, 'longitude': 8.7750}, // Lake Como area, Italy
    // Spain
    {'latitude': 43.2630, 'longitude': -2.9350}, // Bilbao area, Spain
    {'latitude': 41.3851, 'longitude': 2.1734}, // Barcelona area, Spain
    {'latitude': 39.4699, 'longitude': -0.3763}, // Valencia area, Spain
    {'latitude': 37.3886, 'longitude': -5.9823}, // Seville area, Spain
    {'latitude': 40.4168, 'longitude': -3.7038}, // Madrid area, Spain
    // Netherlands
    {'latitude': 52.3676, 'longitude': 4.9041}, // Amsterdam area, Netherlands
    {'latitude': 51.9225, 'longitude': 4.4792}, // Rotterdam area, Netherlands
    {'latitude': 52.2130, 'longitude': 5.2794}, // Utrecht area, Netherlands
    {'latitude': 53.2194, 'longitude': 6.5665}, // Groningen area, Netherlands
    {'latitude': 51.5719, 'longitude': 5.0913}, // Eindhoven area, Netherlands
    // Belgium
    {'latitude': 50.8503, 'longitude': 4.3517}, // Brussels area, Belgium
    {'latitude': 51.2093, 'longitude': 3.2247}, // Bruges area, Belgium
    {'latitude': 51.2194, 'longitude': 4.4025}, // Antwerp area, Belgium
    {'latitude': 50.4501, 'longitude': 3.9517}, // Namur area, Belgium
    {'latitude': 50.6292, 'longitude': 5.5797}, // Liege area, Belgium
    // Czech Republic
    {'latitude': 50.0755, 'longitude': 14.4378}, // Prague area, Czech Republic
    {'latitude': 49.1951, 'longitude': 16.6068}, // Brno area, Czech Republic
    {'latitude': 49.7384, 'longitude': 13.3736}, // Plzen area, Czech Republic
    {'latitude': 50.7663, 'longitude': 15.0543}, // Liberec area, Czech Republic
    {'latitude': 49.5955, 'longitude': 17.2517}, // Olomouc area, Czech Republic
    // Poland
    {'latitude': 52.2297, 'longitude': 21.0122}, // Warsaw area, Poland
    {'latitude': 50.0647, 'longitude': 19.9450}, // Krakow area, Poland
    {'latitude': 54.3520, 'longitude': 18.6466}, // Gdansk area, Poland
    {'latitude': 51.7592, 'longitude': 19.4560}, // Lodz area, Poland
    {'latitude': 51.1079, 'longitude': 17.0385}, // Wroclaw area, Poland
    // Slovenia
    {'latitude': 46.0569, 'longitude': 14.5058}, // Ljubljana area, Slovenia
    {'latitude': 46.3595, 'longitude': 15.1113}, // Celje area, Slovenia
    {'latitude': 45.5550, 'longitude': 13.7301}, // Koper area, Slovenia
    {'latitude': 46.2396, 'longitude': 14.3559}, // Kranj area, Slovenia
    {'latitude': 45.9432, 'longitude': 15.2675}, // Novo Mesto area, Slovenia
  ];

  /// Get hardcoded coordinates for a campsite based on its ID
  /// This ensures consistent coordinate assignment for each campsite
  static Map<String, double> getHardcodedCoordinatesForCampsite(
    String campsiteId,
  ) {
    // Create a hash of the campsite ID to get a consistent index
    int hash = campsiteId.hashCode;

    // Ensure positive index and map to coordinate list length
    int index = hash.abs() % _hardcodedCampingCoordinates.length;

    return _hardcodedCampingCoordinates[index];
  }

  /// Get all available hardcoded coordinates (for testing purposes)
  static List<Map<String, double>> getAllHardcodedCoordinates() {
    return List.unmodifiable(_hardcodedCampingCoordinates);
  }

  /// Calculate distance between two points using Haversine formula
  /// Returns distance in kilometers
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  /// Convert degrees to radians
  static double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  /// Calculate the center point of a list of coordinates
  static Map<String, double>? calculateCenter(
    List<Map<String, double>> coordinates,
  ) {
    if (coordinates.isEmpty) return null;

    double totalLat = 0;
    double totalLon = 0;
    int validCount = 0;

    for (final coord in coordinates) {
      final lat = coord['latitude'];
      final lon = coord['longitude'];

      if (lat != null &&
          lon != null &&
          Validators.isValidCoordinates(lat, lon)) {
        totalLat += lat;
        totalLon += lon;
        validCount++;
      }
    }

    if (validCount == 0) return null;

    return {
      'latitude': totalLat / validCount,
      'longitude': totalLon / validCount,
    };
  }

  /// Get fallback coordinates for a country (simplified mapping)
  static Map<String, double> getFallbackCoordinates(String country) {
    final countryLower = country.toLowerCase();

    // Simplified country-to-coordinate mapping
    final Map<String, Map<String, double>> countryCoordinates = {
      'germany': {'latitude': 51.1657, 'longitude': 10.4515},
      'france': {'latitude': 46.6034, 'longitude': 1.8883},
      'spain': {'latitude': 40.4637, 'longitude': -3.7492},
      'italy': {'latitude': 41.8719, 'longitude': 12.5674},
      'united kingdom': {'latitude': 55.3781, 'longitude': -3.4360},
      'uk': {'latitude': 55.3781, 'longitude': -3.4360},
      'netherlands': {'latitude': 52.1326, 'longitude': 5.2913},
      'austria': {'latitude': 47.5162, 'longitude': 14.5501},
      'switzerland': {'latitude': 46.8182, 'longitude': 8.2275},
      'portugal': {'latitude': 39.3999, 'longitude': -8.2245},
      'belgium': {'latitude': 50.5039, 'longitude': 4.4699},
      'denmark': {'latitude': 56.2639, 'longitude': 9.5018},
      'sweden': {'latitude': 60.1282, 'longitude': 18.6435},
      'norway': {'latitude': 60.4720, 'longitude': 8.4689},
      'finland': {'latitude': 61.9241, 'longitude': 25.7482},
      'poland': {'latitude': 51.9194, 'longitude': 19.1451},
      'czech republic': {'latitude': 49.8175, 'longitude': 15.4730},
      'hungary': {'latitude': 47.1625, 'longitude': 19.5033},
      'croatia': {'latitude': 45.1000, 'longitude': 15.2000},
      'slovenia': {'latitude': 46.1512, 'longitude': 14.9955},
    };

    return countryCoordinates[countryLower] ??
        {
          'latitude': AppConfig.defaultLatitude,
          'longitude': AppConfig.defaultLongitude,
        };
  }

  /// Validate and sanitize coordinates, provide fallback if invalid
  static Map<String, double> sanitizeCoordinates({
    required double? latitude,
    required double? longitude,
    required String country,
  }) {
    // If coordinates are valid, return them
    if (Validators.isValidCoordinates(latitude, longitude)) {
      return {'latitude': latitude!, 'longitude': longitude!};
    }

    // If invalid, return fallback coordinates for the country
    return getFallbackCoordinates(country);
  }

  /// Check if coordinates are within a bounding box
  static bool isWithinBounds({
    required double latitude,
    required double longitude,
    required double northBound,
    required double southBound,
    required double eastBound,
    required double westBound,
  }) {
    return latitude <= northBound &&
        latitude >= southBound &&
        longitude <= eastBound &&
        longitude >= westBound;
  }

  /// Calculate bounding box for a given center point and radius (in km)
  static Map<String, double> calculateBoundingBox({
    required double centerLat,
    required double centerLon,
    required double radiusKm,
  }) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double latRadians = _toRadians(centerLat);
    final double deltaLat = radiusKm / earthRadius;
    final double deltaLon = radiusKm / (earthRadius * math.cos(latRadians));

    return {
      'northBound': centerLat + deltaLat * (180 / math.pi),
      'southBound': centerLat - deltaLat * (180 / math.pi),
      'eastBound': centerLon + deltaLon * (180 / math.pi),
      'westBound': centerLon - deltaLon * (180 / math.pi),
    };
  }

  /// Format coordinates for display
  static String formatCoordinates(double latitude, double longitude) {
    final String latDirection = latitude >= 0 ? 'N' : 'S';
    final String lonDirection = longitude >= 0 ? 'E' : 'W';

    return '${latitude.abs().toStringAsFixed(4)}°$latDirection, '
        '${longitude.abs().toStringAsFixed(4)}°$lonDirection';
  }

  /// Generate random coordinates within a country (for development/testing)
  static Map<String, double> generateRandomCoordinatesInCountry(
    String country,
  ) {
    final fallback = getFallbackCoordinates(country);
    final random = math.Random();

    // Generate coordinates within ±0.5 degrees of the country center
    final double latOffset = (random.nextDouble() - 0.5) * 1.0; // ±0.5 degrees
    final double lonOffset = (random.nextDouble() - 0.5) * 1.0; // ±0.5 degrees

    double newLat = fallback['latitude']! + latOffset;
    double newLon = fallback['longitude']! + lonOffset;

    // Ensure coordinates are still valid
    newLat = newLat.clamp(AppConfig.minLatitude, AppConfig.maxLatitude);
    newLon = newLon.clamp(AppConfig.minLongitude, AppConfig.maxLongitude);

    return {'latitude': newLat, 'longitude': newLon};
  }

  /// Validate coordinates and return corrected version if invalid
  static GeoLocation validateAndCorrect(
    double? latitude,
    double? longitude,
    String country,
  ) {
    // Check if coordinates are null or invalid
    if (latitude == null ||
        longitude == null ||
        !_isValidLatitude(latitude) ||
        !_isValidLongitude(longitude)) {
      // Return fallback coordinates based on country
      return _getCountryFallbackCoordinates(country);
    }

    return GeoLocation(latitude: latitude, longitude: longitude);
  }

  /// Check if latitude is within valid range
  static bool _isValidLatitude(double latitude) {
    return latitude >= AppConfig.minLatitude &&
        latitude <= AppConfig.maxLatitude;
  }

  /// Check if longitude is within valid range
  static bool _isValidLongitude(double longitude) {
    return longitude >= AppConfig.minLongitude &&
        longitude <= AppConfig.maxLongitude;
  }

  /// Get fallback coordinates for a given country
  static GeoLocation _getCountryFallbackCoordinates(String country) {
    final Map<String, GeoLocation> countryCoordinates = {
      'Germany': const GeoLocation(latitude: 51.1657, longitude: 10.4515),
      'France': const GeoLocation(latitude: 46.2276, longitude: 2.2137),
      'Spain': const GeoLocation(latitude: 40.4637, longitude: -3.7492),
      'Italy': const GeoLocation(latitude: 41.8719, longitude: 12.5674),
      'Netherlands': const GeoLocation(latitude: 52.1326, longitude: 5.2913),
      'Austria': const GeoLocation(latitude: 47.5162, longitude: 14.5501),
      'Switzerland': const GeoLocation(latitude: 46.8182, longitude: 8.2275),
      'Belgium': const GeoLocation(latitude: 50.5039, longitude: 4.4699),
      'Denmark': const GeoLocation(latitude: 56.2639, longitude: 9.5018),
      'Sweden': const GeoLocation(latitude: 60.1282, longitude: 18.6435),
      'Norway': const GeoLocation(latitude: 60.4720, longitude: 8.4689),
      'Finland': const GeoLocation(latitude: 61.9241, longitude: 25.7482),
      'Poland': const GeoLocation(latitude: 51.9194, longitude: 19.1451),
      'Czech Republic': const GeoLocation(
        latitude: 49.8175,
        longitude: 15.4730,
      ),
      'Portugal': const GeoLocation(latitude: 39.3999, longitude: -8.2245),
      'United Kingdom': const GeoLocation(
        latitude: 55.3781,
        longitude: -3.4360,
      ),
      'Ireland': const GeoLocation(latitude: 53.4129, longitude: -8.2439),
    };

    // Return country-specific coordinates or default to Berlin, Germany
    return countryCoordinates[country] ??
        const GeoLocation(
          latitude: AppConfig.defaultLatitude,
          longitude: AppConfig.defaultLongitude,
        );
  }

  /// Calculate distance between two GeoLocation objects using Haversine formula
  static double calculateDistanceGeoLocation(
    GeoLocation point1,
    GeoLocation point2,
  ) {
    return point1.distanceTo(point2);
  }

  /// Check if coordinates are within a specific radius of a center point
  static bool isWithinRadius(
    GeoLocation center,
    GeoLocation point,
    double radiusKm,
  ) {
    return calculateDistanceGeoLocation(center, point) <= radiusKm;
  }
}
