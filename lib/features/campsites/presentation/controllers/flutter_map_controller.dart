import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/campsite.dart';
import '../../../../shared/theme/colors.dart';
import '../widgets/campsite_popup.dart';
import 'campsite_controller.dart';

part 'flutter_map_controller.freezed.dart';

/// Cluster data class
@freezed
class ClusterData with _$ClusterData {
  const factory ClusterData({
    required LatLng center,
    required int count,
    required List<Campsite> campsites,
    required String id,
  }) = _ClusterData;
}

@freezed
class FlutterMapState with _$FlutterMapState {
  const factory FlutterMapState({
    MapController? mapController,
    PopupController? popupController,
    @Default(null) LatLng? currentLocation,
    @Default([]) List<Marker> markers,
    @Default(LatLng(51.1657, 10.4515)) LatLng initialCenter,
    @Default(6.0) double initialZoom,
    @Default(false) bool isLoading,
    @Default(true) bool showClustering,
    @Default(false) bool isPopupVisible,
    String? selectedCampsiteId,
    String? errorMessage,
    @Default([]) List<ClusterData> clusters,
  }) = _FlutterMapState;
}

class FlutterMapController extends StateNotifier<FlutterMapState> {
  FlutterMapController(this.ref) : super(const FlutterMapState()) {
    _initializeMap();
  }

  final Ref ref;

  /// Initialize map with default settings
  void _initializeMap() {
    state = state.copyWith(
      initialCenter: const LatLng(51.1657, 10.4515), // Center of Germany
      initialZoom: 6.0,
    );
  }

  /// Set map controller when map is ready
  void setMapController(
    MapController controller,
    PopupController popupController,
  ) {
    state = state.copyWith(
      mapController: controller,
      popupController: popupController,
    );
  }

  /// Update markers based on campsites with clustering
  void updateMarkers(List<Campsite> campsites) {
    if (state.showClustering) {
      _updateMarkersWithClustering(campsites);
    } else {
      _updateMarkersWithoutClustering(campsites);
    }
  }

  /// Update markers without clustering
  void _updateMarkersWithoutClustering(List<Campsite> campsites) {
    final List<Marker> markers = [];

    for (final campsite in campsites) {
      if (campsite.geoLocation.isValid) {
        markers.add(
          Marker(
            point: LatLng(
              campsite.geoLocation.latitude,
              campsite.geoLocation.longitude,
            ),
            child: _buildCampsiteMarker(campsite),
            key: ValueKey(campsite.id),
          ),
        );
      }
    }

    state = state.copyWith(markers: markers, clusters: []);
  }

  /// Update markers with simple clustering
  void _updateMarkersWithClustering(List<Campsite> campsites) {
    final mapController = state.mapController;
    if (mapController == null) {
      _updateMarkersWithoutClustering(campsites);
      return;
    }

    final double zoom = mapController.camera.zoom;
    final clusters = _calculateClusters(campsites, zoom);
    final List<Marker> markers = [];

    for (final cluster in clusters) {
      if (cluster.count == 1) {
        // Single campsite marker
        final campsite = cluster.campsites.first;
        markers.add(
          Marker(
            point: cluster.center,
            child: _buildCampsiteMarker(campsite),
            key: ValueKey(campsite.id),
          ),
        );
      } else {
        // Cluster marker
        markers.add(
          Marker(
            point: cluster.center,
            child: GestureDetector(
              onTap: () => _onClusterTap(cluster),
              child: _buildClusterMarker(cluster.count),
            ),
          ),
        );
      }
    }

    state = state.copyWith(markers: markers, clusters: clusters);
  }

