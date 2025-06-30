// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campsite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CampsiteModelImpl _$$CampsiteModelImplFromJson(
  Map<String, dynamic> json,
) => _$CampsiteModelImpl(
  id: json['id'] as String,
  label: json['label'] as String,
  geoLocation: GeoLocationModel.fromJson(
    json['geoLocation'] as Map<String, dynamic>,
  ),
  createdAt: json['createdAt'] as String,
  isCloseToWater: json['isCloseToWater'] as bool,
  isCampFireAllowed: json['isCampFireAllowed'] as bool,
  hostLanguages:
      (json['hostLanguages'] as List<dynamic>).map((e) => e as String).toList(),
  pricePerNight: (json['pricePerNight'] as num).toDouble(),
  photo: json['photo'] as String,
  suitableFor:
      (json['suitableFor'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$$CampsiteModelImplToJson(_$CampsiteModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'geoLocation': instance.geoLocation.toJson(),
      'createdAt': instance.createdAt,
      'isCloseToWater': instance.isCloseToWater,
      'isCampFireAllowed': instance.isCampFireAllowed,
      'hostLanguages': instance.hostLanguages,
      'pricePerNight': instance.pricePerNight,
      'photo': instance.photo,
      'suitableFor': instance.suitableFor,
    };
