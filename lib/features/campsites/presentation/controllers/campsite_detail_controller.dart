import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/campsite.dart';
import '../../domain/usecases/get_campsite_details.dart';
import '../../../../core/providers/providers.dart';

part 'campsite_detail_controller.freezed.dart';

@freezed
class CampsiteDetailState with _$CampsiteDetailState {
  const factory CampsiteDetailState({
    Campsite? campsite,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(0) int currentImageIndex,
    @Default(false) bool isImageGalleryOpen,
  }) = _CampsiteDetailState;
}

class CampsiteDetailController extends StateNotifier<CampsiteDetailState> {
  final GetCampsiteDetails _getCampsiteDetails;
  final String campsiteId;

  CampsiteDetailController(this._getCampsiteDetails, this.campsiteId)
    : super(const CampsiteDetailState()) {
    loadCampsiteDetails();
  }

  /// Load campsite details by ID
  Future<void> loadCampsiteDetails() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _getCampsiteDetails(campsiteId);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (campsite) {
        state = state.copyWith(
          campsite: campsite,
          isLoading: false,
          errorMessage: null,
        );
      },
    );
  }

  /// Refresh campsite details
  Future<void> refreshCampsiteDetails() async {
    await loadCampsiteDetails();
  }

  /// Update current image index for gallery
  void updateImageIndex(int index) {
    state = state.copyWith(currentImageIndex: index);
  }

  /// Open image gallery
  void openImageGallery() {
    state = state.copyWith(isImageGalleryOpen: true);
  }

  /// Close image gallery
  void closeImageGallery() {
    state = state.copyWith(isImageGalleryOpen: false, currentImageIndex: 0);
  }

  /// Set error state
  void setError(String error) {
    state = state.copyWith(errorMessage: error);
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider for campsite detail controller
final campsiteDetailControllerProvider = StateNotifierProvider.family<
  CampsiteDetailController,
  CampsiteDetailState,
  String
>((ref, campsiteId) {
  final getCampsiteDetails = ref.watch(getCampsiteDetailsUseCaseProvider);
  return CampsiteDetailController(getCampsiteDetails, campsiteId);
});

/// Provider for current campsite details
final currentCampsiteProvider = Provider.family<Campsite?, String>((
  ref,
  campsiteId,
) {
  final state = ref.watch(campsiteDetailControllerProvider(campsiteId));
  return state.campsite;
});

/// Provider for campsite detail loading state
final campsiteDetailLoadingProvider = Provider.family<bool, String>((
  ref,
  campsiteId,
) {
  final state = ref.watch(campsiteDetailControllerProvider(campsiteId));
  return state.isLoading;
});

/// Provider for campsite detail error state
final campsiteDetailErrorProvider = Provider.family<String?, String>((
  ref,
  campsiteId,
) {
  final state = ref.watch(campsiteDetailControllerProvider(campsiteId));
  return state.errorMessage;
});

/// Provider for image gallery state
final imageGalleryStateProvider = Provider.family<bool, String>((
  ref,
  campsiteId,
) {
  final state = ref.watch(campsiteDetailControllerProvider(campsiteId));
  return state.isImageGalleryOpen;
});

/// Provider for current image index
final currentImageIndexProvider = Provider.family<int, String>((
  ref,
  campsiteId,
) {
  final state = ref.watch(campsiteDetailControllerProvider(campsiteId));
  return state.currentImageIndex;
});
