import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/campsite.dart';
import '../../domain/entities/geo_location.dart';
import 'geo_location_model.dart';

part 'campsite_model.freezed.dart';
part 'campsite_model.g.dart';

/// Data model for Campsite with JSON serialization
@freezed
class CampsiteModel with _$CampsiteModel {
  const factory CampsiteModel({
    required String id,
    required String label,
    required GeoLocationModel geoLocation,
    required String createdAt,
    @JsonKey(name: 'isCloseToWater') required bool isCloseToWater,
    @JsonKey(name: 'isCampFireAllowed') required bool isCampFireAllowed,
    required List<String> hostLanguages,
    required double pricePerNight,
    required String photo,
    required List<String> suitableFor,
  }) = _CampsiteModel;

  const CampsiteModel._();

  factory CampsiteModel.fromJson(Map<String, dynamic> json) =>
      _$CampsiteModelFromJson(json);

  /// Convert to domain entity
  Campsite toDomain() {
    return Campsite(
      id: id,
      label: label,
      geoLocation: geoLocation.toDomain(),
      createdAt: DateTime.parse(createdAt),
      isCloseToWater: isCloseToWater,
      isCampFireAllowed: isCampFireAllowed,
      hostLanguages: hostLanguages,
      pricePerNight: pricePerNight,
      photo: photo,
      suitableFor: suitableFor,
    );
  }

  /// Create from domain entity
  factory CampsiteModel.fromDomain(Campsite campsite) {
    return CampsiteModel(
      id: campsite.id,
      label: campsite.label,
      geoLocation: GeoLocationModel.fromDomain(campsite.geoLocation),
      createdAt: campsite.createdAt.toIso8601String(),
      isCloseToWater: campsite.isCloseToWater,
      isCampFireAllowed: campsite.isCampFireAllowed,
      hostLanguages: campsite.hostLanguages,
      pricePerNight: campsite.pricePerNight,
      photo: campsite.photo,
      suitableFor: campsite.suitableFor,
    );
  }
}
