import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/campsite.dart';
import '../../../../shared/widgets/cached_image_widget.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/constants/dimensions.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/responsive_layout.dart';

class HorizontalCampsiteCard extends StatelessWidget {
  final Campsite campsite;
  final VoidCallback? onTap;
  final bool isGridView;
  final bool isSelected;

  const HorizontalCampsiteCard({
    super.key,
    required this.campsite,
    this.onTap,
    this.isGridView = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: Dimensions.marginM),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusM),
        border:
            isSelected
                ? Border.all(color: AppColors.primaryGreen, width: 2)
                : null,
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation:
            0, // Remove default elevation since we're using custom shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusM),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Dimensions.radiusM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image section
              _buildImageSection(),

              // Content section
              Expanded(flex: isGridView ? 1 : 0, child: _buildContentSection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    final imageHeight = isGridView ? 60.0 : Dimensions.cardImageHeight;

    return SizedBox(
      height: imageHeight,
      width: 200,
      child: CachedNetworkImage(
        imageUrl: campsite.photo,
        fit: BoxFit.fitWidth,
        placeholder:
            (context, url) => Container(
              color: AppColors.surface,
              child: const Center(child: LoadingWidgetSmall()),
            ),
        errorWidget:
            (context, url, error) => Container(
              color: AppColors.surface,
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 40,
                color: AppColors.textLight,
              ),
            ),
      ),
    );
  }

  Widget _buildContentSection() {
    final padding =
        isGridView
            ? const EdgeInsets.all(Dimensions.paddingS)
            : const EdgeInsets.all(Dimensions.paddingM);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rating badge
          // _buildRatingBadge(),
          SizedBox(
            height: isGridView ? Dimensions.spaceXS / 2 : Dimensions.spaceXS,
          ),

          // Title
          Text(
            campsite.label,
            style:
                isGridView
                    ? AppTextStyles.headingSmall.copyWith(fontSize: 14)
                    : AppTextStyles.headingSmall,
            maxLines: isGridView ? 2 : 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(
            height: isGridView ? Dimensions.spaceXS / 2 : Dimensions.spaceXS,
          ),

          // Location info
          Text(
            campsite.hostLanguages.join(', '),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: isGridView ? 11 : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: isGridView ? Dimensions.spaceXS : Dimensions.spaceS),

          // // Amenities row (show fewer in grid view)
          // if (!isGridView) _buildAmenitiesRow(),
          // if (isGridView) _buildCompactAmenitiesRow(),
          SizedBox(height: isGridView ? Dimensions.spaceXS : Dimensions.spaceS),

          // Price
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.priceTag,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              campsite.formattedPrice,
              style: (isGridView
                      ? AppTextStyles.price.copyWith(fontSize: 14)
                      : AppTextStyles.price)
                  .copyWith(color: AppColors.primaryGreen),
            ),
          ),
        ],
      ),
    );
  }
}

/// Accommodation card following the design specification
class CampsiteCard extends StatelessWidget {
  final Campsite campsite;
  final VoidCallback? onTap;
  final bool isGridView;

  const CampsiteCard({
    super.key,
    required this.campsite,
    this.onTap,
    this.isGridView = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardMargin =
        isGridView
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(
              horizontal: Dimensions.marginM,
              vertical: Dimensions.marginS,
            );

    return Card(
      margin: cardMargin,
      elevation: Dimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusM),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.radiusM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image section
            _buildImageSection(),

            // Content section
            Expanded(flex: isGridView ? 1 : 0, child: _buildContentSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    final imageHeight = isGridView ? 160.0 : Dimensions.cardImageHeight;

    return SizedBox(
      height: imageHeight,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: campsite.photo,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => Container(
              color: AppColors.surface,
              child: const Center(child: LoadingWidgetSmall()),
            ),
        errorWidget:
            (context, url, error) => Container(
              color: AppColors.surface,
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 40,
                color: AppColors.textLight,
              ),
            ),
      ),
    );
  }

