import 'package:flutter_test/flutter_test.dart';
import 'package:camper_blis/features/campsites/domain/entities/filter_criteria.dart';

void main() {
  group('FilterCriteria', () {
    group('constructor and defaults', () {
      test('should create FilterCriteria with default values', () {
        const filterCriteria = FilterCriteria();

        expect(filterCriteria.isCloseToWater, null);
        expect(filterCriteria.isCampFireAllowed, null);
        expect(filterCriteria.hostLanguages, isEmpty);
        expect(filterCriteria.minPrice, null);
        expect(filterCriteria.maxPrice, null);
      });

      test('should create FilterCriteria with custom values', () {
        const filterCriteria = FilterCriteria(
          isCloseToWater: true,
          isCampFireAllowed: false,
          hostLanguages: ['en', 'de'],
          minPrice: 10.0,
          maxPrice: 50.0,
        );

        expect(filterCriteria.isCloseToWater, true);
        expect(filterCriteria.isCampFireAllowed, false);
        expect(filterCriteria.hostLanguages, ['en', 'de']);
        expect(filterCriteria.minPrice, 10.0);
        expect(filterCriteria.maxPrice, 50.0);
      });

      test('should create FilterCriteria with partial values', () {
        const filterCriteria = FilterCriteria(
          isCloseToWater: true,
          hostLanguages: ['fr'],
        );

        expect(filterCriteria.isCloseToWater, true);
        expect(filterCriteria.isCampFireAllowed, null);
        expect(filterCriteria.hostLanguages, ['fr']);
        expect(filterCriteria.minPrice, null);
        expect(filterCriteria.maxPrice, null);
      });
    });

    group('hasActiveFilters', () {
      test('should return false when no filters are set', () {
        const filterCriteria = FilterCriteria();
        expect(filterCriteria.hasActiveFilters, false);
      });

      test('should return true when isCloseToWater filter is set', () {
        const filterCriteria1 = FilterCriteria(isCloseToWater: true);
        const filterCriteria2 = FilterCriteria(isCloseToWater: false);

        expect(filterCriteria1.hasActiveFilters, true);
        expect(filterCriteria2.hasActiveFilters, true);
      });

      test('should return true when isCampFireAllowed filter is set', () {
        const filterCriteria1 = FilterCriteria(isCampFireAllowed: true);
        const filterCriteria2 = FilterCriteria(isCampFireAllowed: false);

        expect(filterCriteria1.hasActiveFilters, true);
        expect(filterCriteria2.hasActiveFilters, true);
      });

      test('should return true when host languages filter is set', () {
        const filterCriteria1 = FilterCriteria(hostLanguages: ['en']);
        const filterCriteria2 = FilterCriteria(
          hostLanguages: ['en', 'de', 'fr'],
        );

        expect(filterCriteria1.hasActiveFilters, true);
        expect(filterCriteria2.hasActiveFilters, true);
      });

      test('should return false when host languages is empty list', () {
        const filterCriteria = FilterCriteria(hostLanguages: []);
        expect(filterCriteria.hasActiveFilters, false);
      });

      test('should return true when minPrice filter is set', () {
        const filterCriteria1 = FilterCriteria(minPrice: 0.0);
        const filterCriteria2 = FilterCriteria(minPrice: 25.5);

        expect(filterCriteria1.hasActiveFilters, true);
        expect(filterCriteria2.hasActiveFilters, true);
      });

      test('should return true when maxPrice filter is set', () {
        const filterCriteria1 = FilterCriteria(maxPrice: 100.0);
        const filterCriteria2 = FilterCriteria(maxPrice: 0.0);

        expect(filterCriteria1.hasActiveFilters, true);
        expect(filterCriteria2.hasActiveFilters, true);
      });

      test('should return true when multiple filters are set', () {
        const filterCriteria = FilterCriteria(
          isCloseToWater: true,
          hostLanguages: ['en'],
          maxPrice: 50.0,
        );

        expect(filterCriteria.hasActiveFilters, true);
      });
    });

    group('activeFilterCount', () {
      test('should return 0 when no filters are active', () {
        const filterCriteria = FilterCriteria();
        expect(filterCriteria.activeFilterCount, 0);
      });

      test('should return 1 for single active filter', () {
        expect(const FilterCriteria(isCloseToWater: true).activeFilterCount, 1);
        expect(
          const FilterCriteria(isCampFireAllowed: false).activeFilterCount,
          1,
        );
        expect(
          const FilterCriteria(hostLanguages: ['en']).activeFilterCount,
          1,
        );
        expect(const FilterCriteria(minPrice: 10.0).activeFilterCount, 1);
        expect(const FilterCriteria(maxPrice: 50.0).activeFilterCount, 1);
      });

      test('should return correct count for multiple active filters', () {
        const filterCriteria1 = FilterCriteria(
          isCloseToWater: true,
          isCampFireAllowed: false,
        );
        expect(filterCriteria1.activeFilterCount, 2);

        const filterCriteria2 = FilterCriteria(
          isCloseToWater: true,
          hostLanguages: ['en', 'de'],
          minPrice: 10.0,
        );
        expect(filterCriteria2.activeFilterCount, 3);

        const filterCriteria3 = FilterCriteria(
          isCloseToWater: false,
          isCampFireAllowed: true,
          hostLanguages: ['fr'],
          minPrice: 5.0,
          maxPrice: 100.0,
        );
        expect(filterCriteria3.activeFilterCount, 5);
      });

      test('should not count empty host languages', () {
        const filterCriteria = FilterCriteria(
          isCloseToWater: true,
          hostLanguages: [], // Empty list should not count
          minPrice: 10.0,
        );
        expect(filterCriteria.activeFilterCount, 2);
      });
    });

    group('clearAll', () {
      test('should return new FilterCriteria with default values', () {
        const filterCriteria = FilterCriteria(
          isCloseToWater: true,
          isCampFireAllowed: false,
          hostLanguages: ['en', 'de'],
          minPrice: 10.0,
          maxPrice: 50.0,
        );

        final clearedCriteria = filterCriteria.clearAll();

        expect(clearedCriteria.isCloseToWater, null);
        expect(clearedCriteria.isCampFireAllowed, null);
        expect(clearedCriteria.hostLanguages, isEmpty);
        expect(clearedCriteria.minPrice, null);
        expect(clearedCriteria.maxPrice, null);
        expect(clearedCriteria.hasActiveFilters, false);
        expect(clearedCriteria.activeFilterCount, 0);
      });

      test('should return equivalent to default constructor', () {
        const filterCriteria = FilterCriteria(
          isCloseToWater: true,
          hostLanguages: ['en'],
        );

        final clearedCriteria = filterCriteria.clearAll();
        const defaultCriteria = FilterCriteria();

        expect(clearedCriteria, equals(defaultCriteria));
      });
    });

    group('isPriceInRange', () {
      test('should return true when no price filters are set', () {
        const filterCriteria = FilterCriteria();

        expect(filterCriteria.isPriceInRange(0.0), true);
        expect(filterCriteria.isPriceInRange(25.0), true);
        expect(filterCriteria.isPriceInRange(100.0), true);
        expect(filterCriteria.isPriceInRange(1000.0), true);
      });

      test('should check minimum price only when minPrice is set', () {
        const filterCriteria = FilterCriteria(minPrice: 20.0);

        expect(filterCriteria.isPriceInRange(19.99), false);
        expect(filterCriteria.isPriceInRange(20.0), true);
        expect(filterCriteria.isPriceInRange(20.01), true);
        expect(filterCriteria.isPriceInRange(100.0), true);
      });

      test('should check maximum price only when maxPrice is set', () {
        const filterCriteria = FilterCriteria(maxPrice: 50.0);

        expect(filterCriteria.isPriceInRange(0.0), true);
        expect(filterCriteria.isPriceInRange(49.99), true);
        expect(filterCriteria.isPriceInRange(50.0), true);
        expect(filterCriteria.isPriceInRange(50.01), false);
        expect(filterCriteria.isPriceInRange(100.0), false);
      });

      test('should check both min and max price when both are set', () {
        const filterCriteria = FilterCriteria(minPrice: 20.0, maxPrice: 50.0);

        expect(filterCriteria.isPriceInRange(19.99), false);
        expect(filterCriteria.isPriceInRange(20.0), true);
        expect(filterCriteria.isPriceInRange(35.0), true);
        expect(filterCriteria.isPriceInRange(50.0), true);
        expect(filterCriteria.isPriceInRange(50.01), false);
      });

      test('should handle edge case where min equals max', () {
        const filterCriteria = FilterCriteria(minPrice: 25.0, maxPrice: 25.0);

        expect(filterCriteria.isPriceInRange(24.99), false);
        expect(filterCriteria.isPriceInRange(25.0), true);
        expect(filterCriteria.isPriceInRange(25.01), false);
      });

      test('should handle zero prices correctly', () {
        const filterCriteria1 = FilterCriteria(minPrice: 0.0);
        const filterCriteria2 = FilterCriteria(maxPrice: 0.0);
        const filterCriteria3 = FilterCriteria(minPrice: 0.0, maxPrice: 0.0);

        expect(filterCriteria1.isPriceInRange(0.0), true);
        expect(filterCriteria2.isPriceInRange(0.0), true);
        expect(filterCriteria3.isPriceInRange(0.0), true);

        expect(filterCriteria2.isPriceInRange(0.01), false);
        expect(filterCriteria3.isPriceInRange(0.01), false);
      });

      test('should handle very large prices', () {
        const filterCriteria = FilterCriteria(
          minPrice: 1000.0,
          maxPrice: 10000.0,
        );

        expect(filterCriteria.isPriceInRange(999.99), false);
        expect(filterCriteria.isPriceInRange(1000.0), true);
        expect(filterCriteria.isPriceInRange(5000.0), true);
        expect(filterCriteria.isPriceInRange(10000.0), true);
        expect(filterCriteria.isPriceInRange(10000.01), false);
      });

      test('should handle decimal prices precisely', () {
        const filterCriteria = FilterCriteria(minPrice: 25.50, maxPrice: 25.75);

        expect(filterCriteria.isPriceInRange(25.49), false);
        expect(filterCriteria.isPriceInRange(25.50), true);
        expect(filterCriteria.isPriceInRange(25.60), true);
        expect(filterCriteria.isPriceInRange(25.75), true);
        expect(filterCriteria.isPriceInRange(25.76), false);
      });
    });

    group('equality and copying', () {
      test('should be equal when all properties are the same', () {
        const filterCriteria1 = FilterCriteria(
          isCloseToWater: true,
          isCampFireAllowed: false,
          hostLanguages: ['en', 'de'],
          minPrice: 10.0,
          maxPrice: 50.0,
        );

        const filterCriteria2 = FilterCriteria(
          isCloseToWater: true,
          isCampFireAllowed: false,
          hostLanguages: ['en', 'de'],
          minPrice: 10.0,
          maxPrice: 50.0,
        );

        expect(filterCriteria1, equals(filterCriteria2));
        expect(filterCriteria1.hashCode, equals(filterCriteria2.hashCode));
      });

      test('should not be equal when properties differ', () {
        const baseCriteria = FilterCriteria(
          isCloseToWater: true,
          hostLanguages: ['en'],
        );

        const differentCriteria = [
          FilterCriteria(isCloseToWater: false, hostLanguages: ['en']),
          FilterCriteria(isCloseToWater: true, hostLanguages: ['de']),
          FilterCriteria(
            isCloseToWater: true,
            hostLanguages: ['en'],
            minPrice: 10.0,
          ),
        ];

        for (final criteria in differentCriteria) {
          expect(baseCriteria, isNot(equals(criteria)));
        }
      });

      test('should copy with changed properties', () {
        const originalCriteria = FilterCriteria(
          isCloseToWater: true,
          hostLanguages: ['en'],
          minPrice: 10.0,
        );

        final copiedCriteria = originalCriteria.copyWith(
          isCloseToWater: false,
          maxPrice: 50.0,
        );

        expect(copiedCriteria.isCloseToWater, false);
        expect(copiedCriteria.hostLanguages, ['en']); // unchanged
        expect(copiedCriteria.minPrice, 10.0); // unchanged
        expect(copiedCriteria.maxPrice, 50.0); // new value
        expect(copiedCriteria.isCampFireAllowed, null); // unchanged
      });
    });

    group('edge cases and complex scenarios', () {
      test('should handle language list order independence in equality', () {
        const criteria1 = FilterCriteria(hostLanguages: ['en', 'de', 'fr']);
        const criteria2 = FilterCriteria(hostLanguages: ['en', 'de', 'fr']);

        expect(criteria1, equals(criteria2));
      });

      test('should handle very large host language lists', () {
        final manyLanguages = List.generate(100, (index) => 'lang$index');
        final filterCriteria = FilterCriteria(hostLanguages: manyLanguages);

        expect(filterCriteria.hostLanguages.length, 100);
        expect(filterCriteria.hasActiveFilters, true);
        expect(filterCriteria.activeFilterCount, 1);
      });

      test('should handle extreme price ranges', () {
        const filterCriteria = FilterCriteria(
          minPrice: -1000.0,
          maxPrice: 1000000.0,
        );

        expect(filterCriteria.isPriceInRange(-999.0), true);
        expect(filterCriteria.isPriceInRange(0.0), true);
        expect(filterCriteria.isPriceInRange(999999.0), true);
        expect(filterCriteria.isPriceInRange(-1001.0), false);
        expect(filterCriteria.isPriceInRange(1000001.0), false);
      });

      test('should handle all boolean combinations', () {
        const combinations = [
          FilterCriteria(isCloseToWater: true, isCampFireAllowed: true),
          FilterCriteria(isCloseToWater: true, isCampFireAllowed: false),
          FilterCriteria(isCloseToWater: false, isCampFireAllowed: true),
          FilterCriteria(isCloseToWater: false, isCampFireAllowed: false),
        ];

        for (final criteria in combinations) {
          expect(criteria.hasActiveFilters, true);
          expect(criteria.activeFilterCount, 2);
        }
      });

      test('should handle null vs false distinction', () {
        const nullCriteria = FilterCriteria(); // All null
        const falseCriteria = FilterCriteria(
          isCloseToWater: false,
          isCampFireAllowed: false,
        );

        expect(nullCriteria.hasActiveFilters, false);
        expect(falseCriteria.hasActiveFilters, true);
        expect(nullCriteria.activeFilterCount, 0);
        expect(falseCriteria.activeFilterCount, 2);
      });
    });
  });
}
