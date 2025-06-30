import 'package:flutter_test/flutter_test.dart';
import 'package:camper_blis/features/campsites/data/models/campsite_model.dart';
import 'package:camper_blis/features/campsites/data/models/geo_location_model.dart';
import 'package:camper_blis/features/campsites/domain/entities/campsite.dart';
import 'package:camper_blis/features/campsites/domain/entities/geo_location.dart';

void main() {
  group('CampsiteModel', () {
    late CampsiteModel testCampsiteModel;
    late Campsite testCampsite;
    late Map<String, dynamic> testJson;

    setUp(() {
      testCampsiteModel = const CampsiteModel(
        id: 'test_id',
        label: 'Test Campsite',
        geoLocation: GeoLocationModel(latitude: 52.5, longitude: 13.4),
        createdAt: '2024-01-15T10:30:00.000Z',
        isCloseToWater: true,
        isCampFireAllowed: false,
        hostLanguages: ['en', 'de'],
        pricePerNight: 35.50,
        photo: 'https://example.com/test.jpg',
        suitableFor: ['tent', 'rv'],
      );

      testCampsite = Campsite(
        id: 'test_id',
        label: 'Test Campsite',
        geoLocation: const GeoLocation(latitude: 52.5, longitude: 13.4),
        createdAt: DateTime.utc(2024, 1, 15, 10, 30, 0),
        isCloseToWater: true,
        isCampFireAllowed: false,
        hostLanguages: const ['en', 'de'],
        pricePerNight: 35.50,
        photo: 'https://example.com/test.jpg',
        suitableFor: const ['tent', 'rv'],
      );

      testJson = {
        'id': 'test_id',
        'label': 'Test Campsite',
        'geoLocation': {'lat': 52.5, 'long': 13.4},
        'createdAt': '2024-01-15T10:30:00.000Z',
        'isCloseToWater': true,
        'isCampFireAllowed': false,
        'hostLanguages': ['en', 'de'],
        'pricePerNight': 35.50,
        'photo': 'https://example.com/test.jpg',
        'suitableFor': ['tent', 'rv'],
      };
    });

    group('constructor and properties', () {
      test('should create CampsiteModel with all required fields', () {
        expect(testCampsiteModel.id, 'test_id');
        expect(testCampsiteModel.label, 'Test Campsite');
        expect(testCampsiteModel.geoLocation.latitude, 52.5);
        expect(testCampsiteModel.geoLocation.longitude, 13.4);
        expect(testCampsiteModel.createdAt, '2024-01-15T10:30:00.000Z');
        expect(testCampsiteModel.isCloseToWater, true);
        expect(testCampsiteModel.isCampFireAllowed, false);
        expect(testCampsiteModel.hostLanguages, ['en', 'de']);
        expect(testCampsiteModel.pricePerNight, 35.50);
        expect(testCampsiteModel.photo, 'https://example.com/test.jpg');
        expect(testCampsiteModel.suitableFor, ['tent', 'rv']);
      });

      test('should create CampsiteModel with different configurations', () {
        const model = CampsiteModel(
          id: 'different_id',
          label: 'Different Campsite',
          geoLocation: GeoLocationModel(latitude: 0.0, longitude: 0.0),
          createdAt: '2023-12-31T23:59:59.999Z',
          isCloseToWater: false,
          isCampFireAllowed: true,
          hostLanguages: ['fr', 'es', 'it'],
          pricePerNight: 15.0,
          photo: 'https://different.com/photo.jpg',
          suitableFor: ['tent'],
        );

        expect(model.id, 'different_id');
        expect(model.isCloseToWater, false);
        expect(model.isCampFireAllowed, true);
        expect(model.hostLanguages.length, 3);
        expect(model.pricePerNight, 15.0);
      });
    });

    group('fromJson', () {
      test('should create CampsiteModel from valid JSON', () {
        final model = CampsiteModel.fromJson(testJson);

        expect(model.id, testJson['id']);
        expect(model.label, testJson['label']);
        expect(model.geoLocation.latitude, testJson['geoLocation']['lat']);
        expect(model.geoLocation.longitude, testJson['geoLocation']['long']);
        expect(model.createdAt, testJson['createdAt']);
        expect(model.isCloseToWater, testJson['isCloseToWater']);
        expect(model.isCampFireAllowed, testJson['isCampFireAllowed']);
        expect(model.hostLanguages, testJson['hostLanguages']);
        expect(model.pricePerNight, testJson['pricePerNight']);
        expect(model.photo, testJson['photo']);
        expect(model.suitableFor, testJson['suitableFor']);
      });

      test('should handle different JSON field variations', () {
        final jsonWithDifferentFields = {
          'id': 'test_123',
          'label': 'JSON Test Campsite',
          'geoLocation': {'lat': -33.8688, 'long': 151.2093},
          'createdAt': '2023-06-15T14:20:00.000Z',
          'isCloseToWater': false,
          'isCampFireAllowed': true,
          'hostLanguages': ['en'],
          'pricePerNight': 42.75,
          'photo': 'https://json-test.com/image.png',
          'suitableFor': ['tent', 'rv', 'cabin'],
        };

        final model = CampsiteModel.fromJson(jsonWithDifferentFields);

        expect(model.id, 'test_123');
        expect(model.label, 'JSON Test Campsite');
        expect(model.geoLocation.latitude, -33.8688);
        expect(model.geoLocation.longitude, 151.2093);
        expect(model.isCloseToWater, false);
        expect(model.isCampFireAllowed, true);
        expect(model.hostLanguages, ['en']);
        expect(model.pricePerNight, 42.75);
        expect(model.suitableFor, ['tent', 'rv', 'cabin']);
      });

      test('should handle empty host languages and suitable for lists', () {
        final jsonWithEmptyLists = Map<String, dynamic>.from(testJson);
        jsonWithEmptyLists['hostLanguages'] = <String>[];
        jsonWithEmptyLists['suitableFor'] = <String>[];

        final model = CampsiteModel.fromJson(jsonWithEmptyLists);

        expect(model.hostLanguages, isEmpty);
        expect(model.suitableFor, isEmpty);
      });

      test('should handle large host languages and suitable for lists', () {
        final jsonWithLargeLists = Map<String, dynamic>.from(testJson);
        jsonWithLargeLists['hostLanguages'] = List.generate(
          10,
          (i) => 'lang$i',
        );
        jsonWithLargeLists['suitableFor'] = List.generate(5, (i) => 'type$i');

        final model = CampsiteModel.fromJson(jsonWithLargeLists);

        expect(model.hostLanguages.length, 10);
        expect(model.suitableFor.length, 5);
        expect(model.hostLanguages.first, 'lang0');
        expect(model.suitableFor.last, 'type4');
      });
    });

    group('toJson', () {
      test('should convert CampsiteModel to valid JSON', () {
        final json = testCampsiteModel.toJson();

        expect(json['id'], testCampsiteModel.id);
        expect(json['label'], testCampsiteModel.label);
        expect(
          json['geoLocation']['lat'],
          testCampsiteModel.geoLocation.latitude,
        );
        expect(
          json['geoLocation']['long'],
          testCampsiteModel.geoLocation.longitude,
        );
        expect(json['createdAt'], testCampsiteModel.createdAt);
        expect(json['isCloseToWater'], testCampsiteModel.isCloseToWater);
        expect(json['isCampFireAllowed'], testCampsiteModel.isCampFireAllowed);
        expect(json['hostLanguages'], testCampsiteModel.hostLanguages);
        expect(json['pricePerNight'], testCampsiteModel.pricePerNight);
        expect(json['photo'], testCampsiteModel.photo);
        expect(json['suitableFor'], testCampsiteModel.suitableFor);
      });

      test('should create JSON that can be parsed back to same model', () {
        final json = testCampsiteModel.toJson();
        final recreatedModel = CampsiteModel.fromJson(json);

        expect(recreatedModel, equals(testCampsiteModel));
      });

      test('should handle edge cases in JSON conversion', () {
        const edgeCaseModel = CampsiteModel(
          id: '',
          label: '',
          geoLocation: GeoLocationModel(latitude: 0.0, longitude: 0.0),
          createdAt: '1970-01-01T00:00:00.000Z',
          isCloseToWater: false,
          isCampFireAllowed: false,
          hostLanguages: [],
          pricePerNight: 0.0,
          photo: '',
          suitableFor: [],
        );

        final json = edgeCaseModel.toJson();
        final recreatedModel = CampsiteModel.fromJson(json);

        expect(recreatedModel, equals(edgeCaseModel));
      });
    });

    group('toDomain', () {
      test('should convert CampsiteModel to Campsite domain entity', () {
        final domainEntity = testCampsiteModel.toDomain();

        expect(domainEntity.id, testCampsiteModel.id);
        expect(domainEntity.label, testCampsiteModel.label);
        expect(
          domainEntity.geoLocation.latitude,
          testCampsiteModel.geoLocation.latitude,
        );
        expect(
          domainEntity.geoLocation.longitude,
          testCampsiteModel.geoLocation.longitude,
        );
        expect(
          domainEntity.createdAt,
          DateTime.parse(testCampsiteModel.createdAt),
        );
        expect(domainEntity.isCloseToWater, testCampsiteModel.isCloseToWater);
        expect(
          domainEntity.isCampFireAllowed,
          testCampsiteModel.isCampFireAllowed,
        );
        expect(domainEntity.hostLanguages, testCampsiteModel.hostLanguages);
        expect(domainEntity.pricePerNight, testCampsiteModel.pricePerNight);
        expect(domainEntity.photo, testCampsiteModel.photo);
        expect(domainEntity.suitableFor, testCampsiteModel.suitableFor);
      });

      test('should correctly parse different date formats', () {
        final modelWithDifferentDate = testCampsiteModel.copyWith(
          createdAt: '2023-12-25T00:00:00.000Z',
        );

        final domainEntity = modelWithDifferentDate.toDomain();

        expect(domainEntity.createdAt, DateTime.utc(2023, 12, 25));
      });

      test('should handle edge case values correctly', () {
        const edgeCaseModel = CampsiteModel(
          id: 'edge_case_id',
          label: 'Edge Case Campsite',
          geoLocation: GeoLocationModel(latitude: 90.0, longitude: 180.0),
          createdAt: '2024-02-29T23:59:59.999Z', // Leap year
          isCloseToWater: true,
          isCampFireAllowed: true,
          hostLanguages: ['zh', 'hi', 'ar', 'bn', 'pt'],
          pricePerNight: 9999.99,
          photo: 'https://very-long-domain-name.example.com/path/to/image.jpg',
          suitableFor: ['tent', 'rv', 'cabin', 'van', 'motorcycle'],
        );

        final domainEntity = edgeCaseModel.toDomain();

        expect(domainEntity.id, 'edge_case_id');
        expect(domainEntity.geoLocation.latitude, 90.0);
        expect(domainEntity.geoLocation.longitude, 180.0);
        expect(domainEntity.createdAt.year, 2024);
        expect(domainEntity.createdAt.month, 2);
        expect(domainEntity.createdAt.day, 29);
        expect(domainEntity.hostLanguages.length, 5);
        expect(domainEntity.pricePerNight, 9999.99);
        expect(domainEntity.suitableFor.length, 5);
      });

      test('should preserve all business logic properties', () {
        final domainEntity = testCampsiteModel.toDomain();

        // Test that domain entity business logic works correctly
        expect(domainEntity.formattedPrice, '€36 / night');
        expect(domainEntity.amenities, contains('Close to Water'));
        expect(domainEntity.matchesSearchTerm('test'), true);
        expect(domainEntity.primaryHostLanguage, 'en');
      });
    });

    group('fromDomain', () {
      test('should convert Campsite domain entity to CampsiteModel', () {
        final model = CampsiteModel.fromDomain(testCampsite);

        expect(model.id, testCampsite.id);
        expect(model.label, testCampsite.label);
        expect(model.geoLocation.latitude, testCampsite.geoLocation.latitude);
        expect(model.geoLocation.longitude, testCampsite.geoLocation.longitude);
        expect(model.createdAt, testCampsite.createdAt.toIso8601String());
        expect(model.isCloseToWater, testCampsite.isCloseToWater);
        expect(model.isCampFireAllowed, testCampsite.isCampFireAllowed);
        expect(model.hostLanguages, testCampsite.hostLanguages);
        expect(model.pricePerNight, testCampsite.pricePerNight);
        expect(model.photo, testCampsite.photo);
        expect(model.suitableFor, testCampsite.suitableFor);
      });

      test('should handle different date formats correctly', () {
        final campsiteWithDifferentDate = testCampsite.copyWith(
          createdAt: DateTime.utc(2023, 11, 5, 15, 45, 30),
        );

        final model = CampsiteModel.fromDomain(campsiteWithDifferentDate);

        expect(model.createdAt, '2023-11-05T15:45:30.000Z');
      });

      test('should handle timezone-aware dates correctly', () {
        final localDateTime = DateTime(2024, 3, 15, 10, 30);
        final campsiteWithLocalDate = testCampsite.copyWith(
          createdAt: localDateTime,
        );

        final model = CampsiteModel.fromDomain(campsiteWithLocalDate);

        expect(model.createdAt, localDateTime.toIso8601String());
      });

      test('should preserve all data correctly for edge cases', () {
        final edgeCaseCampsite = Campsite(
          id: 'domain_edge_case',
          label: 'Domain Edge Case',
          geoLocation: const GeoLocation(latitude: -90.0, longitude: -180.0),
          createdAt: DateTime.utc(1970, 1, 1),
          isCloseToWater: false,
          isCampFireAllowed: false,
          hostLanguages: const [],
          pricePerNight: 0.0,
          photo: '',
          suitableFor: const [],
        );

        final model = CampsiteModel.fromDomain(edgeCaseCampsite);

        expect(model.id, 'domain_edge_case');
        expect(model.geoLocation.latitude, -90.0);
        expect(model.geoLocation.longitude, -180.0);
        expect(model.createdAt, '1970-01-01T00:00:00.000Z');
        expect(model.hostLanguages, isEmpty);
        expect(model.pricePerNight, 0.0);
        expect(model.suitableFor, isEmpty);
      });
    });

    group('bidirectional conversion', () {
      test('should maintain data integrity in round-trip conversions', () {
        // Model -> Domain -> Model
        final domainEntity = testCampsiteModel.toDomain();
        final convertedBackModel = CampsiteModel.fromDomain(domainEntity);

        expect(convertedBackModel.id, testCampsiteModel.id);
        expect(convertedBackModel.label, testCampsiteModel.label);
        expect(
          convertedBackModel.geoLocation.latitude,
          testCampsiteModel.geoLocation.latitude,
        );
        expect(
          convertedBackModel.geoLocation.longitude,
          testCampsiteModel.geoLocation.longitude,
        );
        expect(
          convertedBackModel.isCloseToWater,
          testCampsiteModel.isCloseToWater,
        );
        expect(
          convertedBackModel.isCampFireAllowed,
          testCampsiteModel.isCampFireAllowed,
        );
        expect(
          convertedBackModel.hostLanguages,
          testCampsiteModel.hostLanguages,
        );
        expect(
          convertedBackModel.pricePerNight,
          testCampsiteModel.pricePerNight,
        );
        expect(convertedBackModel.photo, testCampsiteModel.photo);
        expect(convertedBackModel.suitableFor, testCampsiteModel.suitableFor);
      });

      test(
        'should maintain data integrity in Domain -> Model -> Domain conversion',
        () {
          // Domain -> Model -> Domain
          final model = CampsiteModel.fromDomain(testCampsite);
          final convertedBackDomain = model.toDomain();

          expect(convertedBackDomain.id, testCampsite.id);
          expect(convertedBackDomain.label, testCampsite.label);
          expect(
            convertedBackDomain.geoLocation.latitude,
            testCampsite.geoLocation.latitude,
          );
          expect(
            convertedBackDomain.geoLocation.longitude,
            testCampsite.geoLocation.longitude,
          );
          expect(convertedBackDomain.createdAt, testCampsite.createdAt);
          expect(
            convertedBackDomain.isCloseToWater,
            testCampsite.isCloseToWater,
          );
          expect(
            convertedBackDomain.isCampFireAllowed,
            testCampsite.isCampFireAllowed,
          );
          expect(convertedBackDomain.hostLanguages, testCampsite.hostLanguages);
          expect(convertedBackDomain.pricePerNight, testCampsite.pricePerNight);
          expect(convertedBackDomain.photo, testCampsite.photo);
          expect(convertedBackDomain.suitableFor, testCampsite.suitableFor);
        },
      );

      test('should handle multiple round-trip conversions', () {
        var currentModel = testCampsiteModel;

        // Perform multiple conversions
        for (int i = 0; i < 5; i++) {
          final domain = currentModel.toDomain();
          currentModel = CampsiteModel.fromDomain(domain);
        }

        // Data should still be consistent
        expect(currentModel.id, testCampsiteModel.id);
        expect(currentModel.label, testCampsiteModel.label);
        expect(currentModel.pricePerNight, testCampsiteModel.pricePerNight);
        expect(currentModel.hostLanguages, testCampsiteModel.hostLanguages);
      });
    });

    group('equality and copying', () {
      test('should be equal when all properties are the same', () {
        const model1 = CampsiteModel(
          id: 'same_id',
          label: 'Same Label',
          geoLocation: GeoLocationModel(latitude: 1.0, longitude: 2.0),
          createdAt: '2024-01-01T00:00:00.000Z',
          isCloseToWater: true,
          isCampFireAllowed: false,
          hostLanguages: ['en'],
          pricePerNight: 25.0,
          photo: 'photo.jpg',
          suitableFor: ['tent'],
        );

        const model2 = CampsiteModel(
          id: 'same_id',
          label: 'Same Label',
          geoLocation: GeoLocationModel(latitude: 1.0, longitude: 2.0),
          createdAt: '2024-01-01T00:00:00.000Z',
          isCloseToWater: true,
          isCampFireAllowed: false,
          hostLanguages: ['en'],
          pricePerNight: 25.0,
          photo: 'photo.jpg',
          suitableFor: ['tent'],
        );

        expect(model1, equals(model2));
        expect(model1.hashCode, equals(model2.hashCode));
      });

      test('should not be equal when properties differ', () {
        final model1 = testCampsiteModel;
        final model2 = testCampsiteModel.copyWith(id: 'different_id');

        expect(model1, isNot(equals(model2)));
      });

      test('should copy with changed properties', () {
        final copiedModel = testCampsiteModel.copyWith(
          label: 'New Label',
          pricePerNight: 50.0,
          isCloseToWater: false,
        );

        expect(copiedModel.id, testCampsiteModel.id); // unchanged
        expect(copiedModel.label, 'New Label'); // changed
        expect(copiedModel.pricePerNight, 50.0); // changed
        expect(copiedModel.isCloseToWater, false); // changed
        expect(
          copiedModel.hostLanguages,
          testCampsiteModel.hostLanguages,
        ); // unchanged
      });
    });
  });
}
