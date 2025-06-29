// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'campsite_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CampsiteState {
  List<Campsite> get campsites => throw _privateConstructorUsedError;
  List<Campsite> get filteredCampsites => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  FilterCriteria? get appliedFilters => throw _privateConstructorUsedError;

  /// Create a copy of CampsiteState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CampsiteStateCopyWith<CampsiteState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CampsiteStateCopyWith<$Res> {
  factory $CampsiteStateCopyWith(
    CampsiteState value,
    $Res Function(CampsiteState) then,
  ) = _$CampsiteStateCopyWithImpl<$Res, CampsiteState>;
  @useResult
  $Res call({
    List<Campsite> campsites,
    List<Campsite> filteredCampsites,
    bool isLoading,
    bool isRefreshing,
    String? errorMessage,
    FilterCriteria? appliedFilters,
  });

  $FilterCriteriaCopyWith<$Res>? get appliedFilters;
}

/// @nodoc
class _$CampsiteStateCopyWithImpl<$Res, $Val extends CampsiteState>
    implements $CampsiteStateCopyWith<$Res> {
  _$CampsiteStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CampsiteState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? campsites = null,
    Object? filteredCampsites = null,
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? errorMessage = freezed,
    Object? appliedFilters = freezed,
  }) {
    return _then(
      _value.copyWith(
            campsites:
                null == campsites
                    ? _value.campsites
                    : campsites // ignore: cast_nullable_to_non_nullable
                        as List<Campsite>,
            filteredCampsites:
                null == filteredCampsites
                    ? _value.filteredCampsites
                    : filteredCampsites // ignore: cast_nullable_to_non_nullable
                        as List<Campsite>,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            isRefreshing:
                null == isRefreshing
                    ? _value.isRefreshing
                    : isRefreshing // ignore: cast_nullable_to_non_nullable
                        as bool,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            appliedFilters:
                freezed == appliedFilters
                    ? _value.appliedFilters
                    : appliedFilters // ignore: cast_nullable_to_non_nullable
                        as FilterCriteria?,
          )
          as $Val,
    );
  }

  /// Create a copy of CampsiteState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FilterCriteriaCopyWith<$Res>? get appliedFilters {
    if (_value.appliedFilters == null) {
      return null;
    }

    return $FilterCriteriaCopyWith<$Res>(_value.appliedFilters!, (value) {
      return _then(_value.copyWith(appliedFilters: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CampsiteStateImplCopyWith<$Res>
    implements $CampsiteStateCopyWith<$Res> {
  factory _$$CampsiteStateImplCopyWith(
    _$CampsiteStateImpl value,
    $Res Function(_$CampsiteStateImpl) then,
  ) = __$$CampsiteStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Campsite> campsites,
    List<Campsite> filteredCampsites,
    bool isLoading,
    bool isRefreshing,
    String? errorMessage,
    FilterCriteria? appliedFilters,
  });

  @override
  $FilterCriteriaCopyWith<$Res>? get appliedFilters;
}

/// @nodoc
class __$$CampsiteStateImplCopyWithImpl<$Res>
    extends _$CampsiteStateCopyWithImpl<$Res, _$CampsiteStateImpl>
    implements _$$CampsiteStateImplCopyWith<$Res> {
  __$$CampsiteStateImplCopyWithImpl(
    _$CampsiteStateImpl _value,
    $Res Function(_$CampsiteStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CampsiteState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? campsites = null,
    Object? filteredCampsites = null,
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? errorMessage = freezed,
    Object? appliedFilters = freezed,
  }) {
    return _then(
      _$CampsiteStateImpl(
        campsites:
            null == campsites
                ? _value._campsites
                : campsites // ignore: cast_nullable_to_non_nullable
                    as List<Campsite>,
        filteredCampsites:
            null == filteredCampsites
                ? _value._filteredCampsites
                : filteredCampsites // ignore: cast_nullable_to_non_nullable
                    as List<Campsite>,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        isRefreshing:
            null == isRefreshing
                ? _value.isRefreshing
                : isRefreshing // ignore: cast_nullable_to_non_nullable
                    as bool,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        appliedFilters:
            freezed == appliedFilters
                ? _value.appliedFilters
                : appliedFilters // ignore: cast_nullable_to_non_nullable
                    as FilterCriteria?,
      ),
    );
  }
}

/// @nodoc

class _$CampsiteStateImpl implements _CampsiteState {
  const _$CampsiteStateImpl({
    final List<Campsite> campsites = const [],
    final List<Campsite> filteredCampsites = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.appliedFilters,
  }) : _campsites = campsites,
       _filteredCampsites = filteredCampsites;

  final List<Campsite> _campsites;
  @override
  @JsonKey()
  List<Campsite> get campsites {
    if (_campsites is EqualUnmodifiableListView) return _campsites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_campsites);
  }

  final List<Campsite> _filteredCampsites;
  @override
  @JsonKey()
  List<Campsite> get filteredCampsites {
    if (_filteredCampsites is EqualUnmodifiableListView)
      return _filteredCampsites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredCampsites);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  final String? errorMessage;
  @override
  final FilterCriteria? appliedFilters;

  @override
  String toString() {
    return 'CampsiteState(campsites: $campsites, filteredCampsites: $filteredCampsites, isLoading: $isLoading, isRefreshing: $isRefreshing, errorMessage: $errorMessage, appliedFilters: $appliedFilters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CampsiteStateImpl &&
            const DeepCollectionEquality().equals(
              other._campsites,
              _campsites,
            ) &&
            const DeepCollectionEquality().equals(
              other._filteredCampsites,
              _filteredCampsites,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.appliedFilters, appliedFilters) ||
                other.appliedFilters == appliedFilters));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_campsites),
    const DeepCollectionEquality().hash(_filteredCampsites),
    isLoading,
    isRefreshing,
    errorMessage,
    appliedFilters,
  );

  /// Create a copy of CampsiteState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CampsiteStateImplCopyWith<_$CampsiteStateImpl> get copyWith =>
      __$$CampsiteStateImplCopyWithImpl<_$CampsiteStateImpl>(this, _$identity);
}

abstract class _CampsiteState implements CampsiteState {
  const factory _CampsiteState({
    final List<Campsite> campsites,
    final List<Campsite> filteredCampsites,
    final bool isLoading,
    final bool isRefreshing,
    final String? errorMessage,
    final FilterCriteria? appliedFilters,
  }) = _$CampsiteStateImpl;

  @override
  List<Campsite> get campsites;
  @override
  List<Campsite> get filteredCampsites;
  @override
  bool get isLoading;
  @override
  bool get isRefreshing;
  @override
  String? get errorMessage;
  @override
  FilterCriteria? get appliedFilters;

  /// Create a copy of CampsiteState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CampsiteStateImplCopyWith<_$CampsiteStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
