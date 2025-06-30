import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const String appName = 'Camper Blis';
  static const String appVersion = '1.0.0';

  // API Configuration
  static String baseUrl = dotenv.env['BASE_URL'] ?? '';

  // Database Configuration
  static const String databaseName = 'camper_blis.db';
  static const int databaseVersion = 1;

  // Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100;

  // Map Configuration
  static const double defaultLatitude = 52.5200; // Berlin, Germany
  static const double defaultLongitude = 13.4050;
  static const double defaultZoom = 10.0;

  // Validation Configuration
  static const double minLatitude = -90.0;
  static const double maxLatitude = 90.0;
  static const double minLongitude = -180.0;
  static const double maxLongitude = 180.0;
}
