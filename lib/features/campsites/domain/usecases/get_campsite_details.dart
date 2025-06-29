import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/campsite.dart';
import '../repositories/campsite_repository.dart';

/// Use case for retrieving detailed information about a specific campsite
/// Implements the business logic for getting campsite details with caching strategy
class GetCampsiteDetails {
  final CampsiteRepository _repository;

  const GetCampsiteDetails(this._repository);

  /// Execute the use case to get campsite details by ID
  ///
  /// This use case implements the following business logic:
  /// 1. Validate the campsite ID
  /// 2. Try to get from cache first for performance
  /// 3. If not found locally, fetch from remote API
  /// 4. Handle all error scenarios appropriately
  Future<Either<Failure, Campsite>> call(String campsiteId) async {
    try {
      // Validate input
      if (campsiteId.isEmpty) {
        return const Left(ValidationFailure('Campsite ID cannot be empty'));
      }

      // Get campsite by ID (repository handles cache vs remote logic)
      final result = await _repository.getCampsiteById(campsiteId);

      return result.fold((failure) => Left(failure), (campsite) {
        // Additional business logic can be added here
        // For example, logging view events, updating last viewed timestamp, etc.
        return Right(campsite);
      });
    } catch (e) {
      return Left(
        GeneralFailure('Failed to get campsite details: ${e.toString()}'),
      );
    }
  }

  /// Get related campsites based on various criteria
  /// This can be used for "similar campsites" or "nearby campsites" features
  Future<Either<Failure, List<Campsite>>> getRelatedCampsites(
    String campsiteId, {
    int maxResults = 5,
  }) async {
    try {
      // First get the target campsite
      final campsiteResult = await call(campsiteId);

      return campsiteResult.fold((failure) => Left(failure), (
        targetCampsite,
      ) async {
        // Get all campsites
        final allCampsitesResult = await _repository.getCampsites();

        return allCampsitesResult.fold((failure) => Left(failure), (
          allCampsites,
        ) {
          // Filter out the target campsite itself
          final otherCampsites =
              allCampsites.where((c) => c.id != campsiteId).toList();

          // Score and sort campsites by similarity
          final scoredCampsites =
              otherCampsites.map((campsite) {
                final score = _calculateSimilarityScore(
                  targetCampsite,
                  campsite,
                );
                return ScoredCampsite(campsite, score);
              }).toList();

          // Sort by score (highest first) and take maxResults
          scoredCampsites.sort((a, b) => b.score.compareTo(a.score));

          final relatedCampsites =
              scoredCampsites
                  .take(maxResults)
                  .map((scored) => scored.campsite)
                  .toList();

          return Right(relatedCampsites);
        });
      });
    } catch (e) {
      return Left(
        GeneralFailure('Failed to get related campsites: ${e.toString()}'),
      );
    }
  }

  /// Calculate similarity score between two campsites
  /// This is a simple algorithm that can be enhanced based on business requirements
  double _calculateSimilarityScore(Campsite target, Campsite candidate) {
    double score = 0.0;

    // Similar amenities
    if (target.isCloseToWater == candidate.isCloseToWater) score += 1.0;
    if (target.isCampFireAllowed == candidate.isCampFireAllowed) score += 1.0;

    // Common host languages
    if (target.hostLanguages.any(
      (lang) => candidate.hostLanguages.contains(lang),
    )) {
      score += 1.0;
    }

    // Similar price range (within 20% gets partial score)
    final priceDifference =
        (target.pricePerNight - candidate.pricePerNight).abs();
    final priceRatio = priceDifference / target.pricePerNight;
    if (priceRatio <= 0.2)
      score += 2.0 - (priceRatio * 5); // Score decreases with price difference

    // Geographic proximity could be added here using coordinates
    // For now, we'll skip this as it would require more complex calculations

    return score;
  }

  /// Validate campsite data quality
  bool _validateCampsiteData(Campsite campsite) {
    // Basic validation checks
    if (campsite.label.isEmpty || campsite.id.isEmpty) return false;

    // Validate host languages
    if (campsite.hostLanguages.isEmpty) return false;

    // Validate features consistency
    if (campsite.isCloseToWater && campsite.isCampFireAllowed) {
      // Both features can coexist, this is valid
    }

    if (campsite.pricePerNight <= 0) return false;

    return true;
  }

  /// Generate additional metadata for campsite
  Map<String, dynamic> _generateMetadata(Campsite campsite) {
    return {
      'hasWaterAccess': campsite.isCloseToWater,
      'allowsCampfire': campsite.isCampFireAllowed,
      'primaryLanguage': campsite.primaryHostLanguage,
      'languageCount': campsite.hostLanguages.length,
      'priceCategory': _getPriceCategory(campsite.pricePerNight),
      'featuresCount': _countFeatures(campsite),
      'suitableForCount': campsite.suitableFor.length,
    };
  }

  /// Categorize price range
  String _getPriceCategory(double price) {
    if (price < 50) return 'Budget';
    if (price < 100) return 'Mid-range';
    return 'Premium';
  }

  /// Count features available at campsite
  int _countFeatures(Campsite campsite) {
    int count = 0;
    if (campsite.isCloseToWater) count++;
    if (campsite.isCampFireAllowed) count++;
    return count;
  }
}

/// Helper class to associate campsites with similarity scores
class ScoredCampsite {
  final Campsite campsite;
  final double score;

  const ScoredCampsite(this.campsite, this.score);
}
