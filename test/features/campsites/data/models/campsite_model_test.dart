import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:camper_blis/features/campsites/data/models/campsite_model.dart';
import 'package:camper_blis/features/campsites/data/models/geo_location_model.dart';
import 'package:camper_blis/features/campsites/domain/entities/campsite.dart';
import 'package:camper_blis/features/campsites/domain/entities/geo_location.dart';

void main() {
  group('CampsiteModel', () {
    late CampsiteModel testCampsiteModel;
    late Map<String, dynamic> testJsonMap;

    setUp(() {
      testCampsiteModel = const CampsiteModel(
        id: '1',
        label: 'Beautiful Forest Campsite',
        geoLocation: GeoLocationModel(latitude: 52.5200, longitude: 13.4050),
        createdAt: '2024-01-15T10:30:00.000Z',
        isCloseToWater: true,
        isCampFireAllowed: false,
        hostLanguages: ['English', 'German'],
        pricePerNight: 25.50,
        photo: 'https://example.com/photo.jpg',
        suitableFor: ['Couples', 'Family'],
      );

      testJsonMap = {
        'id': '1',
        'label': 'Beautiful Forest Campsite',
        'geoLocation': {'lat': 52.5200, 'long': 13.4050},
        'createdAt': '2024-01-15T10:30:00.000Z',
        'isCloseToWater': true,
        'isCampFireAllowed': false,
        'hostLanguages': ['English', 'German'],
        'pricePerNight': 25.50,
        'photo': 'https://example.com/photo.jpg',
        'suitableFor': ['Couples', 'Family'],
      };
    });

    group('JSON Serialization', () {
      test('should serialize to JSON correctly', () {
        // Act
        final json = testCampsiteModel.toJson();

        // Assert
        expect(json['id'], '1');
        expect(json['label'], 'Beautiful Forest Campsite');
        expect(json['createdAt'], '2024-01-15T10:30:00.000Z');
        expect(json['isCloseToWater'], true);
        expect(json['isCampFireAllowed'], false);
        expect(json['hostLanguages'], ['English', 'German']);
        expect(json['pricePerNight'], 25.50);
        expect(json['photo'], 'https://example.com/photo.jpg');
        expect(json['suitableFor'], ['Couples', 'Family']);
        expect(json['geoLocation']['lat'], 52.5200);
        expect(json['geoLocation']['long'], 13.4050);
      });

      test('should deserialize from JSON correctly', () {
        // Act
        final campsiteModel = CampsiteModel.fromJson(testJsonMap);

        // Assert
        expect(campsiteModel.id, '1');
        expect(campsiteModel.label, 'Beautiful Forest Campsite');
        expect(campsiteModel.createdAt, '2024-01-15T10:30:00.000Z');
        expect(campsiteModel.isCloseToWater, true);
        expect(campsiteModel.isCampFireAllowed, false);
        expect(campsiteModel.hostLanguages, ['English', 'German']);
        expect(campsiteModel.pricePerNight, 25.50);
        expect(campsiteModel.photo, 'https://example.com/photo.jpg');
        expect(campsiteModel.suitableFor, ['Couples', 'Family']);
        expect(campsiteModel.geoLocation.latitude, 52.5200);
        expect(campsiteModel.geoLocation.longitude, 13.4050);
      });

      test('should handle round-trip serialization', () {
        // Act
        final json = testCampsiteModel.toJson();
        final deserializedModel = CampsiteModel.fromJson(json);

        // Assert
        expect(deserializedModel, equals(testCampsiteModel));
      });
    });

    group('Domain Conversion', () {
      test('should convert to domain entity correctly', () {
        // Act
        final domainCampsite = testCampsiteModel.toDomain();

        // Assert
        expect(domainCampsite, isA<Campsite>());
        expect(domainCampsite.id, '1');
        expect(domainCampsite.label, 'Beautiful Forest Campsite');
        expect(
          domainCampsite.createdAt,
          DateTime.parse('2024-01-15T10:30:00.000Z'),
        );
        expect(domainCampsite.isCloseToWater, true);
        expect(domainCampsite.isCampFireAllowed, false);
        expect(domainCampsite.hostLanguages, ['English', 'German']);
        expect(domainCampsite.pricePerNight, 25.50);
        expect(domainCampsite.photo, 'https://example.com/photo.jpg');
        expect(domainCampsite.suitableFor, ['Couples', 'Family']);
        expect(domainCampsite.geoLocation.latitude, 52.5200);
        expect(domainCampsite.geoLocation.longitude, 13.4050);
      });

      test('should create from domain entity correctly', () {
        // Arrange
        final domainCampsite = Campsite(
          id: '2',
          label: 'Mountain View Campsite',
          geoLocation: const GeoLocation(
            latitude: 47.6062,
            longitude: -122.3321,
          ),
          createdAt: DateTime.parse('2024-02-20T15:45:00.000Z'),
          isCloseToWater: false,
          isCampFireAllowed: true,
          hostLanguages: const ['Spanish', 'English'],
          pricePerNight: 40.00,
          photo: 'https://example.com/mountain.jpg',
          suitableFor: const ['Adventure', 'Hiking'],
        );

        // Act
        final model = CampsiteModel.fromDomain(domainCampsite);

        // Assert
        expect(model.id, '2');
        expect(model.label, 'Mountain View Campsite');
        expect(model.createdAt, '2024-02-20T15:45:00.000Z');
        expect(model.isCloseToWater, false);
        expect(model.isCampFireAllowed, true);
        expect(model.hostLanguages, ['Spanish', 'English']);
        expect(model.pricePerNight, 40.00);
        expect(model.photo, 'https://example.com/mountain.jpg');
        expect(model.suitableFor, ['Adventure', 'Hiking']);
        expect(model.geoLocation.latitude, 47.6062);
        expect(model.geoLocation.longitude, -122.3321);
      });

      test('should handle round-trip domain conversion', () {
        // Act
        final domainCampsite = testCampsiteModel.toDomain();
        final modelFromDomain = CampsiteModel.fromDomain(domainCampsite);

        // Assert
        expect(modelFromDomain, equals(testCampsiteModel));
      });
    });

    group('Edge Cases', () {
      test('should handle zero price', () {
        // Arrange
        final campsiteWithZeroPrice = testCampsiteModel.copyWith(
          pricePerNight: 0.0,
        );

        // Act
        final json = campsiteWithZeroPrice.toJson();
        final deserializedModel = CampsiteModel.fromJson(json);

        // Assert
        expect(deserializedModel.pricePerNight, 0.0);
      });

      test('should handle special characters in label', () {
        // Arrange
        final campsiteWithSpecialChars = testCampsiteModel.copyWith(
          label: 'Château de Camping & Überraschung',
        );

        // Act
        final json = campsiteWithSpecialChars.toJson();
        final deserializedModel = CampsiteModel.fromJson(json);

        // Assert
        expect(deserializedModel.label, 'Château de Camping & Überraschung');
      });

      test('should handle extreme coordinates', () {
        // Arrange
        const extremeCoords = GeoLocationModel(
          latitude: -90.0,
          longitude: 180.0,
        );
        final campsiteWithExtremeCoords = testCampsiteModel.copyWith(
          geoLocation: extremeCoords,
        );

        // Act
        final json = campsiteWithExtremeCoords.toJson();
        final deserializedModel = CampsiteModel.fromJson(json);

        // Assert
        expect(deserializedModel.geoLocation.latitude, -90.0);
        expect(deserializedModel.geoLocation.longitude, 180.0);
      });

      test('should handle empty lists', () {
        // Arrange
        final campsiteWithEmptyLists = testCampsiteModel.copyWith(
          hostLanguages: [],
          suitableFor: [],
        );

        // Act
        final json = campsiteWithEmptyLists.toJson();
        final deserializedModel = CampsiteModel.fromJson(json);

        // Assert
        expect(deserializedModel.hostLanguages, isEmpty);
        expect(deserializedModel.suitableFor, isEmpty);
      });

      test('should handle single item lists', () {
        // Arrange
        final campsiteWithSingleItems = testCampsiteModel.copyWith(
          hostLanguages: ['English'],
          suitableFor: ['Solo'],
        );

        // Act
        final json = campsiteWithSingleItems.toJson();
        final deserializedModel = CampsiteModel.fromJson(json);

        // Assert
        expect(deserializedModel.hostLanguages, ['English']);
        expect(deserializedModel.suitableFor, ['Solo']);
      });
    });
  });
}
