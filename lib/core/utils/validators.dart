import '../config/app_config.dart';

/// Validation utilities for data validation
class Validators {
  /// Validates latitude coordinate
  static bool isValidLatitude(double? latitude) {
    if (latitude == null) return false;
    return latitude >= AppConfig.minLatitude &&
        latitude <= AppConfig.maxLatitude;
  }

  /// Validates longitude coordinate
  static bool isValidLongitude(double? longitude) {
    if (longitude == null) return false;
    return longitude >= AppConfig.minLongitude &&
        longitude <= AppConfig.maxLongitude;
  }

  /// Validates both latitude and longitude coordinates
  static bool isValidCoordinates(double? latitude, double? longitude) {
    return isValidLatitude(latitude) && isValidLongitude(longitude);
  }

  /// Validates email format
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Validates URL format
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Validates price value
  static bool isValidPrice(double? price) {
    if (price == null) return false;
    return price >= 0 && price <= 10000; // Reasonable price range
  }

  /// Validates campsite name
  static bool isValidCampsiteName(String? name) {
    if (name == null || name.isEmpty) return false;
    return name.trim().length >= 2 && name.trim().length <= 100;
  }

  /// Validates country name
  static bool isValidCountryName(String? country) {
    if (country == null || country.isEmpty) return false;
    return country.trim().length >= 2 && country.trim().length <= 50;
  }

  /// Validates language code
  static bool isValidLanguageCode(String? language) {
    if (language == null || language.isEmpty) return false;
    // Basic validation for common language codes (2-5 characters)
    return language.trim().length >= 2 && language.trim().length <= 5;
  }

  /// Validates search query
  static bool isValidSearchQuery(String? query) {
    if (query == null || query.isEmpty) return true; // Empty search is valid
    return query.trim().length >= 1 && query.trim().length <= 100;
  }

  /// Validates if a string is not empty or null
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Validates if a value is within a range
  static bool isInRange(num? value, num min, num max) {
    if (value == null) return false;
    return value >= min && value <= max;
  }
}

/// Sanitization utilities for cleaning and formatting data
class Sanitizers {
  /// Sanitizes a string by trimming and removing extra whitespace
  static String sanitizeString(String? input) {
    if (input == null) return '';
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Sanitizes and formats a price
  static double sanitizePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      try {
        return double.parse(price);
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }

  /// Sanitizes coordinates to ensure they're within valid ranges
  static double? sanitizeCoordinate(dynamic coordinate, bool isLatitude) {
    if (coordinate == null) return null;

    double? value;
    if (coordinate is double) {
      value = coordinate;
    } else if (coordinate is int) {
      value = coordinate.toDouble();
    } else if (coordinate is String) {
      try {
        value = double.parse(coordinate);
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }

    if (isLatitude) {
      return Validators.isValidLatitude(value) ? value : null;
    } else {
      return Validators.isValidLongitude(value) ? value : null;
    }
  }

  /// Sanitizes URL by ensuring it has a proper scheme
  static String? sanitizeUrl(String? url) {
    if (url == null || url.isEmpty) return null;

    final trimmed = url.trim();
    if (trimmed.isEmpty) return null;

    // Add https if no scheme is present
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      return 'https://$trimmed';
    }

    return trimmed;
  }

  /// Sanitizes boolean values from various input types
  static bool sanitizeBoolean(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase().trim();
      return lower == 'true' || lower == '1' || lower == 'yes';
    }
    if (value is int) return value != 0;
    return false;
  }
}
