// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_criteria.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FilterCriteria {
  bool? get isCloseToWater => throw _privateConstructorUsedError;
  bool? get isCampFireAllowed => throw _privateConstructorUsedError;
  List<String> get hostLanguages => throw _privateConstructorUsedError;
  double? get minPrice => throw _privateConstructorUsedError;
  double? get maxPrice => throw _privateConstructorUsedError;

  /// Create a copy of FilterCriteria
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FilterCriteriaCopyWith<FilterCriteria> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterCriteriaCopyWith<$Res> {
  factory $FilterCriteriaCopyWith(
    FilterCriteria value,
    $Res Function(FilterCriteria) then,
  ) = _$FilterCriteriaCopyWithImpl<$Res, FilterCriteria>;
  @useResult
  $Res call({
    bool? isCloseToWater,
    bool? isCampFireAllowed,
    List<String> hostLanguages,
    double? minPrice,
    double? maxPrice,
  });
}

/// @nodoc
class _$FilterCriteriaCopyWithImpl<$Res, $Val extends FilterCriteria>
    implements $FilterCriteriaCopyWith<$Res> {
  _$FilterCriteriaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FilterCriteria
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCloseToWater = freezed,
    Object? isCampFireAllowed = freezed,
    Object? hostLanguages = null,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
  }) {
    return _then(
      _value.copyWith(
            isCloseToWater:
                freezed == isCloseToWater
                    ? _value.isCloseToWater
                    : isCloseToWater // ignore: cast_nullable_to_non_nullable
                        as bool?,
            isCampFireAllowed:
                freezed == isCampFireAllowed
                    ? _value.isCampFireAllowed
                    : isCampFireAllowed // ignore: cast_nullable_to_non_nullable
                        as bool?,
            hostLanguages:
                null == hostLanguages
                    ? _value.hostLanguages
                    : hostLanguages // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            minPrice:
                freezed == minPrice
                    ? _value.minPrice
                    : minPrice // ignore: cast_nullable_to_non_nullable
                        as double?,
            maxPrice:
                freezed == maxPrice
                    ? _value.maxPrice
                    : maxPrice // ignore: cast_nullable_to_non_nullable
                        as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FilterCriteriaImplCopyWith<$Res>
    implements $FilterCriteriaCopyWith<$Res> {
  factory _$$FilterCriteriaImplCopyWith(
    _$FilterCriteriaImpl value,
    $Res Function(_$FilterCriteriaImpl) then,
  ) = __$$FilterCriteriaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool? isCloseToWater,
    bool? isCampFireAllowed,
    List<String> hostLanguages,
    double? minPrice,
    double? maxPrice,
  });
}

/// @nodoc
class __$$FilterCriteriaImplCopyWithImpl<$Res>
    extends _$FilterCriteriaCopyWithImpl<$Res, _$FilterCriteriaImpl>
    implements _$$FilterCriteriaImplCopyWith<$Res> {
  __$$FilterCriteriaImplCopyWithImpl(
    _$FilterCriteriaImpl _value,
    $Res Function(_$FilterCriteriaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FilterCriteria
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCloseToWater = freezed,
    Object? isCampFireAllowed = freezed,
    Object? hostLanguages = null,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
  }) {
    return _then(
      _$FilterCriteriaImpl(
        isCloseToWater:
            freezed == isCloseToWater
                ? _value.isCloseToWater
                : isCloseToWater // ignore: cast_nullable_to_non_nullable
                    as bool?,
        isCampFireAllowed:
            freezed == isCampFireAllowed
                ? _value.isCampFireAllowed
                : isCampFireAllowed // ignore: cast_nullable_to_non_nullable
                    as bool?,
        hostLanguages:
            null == hostLanguages
                ? _value._hostLanguages
                : hostLanguages // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        minPrice:
            freezed == minPrice
                ? _value.minPrice
                : minPrice // ignore: cast_nullable_to_non_nullable
                    as double?,
        maxPrice:
            freezed == maxPrice
                ? _value.maxPrice
                : maxPrice // ignore: cast_nullable_to_non_nullable
                    as double?,
      ),
    );
  }
}

/// @nodoc

class _$FilterCriteriaImpl extends _FilterCriteria {
  const _$FilterCriteriaImpl({
    this.isCloseToWater = null,
    this.isCampFireAllowed = null,
    final List<String> hostLanguages = const <String>[],
    this.minPrice = null,
    this.maxPrice = null,
  }) : _hostLanguages = hostLanguages,
       super._();

  @override
  @JsonKey()
  final bool? isCloseToWater;
  @override
  @JsonKey()
  final bool? isCampFireAllowed;
  final List<String> _hostLanguages;
  @override
  @JsonKey()
  List<String> get hostLanguages {
    if (_hostLanguages is EqualUnmodifiableListView) return _hostLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hostLanguages);
  }

  @override
  @JsonKey()
  final double? minPrice;
  @override
  @JsonKey()
  final double? maxPrice;

  @override
  String toString() {
    return 'FilterCriteria(isCloseToWater: $isCloseToWater, isCampFireAllowed: $isCampFireAllowed, hostLanguages: $hostLanguages, minPrice: $minPrice, maxPrice: $maxPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterCriteriaImpl &&
            (identical(other.isCloseToWater, isCloseToWater) ||
                other.isCloseToWater == isCloseToWater) &&
            (identical(other.isCampFireAllowed, isCampFireAllowed) ||
                other.isCampFireAllowed == isCampFireAllowed) &&
            const DeepCollectionEquality().equals(
              other._hostLanguages,
              _hostLanguages,
            ) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isCloseToWater,
    isCampFireAllowed,
    const DeepCollectionEquality().hash(_hostLanguages),
    minPrice,
    maxPrice,
  );

  /// Create a copy of FilterCriteria
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterCriteriaImplCopyWith<_$FilterCriteriaImpl> get copyWith =>
      __$$FilterCriteriaImplCopyWithImpl<_$FilterCriteriaImpl>(
        this,
        _$identity,
      );
}

abstract class _FilterCriteria extends FilterCriteria {
  const factory _FilterCriteria({
    final bool? isCloseToWater,
    final bool? isCampFireAllowed,
    final List<String> hostLanguages,
    final double? minPrice,
    final double? maxPrice,
  }) = _$FilterCriteriaImpl;
  const _FilterCriteria._() : super._();

  @override
  bool? get isCloseToWater;
  @override
  bool? get isCampFireAllowed;
  @override
  List<String> get hostLanguages;
  @override
  double? get minPrice;
  @override
  double? get maxPrice;

  /// Create a copy of FilterCriteria
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterCriteriaImplCopyWith<_$FilterCriteriaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
