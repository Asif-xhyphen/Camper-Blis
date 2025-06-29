// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flutter_map_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ClusterData {
  LatLng get center => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  List<Campsite> get campsites => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;

  /// Create a copy of ClusterData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClusterDataCopyWith<ClusterData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClusterDataCopyWith<$Res> {
  factory $ClusterDataCopyWith(
    ClusterData value,
    $Res Function(ClusterData) then,
  ) = _$ClusterDataCopyWithImpl<$Res, ClusterData>;
  @useResult
  $Res call({LatLng center, int count, List<Campsite> campsites, String id});
}

/// @nodoc
class _$ClusterDataCopyWithImpl<$Res, $Val extends ClusterData>
    implements $ClusterDataCopyWith<$Res> {
  _$ClusterDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClusterData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? center = null,
    Object? count = null,
    Object? campsites = null,
    Object? id = null,
  }) {
    return _then(
      _value.copyWith(
            center:
                null == center
                    ? _value.center
                    : center // ignore: cast_nullable_to_non_nullable
                        as LatLng,
            count:
                null == count
                    ? _value.count
                    : count // ignore: cast_nullable_to_non_nullable
                        as int,
            campsites:
                null == campsites
                    ? _value.campsites
                    : campsites // ignore: cast_nullable_to_non_nullable
                        as List<Campsite>,
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClusterDataImplCopyWith<$Res>
    implements $ClusterDataCopyWith<$Res> {
  factory _$$ClusterDataImplCopyWith(
    _$ClusterDataImpl value,
    $Res Function(_$ClusterDataImpl) then,
  ) = __$$ClusterDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LatLng center, int count, List<Campsite> campsites, String id});
}

/// @nodoc
class __$$ClusterDataImplCopyWithImpl<$Res>
    extends _$ClusterDataCopyWithImpl<$Res, _$ClusterDataImpl>
    implements _$$ClusterDataImplCopyWith<$Res> {
  __$$ClusterDataImplCopyWithImpl(
    _$ClusterDataImpl _value,
    $Res Function(_$ClusterDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClusterData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? center = null,
    Object? count = null,
    Object? campsites = null,
    Object? id = null,
  }) {
    return _then(
      _$ClusterDataImpl(
        center:
            null == center
                ? _value.center
                : center // ignore: cast_nullable_to_non_nullable
                    as LatLng,
        count:
            null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                    as int,
        campsites:
            null == campsites
                ? _value._campsites
                : campsites // ignore: cast_nullable_to_non_nullable
                    as List<Campsite>,
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$ClusterDataImpl implements _ClusterData {
  const _$ClusterDataImpl({
    required this.center,
    required this.count,
    required final List<Campsite> campsites,
    required this.id,
  }) : _campsites = campsites;

  @override
  final LatLng center;
  @override
  final int count;
  final List<Campsite> _campsites;
  @override
  List<Campsite> get campsites {
    if (_campsites is EqualUnmodifiableListView) return _campsites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_campsites);
  }

  @override
  final String id;

  @override
  String toString() {
    return 'ClusterData(center: $center, count: $count, campsites: $campsites, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClusterDataImpl &&
            (identical(other.center, center) || other.center == center) &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality().equals(
              other._campsites,
              _campsites,
            ) &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    center,
    count,
    const DeepCollectionEquality().hash(_campsites),
    id,
  );

  /// Create a copy of ClusterData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClusterDataImplCopyWith<_$ClusterDataImpl> get copyWith =>
      __$$ClusterDataImplCopyWithImpl<_$ClusterDataImpl>(this, _$identity);
}

abstract class _ClusterData implements ClusterData {
  const factory _ClusterData({
    required final LatLng center,
    required final int count,
    required final List<Campsite> campsites,
    required final String id,
  }) = _$ClusterDataImpl;

  @override
  LatLng get center;
  @override
  int get count;
  @override
  List<Campsite> get campsites;
  @override
  String get id;

  /// Create a copy of ClusterData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClusterDataImplCopyWith<_$ClusterDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FlutterMapState {
  MapController? get mapController => throw _privateConstructorUsedError;
  PopupController? get popupController => throw _privateConstructorUsedError;
  LatLng? get currentLocation => throw _privateConstructorUsedError;
  List<Marker> get markers => throw _privateConstructorUsedError;
  LatLng get initialCenter => throw _privateConstructorUsedError;
  double get initialZoom => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get showClustering => throw _privateConstructorUsedError;
  bool get isPopupVisible => throw _privateConstructorUsedError;
  String? get selectedCampsiteId => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  List<ClusterData> get clusters => throw _privateConstructorUsedError;

  /// Create a copy of FlutterMapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlutterMapStateCopyWith<FlutterMapState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlutterMapStateCopyWith<$Res> {
  factory $FlutterMapStateCopyWith(
    FlutterMapState value,
    $Res Function(FlutterMapState) then,
  ) = _$FlutterMapStateCopyWithImpl<$Res, FlutterMapState>;
  @useResult
  $Res call({
    MapController? mapController,
    PopupController? popupController,
    LatLng? currentLocation,
    List<Marker> markers,
    LatLng initialCenter,
    double initialZoom,
    bool isLoading,
    bool showClustering,
    bool isPopupVisible,
    String? selectedCampsiteId,
    String? errorMessage,
    List<ClusterData> clusters,
  });
}

/// @nodoc
class _$FlutterMapStateCopyWithImpl<$Res, $Val extends FlutterMapState>
    implements $FlutterMapStateCopyWith<$Res> {
  _$FlutterMapStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlutterMapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapController = freezed,
    Object? popupController = freezed,
    Object? currentLocation = freezed,
    Object? markers = null,
    Object? initialCenter = null,
    Object? initialZoom = null,
    Object? isLoading = null,
    Object? showClustering = null,
    Object? isPopupVisible = null,
    Object? selectedCampsiteId = freezed,
    Object? errorMessage = freezed,
    Object? clusters = null,
  }) {
    return _then(
      _value.copyWith(
            mapController:
                freezed == mapController
                    ? _value.mapController
                    : mapController // ignore: cast_nullable_to_non_nullable
                        as MapController?,
            popupController:
                freezed == popupController
                    ? _value.popupController
                    : popupController // ignore: cast_nullable_to_non_nullable
                        as PopupController?,
            currentLocation:
                freezed == currentLocation
                    ? _value.currentLocation
                    : currentLocation // ignore: cast_nullable_to_non_nullable
                        as LatLng?,
            markers:
                null == markers
                    ? _value.markers
                    : markers // ignore: cast_nullable_to_non_nullable
                        as List<Marker>,
            initialCenter:
                null == initialCenter
                    ? _value.initialCenter
                    : initialCenter // ignore: cast_nullable_to_non_nullable
                        as LatLng,
            initialZoom:
                null == initialZoom
                    ? _value.initialZoom
                    : initialZoom // ignore: cast_nullable_to_non_nullable
                        as double,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            showClustering:
                null == showClustering
                    ? _value.showClustering
                    : showClustering // ignore: cast_nullable_to_non_nullable
                        as bool,
            isPopupVisible:
                null == isPopupVisible
                    ? _value.isPopupVisible
                    : isPopupVisible // ignore: cast_nullable_to_non_nullable
                        as bool,
            selectedCampsiteId:
                freezed == selectedCampsiteId
                    ? _value.selectedCampsiteId
                    : selectedCampsiteId // ignore: cast_nullable_to_non_nullable
                        as String?,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            clusters:
                null == clusters
                    ? _value.clusters
                    : clusters // ignore: cast_nullable_to_non_nullable
                        as List<ClusterData>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FlutterMapStateImplCopyWith<$Res>
    implements $FlutterMapStateCopyWith<$Res> {
  factory _$$FlutterMapStateImplCopyWith(
    _$FlutterMapStateImpl value,
    $Res Function(_$FlutterMapStateImpl) then,
  ) = __$$FlutterMapStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    MapController? mapController,
    PopupController? popupController,
    LatLng? currentLocation,
    List<Marker> markers,
    LatLng initialCenter,
    double initialZoom,
    bool isLoading,
    bool showClustering,
    bool isPopupVisible,
    String? selectedCampsiteId,
    String? errorMessage,
    List<ClusterData> clusters,
  });
}

/// @nodoc
class __$$FlutterMapStateImplCopyWithImpl<$Res>
    extends _$FlutterMapStateCopyWithImpl<$Res, _$FlutterMapStateImpl>
    implements _$$FlutterMapStateImplCopyWith<$Res> {
  __$$FlutterMapStateImplCopyWithImpl(
    _$FlutterMapStateImpl _value,
    $Res Function(_$FlutterMapStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlutterMapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapController = freezed,
    Object? popupController = freezed,
    Object? currentLocation = freezed,
    Object? markers = null,
    Object? initialCenter = null,
    Object? initialZoom = null,
    Object? isLoading = null,
    Object? showClustering = null,
    Object? isPopupVisible = null,
    Object? selectedCampsiteId = freezed,
    Object? errorMessage = freezed,
    Object? clusters = null,
  }) {
    return _then(
      _$FlutterMapStateImpl(
        mapController:
            freezed == mapController
                ? _value.mapController
                : mapController // ignore: cast_nullable_to_non_nullable
                    as MapController?,
        popupController:
            freezed == popupController
                ? _value.popupController
                : popupController // ignore: cast_nullable_to_non_nullable
                    as PopupController?,
        currentLocation:
            freezed == currentLocation
                ? _value.currentLocation
                : currentLocation // ignore: cast_nullable_to_non_nullable
                    as LatLng?,
        markers:
            null == markers
                ? _value._markers
                : markers // ignore: cast_nullable_to_non_nullable
                    as List<Marker>,
        initialCenter:
            null == initialCenter
                ? _value.initialCenter
                : initialCenter // ignore: cast_nullable_to_non_nullable
                    as LatLng,
        initialZoom:
            null == initialZoom
                ? _value.initialZoom
                : initialZoom // ignore: cast_nullable_to_non_nullable
                    as double,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        showClustering:
            null == showClustering
                ? _value.showClustering
                : showClustering // ignore: cast_nullable_to_non_nullable
                    as bool,
        isPopupVisible:
            null == isPopupVisible
                ? _value.isPopupVisible
                : isPopupVisible // ignore: cast_nullable_to_non_nullable
                    as bool,
        selectedCampsiteId:
            freezed == selectedCampsiteId
                ? _value.selectedCampsiteId
                : selectedCampsiteId // ignore: cast_nullable_to_non_nullable
                    as String?,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        clusters:
            null == clusters
                ? _value._clusters
                : clusters // ignore: cast_nullable_to_non_nullable
                    as List<ClusterData>,
      ),
    );
  }
}

/// @nodoc

class _$FlutterMapStateImpl implements _FlutterMapState {
  const _$FlutterMapStateImpl({
    this.mapController,
    this.popupController,
    this.currentLocation = null,
    final List<Marker> markers = const [],
    this.initialCenter = const LatLng(51.1657, 10.4515),
    this.initialZoom = 6.0,
    this.isLoading = false,
    this.showClustering = true,
    this.isPopupVisible = false,
    this.selectedCampsiteId,
    this.errorMessage,
    final List<ClusterData> clusters = const [],
  }) : _markers = markers,
       _clusters = clusters;

  @override
  final MapController? mapController;
  @override
  final PopupController? popupController;
  @override
  @JsonKey()
  final LatLng? currentLocation;
  final List<Marker> _markers;
  @override
  @JsonKey()
  List<Marker> get markers {
    if (_markers is EqualUnmodifiableListView) return _markers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_markers);
  }

  @override
  @JsonKey()
  final LatLng initialCenter;
  @override
  @JsonKey()
  final double initialZoom;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool showClustering;
  @override
  @JsonKey()
  final bool isPopupVisible;
  @override
  final String? selectedCampsiteId;
  @override
  final String? errorMessage;
  final List<ClusterData> _clusters;
  @override
  @JsonKey()
  List<ClusterData> get clusters {
    if (_clusters is EqualUnmodifiableListView) return _clusters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_clusters);
  }

  @override
  String toString() {
    return 'FlutterMapState(mapController: $mapController, popupController: $popupController, currentLocation: $currentLocation, markers: $markers, initialCenter: $initialCenter, initialZoom: $initialZoom, isLoading: $isLoading, showClustering: $showClustering, isPopupVisible: $isPopupVisible, selectedCampsiteId: $selectedCampsiteId, errorMessage: $errorMessage, clusters: $clusters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlutterMapStateImpl &&
            (identical(other.mapController, mapController) ||
                other.mapController == mapController) &&
            (identical(other.popupController, popupController) ||
                other.popupController == popupController) &&
            (identical(other.currentLocation, currentLocation) ||
                other.currentLocation == currentLocation) &&
            const DeepCollectionEquality().equals(other._markers, _markers) &&
            (identical(other.initialCenter, initialCenter) ||
                other.initialCenter == initialCenter) &&
            (identical(other.initialZoom, initialZoom) ||
                other.initialZoom == initialZoom) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.showClustering, showClustering) ||
                other.showClustering == showClustering) &&
            (identical(other.isPopupVisible, isPopupVisible) ||
                other.isPopupVisible == isPopupVisible) &&
            (identical(other.selectedCampsiteId, selectedCampsiteId) ||
                other.selectedCampsiteId == selectedCampsiteId) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality().equals(other._clusters, _clusters));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    mapController,
    popupController,
    currentLocation,
    const DeepCollectionEquality().hash(_markers),
    initialCenter,
    initialZoom,
    isLoading,
    showClustering,
    isPopupVisible,
    selectedCampsiteId,
    errorMessage,
    const DeepCollectionEquality().hash(_clusters),
  );

  /// Create a copy of FlutterMapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlutterMapStateImplCopyWith<_$FlutterMapStateImpl> get copyWith =>
      __$$FlutterMapStateImplCopyWithImpl<_$FlutterMapStateImpl>(
        this,
        _$identity,
      );
}

abstract class _FlutterMapState implements FlutterMapState {
  const factory _FlutterMapState({
    final MapController? mapController,
    final PopupController? popupController,
    final LatLng? currentLocation,
    final List<Marker> markers,
    final LatLng initialCenter,
    final double initialZoom,
    final bool isLoading,
    final bool showClustering,
    final bool isPopupVisible,
    final String? selectedCampsiteId,
    final String? errorMessage,
    final List<ClusterData> clusters,
  }) = _$FlutterMapStateImpl;

  @override
  MapController? get mapController;
  @override
  PopupController? get popupController;
  @override
  LatLng? get currentLocation;
  @override
  List<Marker> get markers;
  @override
  LatLng get initialCenter;
  @override
  double get initialZoom;
  @override
  bool get isLoading;
  @override
  bool get showClustering;
  @override
  bool get isPopupVisible;
  @override
  String? get selectedCampsiteId;
  @override
  String? get errorMessage;
  @override
  List<ClusterData> get clusters;

  /// Create a copy of FlutterMapState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlutterMapStateImplCopyWith<_$FlutterMapStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