  /// Simple clustering algorithm
  List<ClusterData> _calculateClusters(List<Campsite> campsites, double zoom) {
    // Much smaller cluster radius to prevent everything clustering together
    final double clusterRadius =
        zoom < 6
            ? 30.0 // At very low zoom, allow larger clusters
            : zoom < 8
            ? 20.0 // Medium zoom, medium clusters
            : zoom < 10
            ? 15.0 // Higher zoom, smaller clusters
            : 10.0; // High zoom, very small clusters

    final List<ClusterData> clusters = [];
    final Set<String> processed = {};

    for (final campsite in campsites) {
      if (!campsite.geoLocation.isValid || processed.contains(campsite.id)) {
        continue;
      }

      final List<Campsite> clusterCampsites = [campsite];
      processed.add(campsite.id);

      // Find nearby campsites to cluster
      for (final otherCampsite in campsites) {
        if (!otherCampsite.geoLocation.isValid ||
            processed.contains(otherCampsite.id) ||
            otherCampsite.id == campsite.id) {
          continue;
        }

        final distance = _calculatePixelDistance(
          LatLng(campsite.geoLocation.latitude, campsite.geoLocation.longitude),
          LatLng(
            otherCampsite.geoLocation.latitude,
            otherCampsite.geoLocation.longitude,
          ),
          zoom,
        );

        if (distance <= clusterRadius) {
          clusterCampsites.add(otherCampsite);
          processed.add(otherCampsite.id);
        }
      }

      // Calculate cluster center
      final LatLng center = _calculateClusterCenter(clusterCampsites);

      clusters.add(
        ClusterData(
          center: center,
          count: clusterCampsites.length,
          campsites: clusterCampsites,
          id: 'cluster_${campsite.id}_${clusterCampsites.length}',
        ),
      );

      print(
        '📍 Created cluster ${clusters.length}: ${clusterCampsites.length} campsites around ${campsite.label}',
      );
    }

    print(
      '🎯 Final result: ${clusters.length} clusters with sizes: ${clusters.map((c) => c.count).join(', ')}',
    );
    return clusters;
  }

  /// Calculate approximate pixel distance between two points at given zoom
  double _calculatePixelDistance(LatLng point1, LatLng point2, double zoom) {
    // Simplified pixel distance calculation
    // At zoom level 10, roughly 1 degree = 100 pixels
    final double pixelsPerDegree = 100 * math.pow(2, zoom - 10).toDouble();

    final double dx =
        (point2.longitude - point1.longitude).abs() * pixelsPerDegree;
    final double dy =
        (point2.latitude - point1.latitude).abs() * pixelsPerDegree;

    final double distance = math.sqrt(dx * dx + dy * dy);

    // Debug first few calculations
    if (math.Random().nextDouble() < 0.01) {
      // Print 1% of calculations
      print(
        '    Distance calc: (${point1.latitude.toStringAsFixed(4)}, ${point1.longitude.toStringAsFixed(4)}) to (${point2.latitude.toStringAsFixed(4)}, ${point2.longitude.toStringAsFixed(4)}) = ${distance.toStringAsFixed(1)}px',
      );
    }

    return distance;
  }

  /// Calculate center point of campsites
  LatLng _calculateClusterCenter(List<Campsite> campsites) {
    if (campsites.length == 1) {
      return LatLng(
        campsites.first.geoLocation.latitude,
        campsites.first.geoLocation.longitude,
      );
    }

    double totalLat = 0;
    double totalLng = 0;
    for (final campsite in campsites) {
      totalLat += campsite.geoLocation.latitude;
      totalLng += campsite.geoLocation.longitude;
    }

    return LatLng(totalLat / campsites.length, totalLng / campsites.length);
  }

  /// Build individual campsite marker
  Widget _buildCampsiteMarker(Campsite campsite) {
    final bool isSelected = state.selectedCampsiteId == campsite.id;

    return GestureDetector(
      onTap: () {
        // Select campsite and show popup
        selectCampsite(
          campsite.id,
          LatLng(campsite.geoLocation.latitude, campsite.geoLocation.longitude),
        );
      },
      child: Container(
        width: isSelected ? 40 : 30,
        height: isSelected ? 40 : 30,
        decoration: BoxDecoration(
          color:
              campsite.pricePerNight > 40
                  ? Colors.orange
                  : AppColors.primaryGreen,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.white,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.place,
          color: Colors.white,
          size: isSelected ? 20 : 16,
        ),
      ),
    );
  }

