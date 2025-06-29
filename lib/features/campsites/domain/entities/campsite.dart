import 'package:freezed_annotation/freezed_annotation.dart';
import 'geo_location.dart';

part 'campsite.freezed.dart';

@freezed
class Campsite with _$Campsite {
  const factory Campsite({
    required String id,
    required String label,
    required GeoLocation geoLocation,
    required DateTime createdAt,
    required bool isCloseToWater,
    required bool isCampFireAllowed,
    required List<String> hostLanguages,
    required double pricePerNight,
    required String photo,
    required List<String> suitableFor,
  }) = _Campsite;

  const Campsite._();

  String get formattedPrice {
    return '€${pricePerNight.toStringAsFixed(0)} / night';
  }

  List<String> get amenities {
    final List<String> amenities = [];
    if (isCloseToWater) amenities.add('Close to Water');
    if (isCampFireAllowed) amenities.add('Campfire Allowed');
    return amenities;
  }

  bool matchesSearchTerm(String searchTerm) {
    final String lowerSearch = searchTerm.toLowerCase();
    return label.toLowerCase().contains(lowerSearch) ||
        hostLanguages.any((lang) => lang.toLowerCase().contains(lowerSearch));
  }

  String get briefDescription {
    final List<String> features = [];
    if (isCloseToWater) features.add('waterfront');
    if (isCampFireAllowed) features.add('campfire');

    if (features.isEmpty) {
      return 'Campsite with ${hostLanguages.join(', ')} speaking hosts';
    } else {
      return 'Campsite with ${features.join(' and ')} features';
    }
  }

  String get primaryHostLanguage {
    return hostLanguages.isNotEmpty ? hostLanguages.first : 'en';
  }
}
