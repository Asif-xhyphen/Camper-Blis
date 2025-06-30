import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/campsite.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/widgets/responsive_layout.dart';

enum CampsiteCardLayout { horizontal, vertical, featured, grid }

class CampsiteCardUnified extends ConsumerWidget {
  const CampsiteCardUnified({
    super.key,
    required this.campsite,
    required this.onTap,
    this.layout = CampsiteCardLayout.vertical,
    this.width,
    this.height,
  });

  final dynamic campsite; // TODO: Replace with proper Campsite entity
  final VoidCallback onTap;
  final CampsiteCardLayout layout;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (layout) {
      case CampsiteCardLayout.horizontal:
        return _buildHorizontalCard();
      case CampsiteCardLayout.featured:
        return _buildFeaturedCard();
      case CampsiteCardLayout.grid:
        return _buildGridCard();
      case CampsiteCardLayout.vertical:
      default:
        return _buildVerticalCard();
    }
  }

  Widget _buildHorizontalCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildCardImage(80, 80, BorderRadius.circular(12)),
            const SizedBox(width: 16),
            Expanded(child: _buildCardContent()),
            _buildPriceAndRating(isVertical: false),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height ?? 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildFullImageBackground(),
              _buildFavoriteButton(),
              _buildBottomOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  _buildCardImage(
                    double.infinity,
                    double.infinity,
                    const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  _buildPriceTag(),
                  _buildFavoriteButton(),
                  _buildRatingBadge(),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCardContent(),
                    const Spacer(),
                    _buildFeatureBadges(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildFullImageBackground(),
              _buildFavoriteButton(),
              _buildBottomOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardImage(
    double width,
    double height,
    BorderRadius borderRadius,
  ) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        campsite.photo.replaceFirst('http://', 'https://'),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: AppColors.border,
            child: Icon(
              Icons.image_not_supported,
              color: AppColors.textSecondary,
              size: width < 100 ? 24 : 48,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFullImageBackground() {
    return Positioned.fill(
      child: Image.network(
        campsite.photo.replaceFirst('http://', 'https://'),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.border,
            child: Icon(
              Icons.image_not_supported,
              color: AppColors.textSecondary,
              size: 48,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          campsite.label,
          style: AppTextStyles.headingSmall.copyWith(fontSize: 16),
          maxLines: layout == CampsiteCardLayout.horizontal ? 1 : 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (layout == CampsiteCardLayout.horizontal) ...[
          const SizedBox(height: 4),
          Text(
            campsite.briefDescription,
            style: AppTextStyles.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ] else if (layout == CampsiteCardLayout.featured) ...[
          const SizedBox(height: 8),
          Text(
            campsite.briefDescription,
            style: AppTextStyles.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildBottomOverlay() {
    return Positioned(
      left: 8,
      right: 8,
      bottom: 8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      campsite.label,
                      style: AppTextStyles.headingMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    campsite.formattedPrice,
                    style: AppTextStyles.headingMedium.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'National Park',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: AppColors.primary, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '4.9',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(2.8k)',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceAndRating({required bool isVertical}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            campsite.formattedPrice,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (!isVertical) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                '4.8',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(Icons.favorite_border, size: 20, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildPriceTag() {
    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          campsite.formattedPrice,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 14),
            const SizedBox(width: 4),
            Text(
              '4.8',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureBadges() {
    return Row(
      children: [
        if (campsite.isCloseToWater)
          _buildFeatureBadge('Water', Icons.water_drop, AppColors.primary),
        if (campsite.isCloseToWater && campsite.isCampFireAllowed)
          const SizedBox(width: 8),
        if (campsite.isCampFireAllowed)
          _buildFeatureBadge(
            'Fire',
            Icons.local_fire_department,
            Colors.orange,
          ),
      ],
    );
  }

  Widget _buildFeatureBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
