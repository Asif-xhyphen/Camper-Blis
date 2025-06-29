import 'package:flutter_test/flutter_test.dart';
import 'package:camper_blis/features/campsites/domain/entities/campsite.dart';
import 'package:camper_blis/features/campsites/domain/entities/geo_location.dart';
import 'package:camper_blis/features/campsites/domain/entities/filter_criteria.dart';

void main() {
  group('Filter Tests with JSON Data Structure', () {
    // Sample data matching the JSON structure provided
    final sampleCampsites = [
      Campsite(
        id: "1",
        label: "quibusdam",
        geoLocation: const GeoLocation(latitude: 96060.37, longitude: 72330.52),
        createdAt: DateTime.parse("2022-09-11T14:25:09.496Z"),
        isCloseToWater: true,
        isCampFireAllowed: false,
        hostLanguages: const ["en", "de"],
        pricePerNight: 78508.23,
        photo: "http://loremflickr.com/640/480",
        suitableFor: const [],
      ),
      Campsite(
        id: "2",
        label: "nobis",
        geoLocation: const GeoLocation(latitude: 32955.74, longitude: 93715.96),
        createdAt: DateTime.parse("2022-09-11T15:04:21.217Z"),
        isCloseToWater: false,
        isCampFireAllowed: true,
        hostLanguages: const ["en", "de"],
        pricePerNight: 80694.76,
        photo: "http://loremflickr.com/640/480",
        suitableFor: const [],
      ),
      Campsite(
        id: "10",
        label: "vel",
        geoLocation: const GeoLocation(latitude: 28877.36, longitude: 51900.3),
        createdAt: DateTime.parse("2022-09-11T22:50:37.791Z"),
        isCloseToWater: true,
        isCampFireAllowed: false,
        hostLanguages: const ["en", "de"],
        pricePerNight: 6930.03,
        photo: "http://loremflickr.com/640/480",
        suitableFor: const [],
      ),
    ];

    test('should filter by water proximity', () {
      const filterCriteria = FilterCriteria(isCloseToWater: true);

      final filtered = _applyFilters(sampleCampsites, filterCriteria);

      expect(filtered.length, 2);
      expect(filtered.every((campsite) => campsite.isCloseToWater), true);
    });

    test('should filter by campfire allowed', () {
      const filterCriteria = FilterCriteria(isCampFireAllowed: true);

      final filtered = _applyFilters(sampleCampsites, filterCriteria);

      expect(filtered.length, 1);
      expect(filtered.first.id, "2");
      expect(filtered.every((campsite) => campsite.isCampFireAllowed), true);
    });

    test('should filter by host languages', () {
      const filterCriteria = FilterCriteria(hostLanguages: ["en"]);

      final filtered = _applyFilters(sampleCampsites, filterCriteria);

      expect(filtered.length, 3); // All have "en"
      expect(
        filtered.every((campsite) => campsite.hostLanguages.contains("en")),
        true,
      );
    });

    test('should filter by price range', () {
      const filterCriteria = FilterCriteria(minPrice: 5000, maxPrice: 10000);

      final filtered = _applyFilters(sampleCampsites, filterCriteria);

      expect(filtered.length, 1);
      expect(filtered.first.id, "10");
      expect(filtered.first.pricePerNight, 6930.03);
    });

    test('should apply multiple filters', () {
      const filterCriteria = FilterCriteria(
        isCloseToWater: true,
        minPrice: 5000,
        maxPrice: 50000,
      );

      final filtered = _applyFilters(sampleCampsites, filterCriteria);

      expect(filtered.length, 1);
      expect(filtered.first.id, "10");
      expect(filtered.first.isCloseToWater, true);
      expect(filtered.first.pricePerNight, lessThan(50000));
    });

    test('should return empty list when no matches', () {
      const filterCriteria = FilterCriteria(
        isCloseToWater: true,
        isCampFireAllowed: true,
      );

      final filtered = _applyFilters(sampleCampsites, filterCriteria);

      expect(filtered.length, 0);
    });
  });
}

// Copy of the filter logic to test
List<Campsite> _applyFilters(List<Campsite> campsites, FilterCriteria filters) {
  return campsites.where((campsite) {
    // Water proximity filter
    if (filters.isCloseToWater != null &&
        campsite.isCloseToWater != filters.isCloseToWater) {
      return false;
    }

    // Campfire allowed filter
    if (filters.isCampFireAllowed != null &&
        campsite.isCampFireAllowed != filters.isCampFireAllowed) {
      return false;
    }

    // Host languages filter
    if (filters.hostLanguages.isNotEmpty &&
        !filters.hostLanguages.any(
          (lang) => campsite.hostLanguages.contains(lang),
        )) {
      return false;
    }

    // Price range filter
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
