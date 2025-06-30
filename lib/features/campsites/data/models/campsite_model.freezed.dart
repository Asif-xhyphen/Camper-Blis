// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'campsite_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CampsiteModel _$CampsiteModelFromJson(Map<String, dynamic> json) {
  return _CampsiteModel.fromJson(json);
}

/// @nodoc
mixin _$CampsiteModel {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  GeoLocationModel get geoLocation => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'isCloseToWater')
  bool get isCloseToWater => throw _privateConstructorUsedError;
  @JsonKey(name: 'isCampFireAllowed')
  bool get isCampFireAllowed => throw _privateConstructorUsedError;
  List<String> get hostLanguages => throw _privateConstructorUsedError;
  double get pricePerNight => throw _privateConstructorUsedError;
  String get photo => throw _privateConstructorUsedError;
  List<String> get suitableFor => throw _privateConstructorUsedError;

  /// Serializes this CampsiteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CampsiteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CampsiteModelCopyWith<CampsiteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CampsiteModelCopyWith<$Res> {
  factory $CampsiteModelCopyWith(
    CampsiteModel value,
    $Res Function(CampsiteModel) then,
  ) = _$CampsiteModelCopyWithImpl<$Res, CampsiteModel>;
  @useResult
  $Res call({
    String id,
    String label,
    GeoLocationModel geoLocation,
    String createdAt,
    @JsonKey(name: 'isCloseToWater') bool isCloseToWater,
    @JsonKey(name: 'isCampFireAllowed') bool isCampFireAllowed,
    List<String> hostLanguages,
    double pricePerNight,
    String photo,
    List<String> suitableFor,
  });

  $GeoLocationModelCopyWith<$Res> get geoLocation;
}