  Widget _buildContentSection() {
    final padding =
        isGridView
            ? const EdgeInsets.all(Dimensions.paddingS)
            : const EdgeInsets.all(Dimensions.paddingM);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rating badge
          _buildRatingBadge(),

          SizedBox(
            height: isGridView ? Dimensions.spaceXS / 2 : Dimensions.spaceXS,
          ),

          // Title
          Text(
            campsite.label,
            style:
                isGridView
                    ? AppTextStyles.headingSmall.copyWith(fontSize: 14)
                    : AppTextStyles.headingSmall,
            maxLines: isGridView ? 2 : 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(
            height: isGridView ? Dimensions.spaceXS / 2 : Dimensions.spaceXS,
          ),

          // Location info
          Text(
            campsite.hostLanguages.join(', '),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: isGridView ? 11 : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: isGridView ? Dimensions.spaceXS : Dimensions.spaceS),

          // Amenities row (show fewer in grid view)
          if (!isGridView) _buildAmenitiesRow(),
          if (isGridView) _buildCompactAmenitiesRow(),

          SizedBox(height: isGridView ? Dimensions.spaceXS : Dimensions.spaceS),

          // Price
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.priceTag,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              campsite.formattedPrice,
              style: (isGridView
                      ? AppTextStyles.price.copyWith(fontSize: 14)
                      : AppTextStyles.price)
                  .copyWith(color: AppColors.primaryGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge() {
    // Mock rating for now - in real app this would come from reviews
    const rating = 4.8;
    const reviewCount = 123;

    return Row(
      children: [
        Icon(
          Icons.star,
          size: Dimensions.starSizeSmall,
          color: AppColors.warning,
        ),
        const SizedBox(width: Dimensions.spaceXS),
        Text(
          '$rating ($reviewCount)',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAmenitiesRow() {
    final amenities = <Widget>[];

    if (campsite.isCloseToWater) {
      amenities.add(_buildAmenityChip(icon: Icons.water, label: 'Waterfront'));
    }

    if (campsite.isCampFireAllowed) {
      amenities.add(
        _buildAmenityChip(icon: Icons.local_fire_department, label: 'Campfire'),
      );
    }

    // Add language chip
    amenities.add(
      _buildAmenityChip(
        icon: Icons.language,
        label: campsite.hostLanguages.join(', '),
      ),
    );

    return Wrap(
      spacing: Dimensions.spaceS,
      runSpacing: Dimensions.spaceXS,
      children: amenities,
    );
  }

  Widget _buildCompactAmenitiesRow() {
    final amenities = <Widget>[];

    // Show only most important amenities in grid view
    if (campsite.isCloseToWater) {
      amenities.add(_buildCompactAmenityChip(icon: Icons.water));
    }

    if (campsite.isCampFireAllowed) {
      amenities.add(
        _buildCompactAmenityChip(icon: Icons.local_fire_department),
      );
    }

    // Limit to 2-3 amenities in grid view
    return Row(children: amenities.take(3).toList());
  }

  Widget _buildAmenityChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingS,
        vertical: Dimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Dimensions.radiusS),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: Dimensions.spaceXS),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactAmenityChip({required IconData icon}) {
    return Container(
      margin: const EdgeInsets.only(right: Dimensions.spaceXS),
      padding: const EdgeInsets.all(Dimensions.paddingXS),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Dimensions.radiusS),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Icon(icon, size: 12, color: AppColors.textSecondary),
    );
  }
}

/// Compact campsite card for maps and horizontal scrolling
class CompactCampsiteCard extends StatelessWidget {
  final Campsite campsite;
  final VoidCallback? onTap;

  const CompactCampsiteCard({super.key, required this.campsite, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.campsiteCardWidth,
      margin: const EdgeInsets.only(right: Dimensions.marginM),
      child: Card(
        elevation: Dimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusM),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Dimensions.radiusM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              SizedBox(
                height: Dimensions.campsiteCardImageHeight,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: campsite.photo,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color: AppColors.surface,
                        child: const Center(child: LoadingWidgetSmall()),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color: AppColors.surface,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 32,
                          color: AppColors.textLight,
                        ),
                      ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingS),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campsite.label,
                      style: AppTextStyles.headingSmall.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Dimensions.spaceXS),
                    Text(
                      campsite.hostLanguages.join(', '),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Dimensions.spaceXS),
                    Text(
                      campsite.formattedPrice,
                      style: AppTextStyles.price.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cached image widget with consistent error handling
class CachedImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CachedImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder:
          (context, url) => Container(
            width: width,
            height: height,
            color: AppColors.surface,
            child: const Center(child: LoadingWidgetSmall()),
          ),
      errorWidget:
          (context, url, error) => Container(
            width: width,
            height: height,
            color: AppColors.surface,
            child: Icon(
              Icons.image_not_supported_outlined,
              size: 40,
              color: AppColors.textLight,
            ),
          ),
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }
}
