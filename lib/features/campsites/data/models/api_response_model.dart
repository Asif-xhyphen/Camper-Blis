/// Simple API response wrapper for handling success and error states
/// This is a simplified version without complex generic JSON serialization
abstract class ApiResponse<T> {
  const ApiResponse();
}

/// Success response with data
class ApiResponseSuccess<T> extends ApiResponse<T> {
  final T data;
  final String? message;

  const ApiResponseSuccess({required this.data, this.message});

  bool get isSuccess => true;
  bool get isError => false;
  T? get dataOrNull => data;
  String? get errorMessage => null;
}

/// Error response with details
class ApiResponseError<T> extends ApiResponse<T> {
  final String message;
  final String? code;
  final int? statusCode;
  final dynamic details;

  const ApiResponseError({
    required this.message,
    this.code,
    this.statusCode,
    this.details,
  });

  bool get isSuccess => false;
  bool get isError => true;
  T? get dataOrNull => null;
  String? get errorMessage => message;
}

/// Simple paginated response model
class PaginatedApiResponse<T> {
  final List<T> data;
  final int total;
  final int page;
  final int pageSize;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedApiResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// Check if there are more pages
  bool get hasMoreData => hasNextPage;

  /// Get next page number
  int get nextPage => hasNextPage ? page + 1 : page;

  /// Get previous page number
  int get previousPage => hasPreviousPage ? page - 1 : page;
}
