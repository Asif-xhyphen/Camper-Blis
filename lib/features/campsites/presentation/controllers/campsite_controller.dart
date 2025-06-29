import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/campsite.dart';
import '../../domain/entities/filter_criteria.dart';
import '../../domain/entities/geo_location.dart';
import '../../domain/usecases/get_campsites.dart';
import '../../domain/usecases/filter_campsites.dart';
import '../../../../core/providers/providers.dart';
import 'filter_controller.dart';

part 'campsite_controller.freezed.dart';

@freezed
class CampsiteState with _$CampsiteState {
  const factory CampsiteState({
    @Default([]) List<Campsite> campsites,
    @Default([]) List<Campsite> filteredCampsites,
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    String? errorMessage,
    FilterCriteria? appliedFilters,
  }) = _CampsiteState;
}

class CampsiteController extends StateNotifier<CampsiteState> {
  final GetCampsites _getCampsites;
  final FilterCampsites _filterCampsites;

  CampsiteController(this._getCampsites, this._filterCampsites)
    : super(const CampsiteState()) {
    loadCampsites();
  }

  Future<void> loadCampsites() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _getCampsites();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (campsites) {
        final filteredList =
            state.appliedFilters != null
                ? _applyFilters(campsites, state.appliedFilters!)
                : campsites;

        state = state.copyWith(
          campsites: campsites,
          filteredCampsites: filteredList,
          isLoading: false,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> refreshCampsites() async {
    if (state.isRefreshing) return;

    state = state.copyWith(isRefreshing: true, errorMessage: null);

    final result = await _getCampsites.refresh();

    result.fold(
      (failure) {
        state = state.copyWith(
          isRefreshing: false,
          errorMessage: failure.message,
        );
      },
      (campsites) {
        final filteredList = _applyCurrentFilters(campsites);
        state = state.copyWith(
          campsites: campsites,
          filteredCampsites: filteredList,
          isRefreshing: false,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> applyFilters(FilterCriteria filters) async {
    final localFilteredList = _applyFilters(state.campsites, filters);
    state = state.copyWith(
      filteredCampsites: localFilteredList,
      appliedFilters: filters,
    );
  }

  void clearFilters() {
    state = state.copyWith(
      filteredCampsites: state.campsites,
      appliedFilters: null,
    );
  }

  List<Campsite> _applyCurrentFilters(List<Campsite> campsites) {
    if (state.appliedFilters == null) return campsites;
    return _applyFilters(campsites, state.appliedFilters!);
  }

  List<Campsite> _applyFilters(
    List<Campsite> campsites,
    FilterCriteria filters,
  ) {
    return campsites.where((campsite) {
      if (filters.isCloseToWater != null &&
          campsite.isCloseToWater != filters.isCloseToWater) {
        return false;
      }

      if (filters.isCampFireAllowed != null &&
          campsite.isCampFireAllowed != filters.isCampFireAllowed) {
        return false;
      }

      if (filters.hostLanguages.isNotEmpty &&
          !filters.hostLanguages.any(
            (lang) => campsite.hostLanguages.contains(lang),
          )) {
        return false;
      }

      if (filters.minPrice != null &&
          campsite.pricePerNight < filters.minPrice!) {
        return false;
      }

      if (filters.maxPrice != null &&
          campsite.pricePerNight > filters.maxPrice!) {
        return false;
      }

      return true;
    }).toList();
  }

  Future<void> searchCampsites(String searchTerm) async {
    if (searchTerm.isEmpty) {
      final filteredList =
          state.appliedFilters != null
              ? _applyFilters(state.campsites, state.appliedFilters!)
              : state.campsites;

      state = state.copyWith(filteredCampsites: filteredList);
      return;
    }

    final searchResults =
        state.campsites.where((campsite) {
          final searchLower = searchTerm.toLowerCase();
          return _matchesSearch(campsite, searchLower);
        }).toList();

    final filteredResults =
        state.appliedFilters != null
            ? _applyFilters(searchResults, state.appliedFilters!)
            : searchResults;

    state = state.copyWith(filteredCampsites: filteredResults);
  }

  bool _matchesSearch(Campsite campsite, String searchTerm) {
    if (searchTerm.isEmpty) return true;

    final String searchLower = searchTerm.toLowerCase();
    return campsite.label.toLowerCase().contains(searchLower) ||
        campsite.hostLanguages.any(
          (lang) => lang.toLowerCase().contains(searchLower),
        );
  }
}

final campsiteControllerProvider =
    StateNotifierProvider<CampsiteController, CampsiteState>((ref) {
      final getCampsites = ref.watch(getCampsitesUseCaseProvider);
      final filterCampsites = ref.watch(filterCampsitesUseCaseProvider);
      final controller = CampsiteController(getCampsites, filterCampsites);

      ref.listen<FilterCriteria>(filterControllerProvider, (previous, next) {
        if (previous != next) {
          controller.applyFilters(next);
        }
      });

      return controller;
    });

final filteredCampsitesProvider = Provider<List<Campsite>>((ref) {
  final state = ref.watch(campsiteControllerProvider);
  return state.filteredCampsites;
});

final campsiteByIdProvider = Provider.family<Campsite?, String>((ref, id) {
  final campsites = ref.watch(filteredCampsitesProvider);
  try {
    return campsites.firstWhere((campsite) => campsite.id == id);
  } catch (e) {
    return null;
  }
});

final campsiteLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(campsiteControllerProvider);
  return state.isLoading;
});

final campsiteErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(campsiteControllerProvider);
  return state.errorMessage;
});

final campsiteSearchProvider = Provider<Future<void> Function(String)>((ref) {
  final controller = ref.watch(campsiteControllerProvider.notifier);
  return controller.searchCampsites;
});