  /// Build cluster marker
  Widget _buildClusterMarker(int count) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  /// Handle cluster tap - zoom in to show individual markers
  void _onClusterTap(ClusterData cluster) {
    final mapController = state.mapController;
    if (mapController != null) {
      final double currentZoom = mapController.camera.zoom;
      final double newZoom = (currentZoom + 2).clamp(1, 18);

      mapController.move(cluster.center, newZoom);

      // Force recalculation of clustering after zoom
      Future.delayed(const Duration(milliseconds: 200), () {
        final campsiteState = ref.read(campsiteControllerProvider);
        updateMarkers(campsiteState.filteredCampsites);
      });
    }
  }

  /// Select a campsite on the map
  void selectCampsite(String campsiteId, LatLng location) {
    final marker = state.markers.firstWhere(
      (marker) => marker.point == location,
    );

    // Center camera on the selected marker with intelligent zoom
    final mapController = state.mapController;
    if (mapController != null) {
      final currentZoom = mapController.camera.zoom;
      // Use current zoom if it's detailed enough, otherwise zoom to 14
      final targetZoom = currentZoom < 12.0 ? 14.0 : currentZoom;
      // add slight deviation in location to fit the popup above it
      moveToLocation(
        LatLng(location.latitude + 0.009, location.longitude),
        zoom: targetZoom,
      );
    }

    // Show popup after a slight delay to allow camera movement
    Future.delayed(const Duration(milliseconds: 300), () {
      state.popupController?.showPopupsAlsoFor([marker]);
    });

    state = state.copyWith(
      selectedCampsiteId: campsiteId,
      isPopupVisible: true,
    );
    // Trigger marker update to show selection
    final campsiteState = ref.read(campsiteControllerProvider);
    updateMarkers(campsiteState.filteredCampsites);
  }

  /// Clear campsite selection
  void clearSelection() {
    state.popupController?.hideAllPopups();
    state = state.copyWith(selectedCampsiteId: null, isPopupVisible: false);
    // Trigger marker update to clear selection
    final campsiteState = ref.read(campsiteControllerProvider);
    updateMarkers(campsiteState.filteredCampsites);
  }

  /// Show popup for a specific marker
  void showPopup(LatLng location) {
    state = state.copyWith(isPopupVisible: true);
  }

  /// Hide popup
  void hidePopup() {
    state = state.copyWith(isPopupVisible: false);
  }

  /// Move camera to specific location
  void moveToLocation(LatLng location, {double zoom = 14.0}) {
    final controller = state.mapController;
    if (controller != null) {
      controller.move(location, zoom);
    }
  }

  /// Move camera to campsite location
  void moveToCampsite(Campsite campsite) {
    final location = LatLng(
      campsite.geoLocation.latitude,
      campsite.geoLocation.longitude,
    );
    moveToLocation(location);
    selectCampsite(
      campsite.id,
      LatLng(campsite.geoLocation.latitude, campsite.geoLocation.longitude),
    );
  }

  /// Update current location
  void updateCurrentLocation(LatLng location) {
    state = state.copyWith(currentLocation: location);
  }

  /// Move to current location
  void moveToCurrentLocation() {
    final currentLocation = state.currentLocation;
    if (currentLocation != null) {
      moveToLocation(currentLocation);
    }
  }

  /// Fit camera to show all markers
  void fitToMarkers() {
    final controller = state.mapController;
    if (controller != null && state.markers.isNotEmpty) {
      final bounds = _calculateBounds();
      if (bounds != null) {
        controller.fitCamera(CameraFit.bounds(bounds: bounds));
      }
    }
  }

  /// Calculate bounds for all markers
  LatLngBounds? _calculateBounds() {
    if (state.markers.isEmpty) return null;

    final List<LatLng> points =
        state.markers.map((marker) => marker.point).toList();

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = minLat < point.latitude ? minLat : point.latitude;
      maxLat = maxLat > point.latitude ? maxLat : point.latitude;
      minLng = minLng < point.longitude ? minLng : point.longitude;
      maxLng = maxLng > point.longitude ? maxLng : point.longitude;
    }

