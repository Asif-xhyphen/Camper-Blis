import 'dart:math' as math;
import '../config/app_config.dart';
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
}
