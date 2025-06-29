import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/utils/coordinate_utils.dart';
import '../../models/campsite_model.dart';
import '../../models/geo_location_model.dart';

/// Remote data source for campsite-related API operations
abstract class CampsiteRemoteDataSource {
  /// Fetch all campsites from the API
  Future<Either<Failure, List<CampsiteModel>>> getCampsites();

  /// Fetch a specific campsite by ID
  Future<Either<Failure, CampsiteModel>> getCampsiteById(String id);
}

/// Implementation of [CampsiteRemoteDataSource] using Dio HTTP client
class CampsiteRemoteDataSourceImpl implements CampsiteRemoteDataSource {
  final DioClient _dioClient;

  const CampsiteRemoteDataSourceImpl(this._dioClient);

  @override
  Future<Either<Failure, List<CampsiteModel>>> getCampsites() async {
    try {
      final Response response = await _dioClient.get(ApiConstants.campsites);

      if (response.statusCode == ApiConstants.successCode) {
        final List<dynamic> data = response.data as List<dynamic>;

        // Parse and validate each campsite
        final List<CampsiteModel> campsites =
            data
                .map(
                  (json) =>
                      _parseCampsiteFromJson(json as Map<String, dynamic>),
                )
                .where((campsite) => campsite != null)
                .cast<CampsiteModel>()
                .toList();

        return Right(campsites);
      } else {
        return Left(
          ServerFailure(
            'Failed to fetch campsites',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CampsiteModel>> getCampsiteById(String id) async {
    try {
      final Response response = await _dioClient.get(
        '${ApiConstants.campsites}/$id',
      );

      if (response.statusCode == ApiConstants.successCode) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;

        final CampsiteModel? campsite = _parseCampsiteFromJson(data);

        if (campsite != null) {
          return Right(campsite);
        } else {
          return const Left(
            ValidationFailure('Invalid campsite data received'),
          );
        }
      } else {
        return Left(
          ServerFailure(
            'Failed to fetch campsite',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }

  CampsiteModel _parseCampsiteFromJson(Map<String, dynamic> json) {
    // Validate required fields
    final String? id = json['id'] as String?;
    final String? label = json['label'] as String?;
    final String? photo = json['photo'] as String?;
    final String? createdAt = json['createdAt'] as String?;
    final Map<String, dynamic>? geoLocationMap =
        json['geoLocation'] as Map<String, dynamic>?;
    final List<dynamic>? hostLanguagesList =
        json['hostLanguages'] as List<dynamic>?;
    final List<dynamic>? suitableForList =
        json['suitableFor'] as List<dynamic>?;

    // Validate required fields
    if (id == null ||
        id.isEmpty ||
        label == null ||
        label.isEmpty ||
        photo == null ||
        photo.isEmpty ||
        createdAt == null ||
        createdAt.isEmpty ||
        geoLocationMap == null ||
        hostLanguagesList == null) {
      throw FormatException('Invalid campsite data: missing required fields');
    }

    final double? pricePerNight = (json['pricePerNight'] as num?)?.toDouble();
    final bool isCloseToWater = json['isCloseToWater'] as bool? ?? false;
    final bool isCampFireAllowed = json['isCampFireAllowed'] as bool? ?? false;

    if (pricePerNight == null) {
      throw FormatException(
        'Invalid campsite data: missing or invalid pricePerNight',
      );
    }

    // Parse geo location - using hardcoded coordinates since API data is incorrect
    final Map<String, double> coordinates =
        CoordinateUtils.getHardcodedCoordinatesForCampsite(id);

    final double lat = coordinates['latitude']!;
    final double long = coordinates['longitude']!;

    final GeoLocationModel geoLocation = GeoLocationModel(
      latitude: lat,
      longitude: long,
    );

    // Parse host languages
    final List<String> hostLanguages =
        hostLanguagesList.map((lang) => lang.toString()).toList();

    // Parse suitable for (can be empty)
    final List<String> suitableFor =
        (suitableForList ?? []).map((item) => item.toString()).toList();

    return CampsiteModel(
      id: id,
      label: label,
      photo: photo,
      createdAt: createdAt,
      geoLocation: geoLocation,
      pricePerNight: pricePerNight,
      isCloseToWater: isCloseToWater,
      isCampFireAllowed: isCampFireAllowed,
      hostLanguages: hostLanguages,
      suitableFor: suitableFor,
    );
  }

  /// Handle Dio exceptions and convert to appropriate Failure
  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final message = _getErrorMessageForStatusCode(statusCode);
        return ServerFailure(message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return const NetworkFailure('Request was cancelled');

      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection');

      case DioExceptionType.badCertificate:
        return const NetworkFailure('Bad certificate');

      case DioExceptionType.unknown:
        return NetworkFailure(e.message ?? 'Unknown network error');
    }
  }

  /// Get error message based on HTTP status code
  String _getErrorMessageForStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Campsites not found';
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      case 503:
        return 'Service unavailable';
      default:
        return 'Server error (${statusCode})';
    }
  }
}