    return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  }

  /// Toggle clustering on/off
  void toggleClustering() {
    state = state.copyWith(showClustering: !state.showClustering);
    final campsiteState = ref.read(campsiteControllerProvider);
    updateMarkers(campsiteState.filteredCampsites);
  }

  /// Zoom in
  void zoomIn() {
    final controller = state.mapController;
    if (controller != null) {
      final currentZoom = controller.camera.zoom;
      controller.move(controller.camera.center, (currentZoom + 1).clamp(1, 18));
    }
  }

  /// Zoom out
  void zoomOut() {
    final controller = state.mapController;
    if (controller != null) {
      final currentZoom = controller.camera.zoom;
      controller.move(controller.camera.center, (currentZoom - 1).clamp(1, 18));
    }
  }

  /// Handle map error
  void setError(String error) {
    state = state.copyWith(errorMessage: error);
  }

  /// Clear map error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Listen to zoom changes and update clustering
  void onZoomChanged() {
    final campsiteState = ref.read(campsiteControllerProvider);
    updateMarkers(campsiteState.filteredCampsites);
  }

  /// Force immediate clustering update (useful after zoom operations)
  void forceClusteringUpdate() {
    final campsiteState = ref.read(campsiteControllerProvider);
    updateMarkers(campsiteState.filteredCampsites);
  }

  /// Build popup content for a marker
  Widget buildPopupForMarker(BuildContext context, Marker marker) {
    // Find the campsite for this marker
    final campsiteState = ref.read(campsiteControllerProvider);
    final campsite = campsiteState.filteredCampsites.firstWhere(
      (c) =>
          LatLng(c.geoLocation.latitude, c.geoLocation.longitude) ==
          marker.point,
      orElse: () => throw Exception('Campsite not found for marker'),
    );

    // Ensure popup state is updated when popup is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!state.isPopupVisible) {
        state = state.copyWith(isPopupVisible: true);
      }
    });

    return CampsitePopup(
      campsite: campsite,
      onTap: () {
        // Navigate to campsite detail or close popup
        clearSelection(); // This will hide the popup and show the list again
        // navigate to campsite detail page
        context.go('/campsite/${campsite.id}');
      },
    );
  }
}

/// Provider for map controller
final flutterMapControllerProvider =
    StateNotifierProvider<FlutterMapController, FlutterMapState>((ref) {
      final controller = FlutterMapController(ref);

      // Listen to campsite changes and update markers
      ref.listen(filteredCampsitesProvider, (previous, next) {
        controller.updateMarkers(next);
      });

      return controller;
    });

/// Provider for map markers
final mapMarkersProvider = Provider<List<Marker>>((ref) {
  final state = ref.watch(flutterMapControllerProvider);
  return state.markers;
});

/// Provider for selected campsite
final selectedCampsiteProvider = Provider<Campsite?>((ref) {
  final mapState = ref.watch(flutterMapControllerProvider);
  final selectedId = mapState.selectedCampsiteId;

  if (selectedId == null) return null;

  final campsiteState = ref.watch(campsiteControllerProvider);
  try {
    return campsiteState.filteredCampsites.firstWhere(
      (c) => c.id == selectedId,
    );
  } catch (e) {
    return null;
  }
});

/// Provider for current location
final currentLocationProvider = Provider<LatLng?>((ref) {
  final state = ref.watch(flutterMapControllerProvider);
  return state.currentLocation;
});

/// Provider for map controller instance
final mapControllerInstanceProvider = Provider<MapController?>((ref) {
  final state = ref.watch(flutterMapControllerProvider);
  return state.mapController;
});

/// Provider for popup visibility state
final isPopupVisibleProvider = Provider<bool>((ref) {
  final state = ref.watch(flutterMapControllerProvider);
  return state.isPopupVisible;
});
