// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GeoLocationModelImpl _$$GeoLocationModelImplFromJson(
  Map<String, dynamic> json,
) => _$GeoLocationModelImpl(
  latitude: (json['lat'] as num).toDouble(),
  longitude: (json['long'] as num).toDouble(),
);

Map<String, dynamic> _$$GeoLocationModelImplToJson(
  _$GeoLocationModelImpl instance,
) => <String, dynamic>{'lat': instance.latitude, 'long': instance.longitude};
