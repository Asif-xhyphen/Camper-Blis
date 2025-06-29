// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'campsite_detail_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CampsiteDetailState {
  Campsite? get campsite => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  int get currentImageIndex => throw _privateConstructorUsedError;
  bool get isImageGalleryOpen => throw _privateConstructorUsedError;

  /// Create a copy of CampsiteDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CampsiteDetailStateCopyWith<CampsiteDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CampsiteDetailStateCopyWith<$Res> {
  factory $CampsiteDetailStateCopyWith(
    CampsiteDetailState value,
    $Res Function(CampsiteDetailState) then,
  ) = _$CampsiteDetailStateCopyWithImpl<$Res, CampsiteDetailState>;
  @useResult
  $Res call({
    Campsite? campsite,
    bool isLoading,
    String? errorMessage,
    int currentImageIndex,
    bool isImageGalleryOpen,
  });

  $CampsiteCopyWith<$Res>? get campsite;
}

/// @nodoc
class _$CampsiteDetailStateCopyWithImpl<$Res, $Val extends CampsiteDetailState>
    implements $CampsiteDetailStateCopyWith<$Res> {
  _$CampsiteDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CampsiteDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? campsite = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? currentImageIndex = null,
    Object? isImageGalleryOpen = null,
  }) {
    return _then(
      _value.copyWith(
            campsite:
                freezed == campsite
                    ? _value.campsite
                    : campsite // ignore: cast_nullable_to_non_nullable
                        as Campsite?,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            currentImageIndex:
                null == currentImageIndex
                    ? _value.currentImageIndex
                    : currentImageIndex // ignore: cast_nullable_to_non_nullable
                        as int,
            isImageGalleryOpen:
                null == isImageGalleryOpen
                    ? _value.isImageGalleryOpen
                    : isImageGalleryOpen // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of CampsiteDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CampsiteCopyWith<$Res>? get campsite {
    if (_value.campsite == null) {
      return null;
    }

    return $CampsiteCopyWith<$Res>(_value.campsite!, (value) {
      return _then(_value.copyWith(campsite: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CampsiteDetailStateImplCopyWith<$Res>
    implements $CampsiteDetailStateCopyWith<$Res> {
  factory _$$CampsiteDetailStateImplCopyWith(
    _$CampsiteDetailStateImpl value,
    $Res Function(_$CampsiteDetailStateImpl) then,
  ) = __$$CampsiteDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Campsite? campsite,
    bool isLoading,
    String? errorMessage,
    int currentImageIndex,
    bool isImageGalleryOpen,
  });

  @override
  $CampsiteCopyWith<$Res>? get campsite;
}

/// @nodoc
class __$$CampsiteDetailStateImplCopyWithImpl<$Res>
    extends _$CampsiteDetailStateCopyWithImpl<$Res, _$CampsiteDetailStateImpl>
    implements _$$CampsiteDetailStateImplCopyWith<$Res> {
  __$$CampsiteDetailStateImplCopyWithImpl(
    _$CampsiteDetailStateImpl _value,
    $Res Function(_$CampsiteDetailStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CampsiteDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? campsite = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? currentImageIndex = null,
    Object? isImageGalleryOpen = null,
  }) {
    return _then(
      _$CampsiteDetailStateImpl(
        campsite:
            freezed == campsite
                ? _value.campsite
                : campsite // ignore: cast_nullable_to_non_nullable
                    as Campsite?,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        currentImageIndex:
            null == currentImageIndex
                ? _value.currentImageIndex
                : currentImageIndex // ignore: cast_nullable_to_non_nullable
                    as int,
        isImageGalleryOpen:
            null == isImageGalleryOpen
                ? _value.isImageGalleryOpen
                : isImageGalleryOpen // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$CampsiteDetailStateImpl implements _CampsiteDetailState {
  const _$CampsiteDetailStateImpl({
    this.campsite,
    this.isLoading = false,
    this.errorMessage,
    this.currentImageIndex = 0,
    this.isImageGalleryOpen = false,
  });

  @override
  final Campsite? campsite;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final int currentImageIndex;
  @override
  @JsonKey()
  final bool isImageGalleryOpen;

  @override
  String toString() {
    return 'CampsiteDetailState(campsite: $campsite, isLoading: $isLoading, errorMessage: $errorMessage, currentImageIndex: $currentImageIndex, isImageGalleryOpen: $isImageGalleryOpen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CampsiteDetailStateImpl &&
            (identical(other.campsite, campsite) ||
                other.campsite == campsite) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.currentImageIndex, currentImageIndex) ||
                other.currentImageIndex == currentImageIndex) &&
            (identical(other.isImageGalleryOpen, isImageGalleryOpen) ||
                other.isImageGalleryOpen == isImageGalleryOpen));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    campsite,
    isLoading,
    errorMessage,
    currentImageIndex,
    isImageGalleryOpen,
  );

  /// Create a copy of CampsiteDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CampsiteDetailStateImplCopyWith<_$CampsiteDetailStateImpl> get copyWith =>
      __$$CampsiteDetailStateImplCopyWithImpl<_$CampsiteDetailStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CampsiteDetailState implements CampsiteDetailState {
  const factory _CampsiteDetailState({
    final Campsite? campsite,
    final bool isLoading,
    final String? errorMessage,
    final int currentImageIndex,
    final bool isImageGalleryOpen,
  }) = _$CampsiteDetailStateImpl;

  @override
  Campsite? get campsite;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  int get currentImageIndex;
  @override
  bool get isImageGalleryOpen;

  /// Create a copy of CampsiteDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CampsiteDetailStateImplCopyWith<_$CampsiteDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
