// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geo_location_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GeoLocationModel _$GeoLocationModelFromJson(Map<String, dynamic> json) {
  return _GeoLocationModel.fromJson(json);
}

/// @nodoc
mixin _$GeoLocationModel {
  @JsonKey(name: 'lat')
  double get latitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'long')
  double get longitude => throw _privateConstructorUsedError;

  /// Serializes this GeoLocationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeoLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeoLocationModelCopyWith<GeoLocationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeoLocationModelCopyWith<$Res> {
  factory $GeoLocationModelCopyWith(
    GeoLocationModel value,
    $Res Function(GeoLocationModel) then,
  ) = _$GeoLocationModelCopyWithImpl<$Res, GeoLocationModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'lat') double latitude,
    @JsonKey(name: 'long') double longitude,
  });
}

/// @nodoc
class _$GeoLocationModelCopyWithImpl<$Res, $Val extends GeoLocationModel>
    implements $GeoLocationModelCopyWith<$Res> {
  _$GeoLocationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeoLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? latitude = null, Object? longitude = null}) {
    return _then(
      _value.copyWith(
            latitude:
                null == latitude
                    ? _value.latitude
                    : latitude // ignore: cast_nullable_to_non_nullable
                        as double,
            longitude:
                null == longitude
                    ? _value.longitude
                    : longitude // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GeoLocationModelImplCopyWith<$Res>
    implements $GeoLocationModelCopyWith<$Res> {
  factory _$$GeoLocationModelImplCopyWith(
    _$GeoLocationModelImpl value,
    $Res Function(_$GeoLocationModelImpl) then,
  ) = __$$GeoLocationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'lat') double latitude,
    @JsonKey(name: 'long') double longitude,
  });
}

/// @nodoc
class __$$GeoLocationModelImplCopyWithImpl<$Res>
    extends _$GeoLocationModelCopyWithImpl<$Res, _$GeoLocationModelImpl>
    implements _$$GeoLocationModelImplCopyWith<$Res> {
  __$$GeoLocationModelImplCopyWithImpl(
    _$GeoLocationModelImpl _value,
    $Res Function(_$GeoLocationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GeoLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? latitude = null, Object? longitude = null}) {
    return _then(
      _$GeoLocationModelImpl(
        latitude:
            null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                    as double,
        longitude:
            null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$GeoLocationModelImpl extends _GeoLocationModel {
  const _$GeoLocationModelImpl({
    @JsonKey(name: 'lat') required this.latitude,
    @JsonKey(name: 'long') required this.longitude,
  }) : super._();

  factory _$GeoLocationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeoLocationModelImplFromJson(json);

  @override
  @JsonKey(name: 'lat')
  final double latitude;
  @override
  @JsonKey(name: 'long')
  final double longitude;

  @override
  String toString() {
    return 'GeoLocationModel(latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeoLocationModelImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude);

  /// Create a copy of GeoLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeoLocationModelImplCopyWith<_$GeoLocationModelImpl> get copyWith =>
      __$$GeoLocationModelImplCopyWithImpl<_$GeoLocationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GeoLocationModelImplToJson(this);
  }
}

abstract class _GeoLocationModel extends GeoLocationModel {
  const factory _GeoLocationModel({
    @JsonKey(name: 'lat') required final double latitude,
    @JsonKey(name: 'long') required final double longitude,
  }) = _$GeoLocationModelImpl;
  const _GeoLocationModel._() : super._();

  factory _GeoLocationModel.fromJson(Map<String, dynamic> json) =
      _$GeoLocationModelImpl.fromJson;

  @override
  @JsonKey(name: 'lat')
  double get latitude;
  @override
  @JsonKey(name: 'long')
  double get longitude;

  /// Create a copy of GeoLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeoLocationModelImplCopyWith<_$GeoLocationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