/// @nodoc
class _$CampsiteModelCopyWithImpl<$Res, $Val extends CampsiteModel>
    implements $CampsiteModelCopyWith<$Res> {
  _$CampsiteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CampsiteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? geoLocation = null,
    Object? createdAt = null,
    Object? isCloseToWater = null,
    Object? isCampFireAllowed = null,
    Object? hostLanguages = null,
    Object? pricePerNight = null,
    Object? photo = null,
    Object? suitableFor = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            label:
                null == label
                    ? _value.label
                    : label // ignore: cast_nullable_to_non_nullable
                        as String,
            geoLocation:
                null == geoLocation
                    ? _value.geoLocation
                    : geoLocation // ignore: cast_nullable_to_non_nullable
                        as GeoLocationModel,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as String,
            isCloseToWater:
                null == isCloseToWater
                    ? _value.isCloseToWater
                    : isCloseToWater // ignore: cast_nullable_to_non_nullable
                        as bool,
            isCampFireAllowed:
                null == isCampFireAllowed
                    ? _value.isCampFireAllowed
                    : isCampFireAllowed // ignore: cast_nullable_to_non_nullable
                        as bool,
            hostLanguages:
                null == hostLanguages
                    ? _value.hostLanguages
                    : hostLanguages // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            pricePerNight:
                null == pricePerNight
                    ? _value.pricePerNight
                    : pricePerNight // ignore: cast_nullable_to_non_nullable
                        as double,
            photo:
                null == photo
                    ? _value.photo
                    : photo // ignore: cast_nullable_to_non_nullable
                        as String,
            suitableFor:
                null == suitableFor
                    ? _value.suitableFor
                    : suitableFor // ignore: cast_nullable_to_non_nullable
                        as List<String>,
          )
          as $Val,
    );
  }

  /// Create a copy of CampsiteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoLocationModelCopyWith<$Res> get geoLocation {
    return $GeoLocationModelCopyWith<$Res>(_value.geoLocation, (value) {
      return _then(_value.copyWith(geoLocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CampsiteModelImplCopyWith<$Res>
    implements $CampsiteModelCopyWith<$Res> {
  factory _$$CampsiteModelImplCopyWith(
    _$CampsiteModelImpl value,
    $Res Function(_$CampsiteModelImpl) then,
  ) = __$$CampsiteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String label,
    GeoLocationModel geoLocation,
    String createdAt,
    @JsonKey(name: 'isCloseToWater') bool isCloseToWater,
    @JsonKey(name: 'isCampFireAllowed') bool isCampFireAllowed,
    List<String> hostLanguages,
    double pricePerNight,
    String photo,
    List<String> suitableFor,
  });

  @override
  $GeoLocationModelCopyWith<$Res> get geoLocation;
}

/// @nodoc
class __$$CampsiteModelImplCopyWithImpl<$Res>
    extends _$CampsiteModelCopyWithImpl<$Res, _$CampsiteModelImpl>
    implements _$$CampsiteModelImplCopyWith<$Res> {
  __$$CampsiteModelImplCopyWithImpl(
    _$CampsiteModelImpl _value,
    $Res Function(_$CampsiteModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CampsiteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? geoLocation = null,
    Object? createdAt = null,
    Object? isCloseToWater = null,
    Object? isCampFireAllowed = null,
    Object? hostLanguages = null,
    Object? pricePerNight = null,
    Object? photo = null,
    Object? suitableFor = null,
  }) {
    return _then(
      _$CampsiteModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        label:
            null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                    as String,
        geoLocation:
            null == geoLocation
                ? _value.geoLocation
                : geoLocation // ignore: cast_nullable_to_non_nullable
                    as GeoLocationModel,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as String,
        isCloseToWater:
            null == isCloseToWater
                ? _value.isCloseToWater
                : isCloseToWater // ignore: cast_nullable_to_non_nullable
                    as bool,
        isCampFireAllowed:
            null == isCampFireAllowed
                ? _value.isCampFireAllowed
                : isCampFireAllowed // ignore: cast_nullable_to_non_nullable
                    as bool,
        hostLanguages:
            null == hostLanguages
                ? _value._hostLanguages
                : hostLanguages // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        pricePerNight:
            null == pricePerNight
                ? _value.pricePerNight
                : pricePerNight // ignore: cast_nullable_to_non_nullable
                    as double,
        photo:
            null == photo
                ? _value.photo
                : photo // ignore: cast_nullable_to_non_nullable
                    as String,
        suitableFor:
            null == suitableFor
                ? _value._suitableFor
                : suitableFor // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$CampsiteModelImpl extends _CampsiteModel {
  const _$CampsiteModelImpl({
    required this.id,
    required this.label,
    required this.geoLocation,
    required this.createdAt,
    @JsonKey(name: 'isCloseToWater') required this.isCloseToWater,
    @JsonKey(name: 'isCampFireAllowed') required this.isCampFireAllowed,
    required final List<String> hostLanguages,
    required this.pricePerNight,
    required this.photo,
    required final List<String> suitableFor,
  }) : _hostLanguages = hostLanguages,
       _suitableFor = suitableFor,
       super._();

  factory _$CampsiteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CampsiteModelImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  final GeoLocationModel geoLocation;
  @override
  final String createdAt;
  @override
  @JsonKey(name: 'isCloseToWater')
  final bool isCloseToWater;
  @override
  @JsonKey(name: 'isCampFireAllowed')
  final bool isCampFireAllowed;
  final List<String> _hostLanguages;
  @override
  List<String> get hostLanguages {
    if (_hostLanguages is EqualUnmodifiableListView) return _hostLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hostLanguages);
  }

  @override
  final double pricePerNight;
  @override
  final String photo;
  final List<String> _suitableFor;
  @override
  List<String> get suitableFor {
    if (_suitableFor is EqualUnmodifiableListView) return _suitableFor;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suitableFor);
  }

  @override
  String toString() {
    return 'CampsiteModel(id: $id, label: $label, geoLocation: $geoLocation, createdAt: $createdAt, isCloseToWater: $isCloseToWater, isCampFireAllowed: $isCampFireAllowed, hostLanguages: $hostLanguages, pricePerNight: $pricePerNight, photo: $photo, suitableFor: $suitableFor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CampsiteModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.geoLocation, geoLocation) ||
                other.geoLocation == geoLocation) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isCloseToWater, isCloseToWater) ||
                other.isCloseToWater == isCloseToWater) &&
            (identical(other.isCampFireAllowed, isCampFireAllowed) ||
                other.isCampFireAllowed == isCampFireAllowed) &&
            const DeepCollectionEquality().equals(
              other._hostLanguages,
              _hostLanguages,
            ) &&
            (identical(other.pricePerNight, pricePerNight) ||
                other.pricePerNight == pricePerNight) &&
            (identical(other.photo, photo) || other.photo == photo) &&
            const DeepCollectionEquality().equals(
              other._suitableFor,
              _suitableFor,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    label,
    geoLocation,
    createdAt,
    isCloseToWater,
    isCampFireAllowed,
    const DeepCollectionEquality().hash(_hostLanguages),
    pricePerNight,
    photo,
    const DeepCollectionEquality().hash(_suitableFor),
  );

  /// Create a copy of CampsiteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CampsiteModelImplCopyWith<_$CampsiteModelImpl> get copyWith =>
      __$$CampsiteModelImplCopyWithImpl<_$CampsiteModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CampsiteModelImplToJson(this);
  }
}

abstract class _CampsiteModel extends CampsiteModel {
  const factory _CampsiteModel({
    required final String id,
    required final String label,
    required final GeoLocationModel geoLocation,
    required final String createdAt,
    @JsonKey(name: 'isCloseToWater') required final bool isCloseToWater,
    @JsonKey(name: 'isCampFireAllowed') required final bool isCampFireAllowed,
    required final List<String> hostLanguages,
    required final double pricePerNight,
    required final String photo,
    required final List<String> suitableFor,
  }) = _$CampsiteModelImpl;
  const _CampsiteModel._() : super._();

  factory _CampsiteModel.fromJson(Map<String, dynamic> json) =
      _$CampsiteModelImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  GeoLocationModel get geoLocation;
  @override
  String get createdAt;
  @override
  @JsonKey(name: 'isCloseToWater')
  bool get isCloseToWater;
  @override
  @JsonKey(name: 'isCampFireAllowed')
  bool get isCampFireAllowed;
  @override
  List<String> get hostLanguages;
  @override
  double get pricePerNight;
  @override
  String get photo;
  @override
  List<String> get suitableFor;

  /// Create a copy of CampsiteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CampsiteModelImplCopyWith<_$CampsiteModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
