import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/colors.dart';
import '../constants/dimensions.dart';

/// Cached network image widget with loading and error states
class CachedImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final Duration fadeInDuration;
  final String? cacheKey;

  const CachedImageWidget({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.cacheKey,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorWidget();
    }

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration,
      cacheKey: cacheKey,
      placeholder: (context, url) => placeholder ?? _buildPlaceholder(),
      errorWidget: (context, url, error) => errorWidget ?? _buildErrorWidget(),
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceGrey,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceGrey,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.textLight,
            size: Dimensions.spaceL,
          ),
          SizedBox(height: Dimensions.spaceS),
          Text(
            'Image not available',
            style: TextStyle(color: AppColors.textLight, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Campsite image widget with specific styling
class CampsiteImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final String? heroTag;

  const CampsiteImageWidget({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedImageWidget(
      imageUrl: imageUrl,
      width: width,
      height: height ?? Dimensions.cardImageHeightLarge,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(Dimensions.radiusS),
    );

    if (heroTag != null) {
      imageWidget = Hero(tag: heroTag!, child: imageWidget);
    }

    return imageWidget;
  }
}

/// Avatar image widget for user profiles
class AvatarImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String? initials;
  final Color? backgroundColor;

  const AvatarImageWidget({
    super.key,
    this.imageUrl,
    this.size = Dimensions.avatarSize,
    this.initials,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedImageWidget(
        imageUrl: imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(size / 2),
        errorWidget: _buildFallbackAvatar(),
      );
    }

    return _buildFallbackAvatar();
  }

  Widget _buildFallbackAvatar() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryGreenLight,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials ?? '?',
          style: TextStyle(
            color: AppColors.textOnPrimary,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Thumbnail image widget for grid layouts
class ThumbnailImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;

  const ThumbnailImageWidget({
    super.key,
    this.imageUrl,
    this.size = Dimensions.thumbnailSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedImageWidget(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(Dimensions.radiusS),
    );

    if (onTap != null) {
      imageWidget = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.radiusS),
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

/// Gallery image widget with zoom capability
class GalleryImageWidget extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final VoidCallback? onTap;

  const GalleryImageWidget({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: heroTag,
        child: CachedImageWidget(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          width: double.infinity,
        ),
      ),
    );
  }
}

/// Progressive image widget with fade-in animation
class ProgressiveImageWidget extends StatelessWidget {
  final String? thumbnailUrl;
  final String? fullImageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ProgressiveImageWidget({
    super.key,
    this.thumbnailUrl,
    this.fullImageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (fullImageUrl == null || fullImageUrl!.isEmpty) {
      return CachedImageWidget(
        imageUrl: thumbnailUrl,
        width: width,
        height: height,
        fit: fit,
      );
    }

    return Stack(
      children: [
        // Thumbnail as background
        if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
          CachedImageWidget(
            imageUrl: thumbnailUrl,
            width: width,
            height: height,
            fit: fit,
          ),
        // Full image on top
        CachedImageWidget(
          imageUrl: fullImageUrl,
          width: width,
          height: height,
          fit: fit,
          fadeInDuration: const Duration(milliseconds: 500),
        ),
      ],
    );
  }
}
