import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/geo_location.dart';

part 'geo_location_model.freezed.dart';
part 'geo_location_model.g.dart';

/// Data model for GeoLocation with JSON serialization
@freezed
class GeoLocationModel with _$GeoLocationModel {
  const factory GeoLocationModel({
    @JsonKey(name: 'lat') required double latitude,
    @JsonKey(name: 'long') required double longitude,
  }) = _GeoLocationModel;

  const GeoLocationModel._();

  factory GeoLocationModel.fromJson(Map<String, dynamic> json) =>
      _$GeoLocationModelFromJson(json);

  /// Convert to domain entity
  GeoLocation toDomain() {
    return GeoLocation(latitude: latitude, longitude: longitude);
  }

  /// Create from domain entity
  factory GeoLocationModel.fromDomain(GeoLocation geoLocation) {
    return GeoLocationModel(
      latitude: geoLocation.latitude,
      longitude: geoLocation.longitude,
    );
  }
}
