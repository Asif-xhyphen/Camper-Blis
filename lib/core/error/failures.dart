import 'package:dartz/dartz.dart';

/// Base failure class for the Either pattern
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;

  @override
  String toString() => 'Failure: $message';
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode, super.code});

  @override
  String toString() => 'ServerFailure($statusCode): $message';
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? invalidData;

  const ValidationFailure(super.message, {this.invalidData, super.code});

  @override
  String toString() => 'ValidationFailure: $message, data: $invalidData';
}

/// General application failure
class GeneralFailure extends Failure {
  const GeneralFailure(super.message, {super.code});
}

/// Common failure messages
class FailureMessages {
  static const String networkError = 'Network connection failed';
  static const String serverError = 'Server error occurred';
  static const String cacheError = 'Cache operation failed';
  static const String databaseError = 'Database operation failed';
  static const String validationError = 'Data validation failed';
  static const String locationError = 'Location service failed';
  static const String unknownError = 'An unknown error occurred';
  static const String noDataFound = 'No data found';
  static const String invalidCoordinates = 'Invalid GPS coordinates';
}

/// Type alias for common Either return type
typedef FailureOr<T> = Either<Failure, T>;
