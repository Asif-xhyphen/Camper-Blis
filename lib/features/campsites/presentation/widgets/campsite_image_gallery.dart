import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../shared/widgets/cached_image_widget.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/constants/dimensions.dart';

class CampsiteImageGallery extends StatefulWidget {
  const CampsiteImageGallery({
    super.key,
    required this.images,
    this.initialIndex = 0,
    this.height = 300,
    this.showIndicators = true,
    this.showCounter = true,
    this.allowZoom = false,
  });

  final List<String> images;
  final int initialIndex;
  final double height;
  final bool showIndicators;
  final bool showCounter;
  final bool allowZoom;

  @override
  State<CampsiteImageGallery> createState() => _CampsiteImageGalleryState();
}

class _CampsiteImageGalleryState extends State<CampsiteImageGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      height: widget.height,
      child: Stack(
        children: [
          // Image PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return _buildImage(widget.images[index], index);
            },
          ),

          // Navigation arrows (for multiple images)
          if (widget.images.length > 1) ...[
            _buildNavigationArrow(
              alignment: Alignment.centerLeft,
              icon: Icons.chevron_left,
              onTap: _previousImage,
            ),
            _buildNavigationArrow(
              alignment: Alignment.centerRight,
              icon: Icons.chevron_right,
              onTap: _nextImage,
            ),
          ],

          // Page indicators
          if (widget.showIndicators && widget.images.length > 1)
            Positioned(
              bottom: Dimensions.paddingM,
              left: 0,
              right: 0,
              child: _buildPageIndicators(),
            ),

          // Image counter
          if (widget.showCounter && widget.images.length > 1)
            Positioned(
              top: Dimensions.paddingM,
              right: Dimensions.paddingM,
              child: _buildImageCounter(),
            ),

          // Zoom button
          if (widget.allowZoom)
            Positioned(
              top: Dimensions.paddingM,
              left: Dimensions.paddingM,
              child: _buildZoomButton(),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl, int index) {
    return GestureDetector(
      onTap: widget.allowZoom ? () => _showFullScreenImage(index) : null,
      child: CachedImageWidget(
        imageUrl: imageUrl,
        width: double.infinity,
        height: widget.height,
        fit: BoxFit.cover,
        placeholder: Container(
          color: AppColors.surfaceGrey,
          child: const Center(
            child: Icon(Icons.image, size: 64, color: AppColors.textSecondary),
          ),
        ),
        errorWidget: Container(
          color: AppColors.surfaceGrey,
          child: const Center(
            child: Icon(
              Icons.broken_image,
              size: 64,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: widget.height,
      color: AppColors.surfaceGrey,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: Dimensions.spaceS),
            Text(
              'No images available',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationArrow({
    required AlignmentGeometry alignment,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Container(
          margin: const EdgeInsets.all(Dimensions.paddingS),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onTap,
            icon: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          widget.images.asMap().entries.map((entry) {
            final index = entry.key;
            final isActive = index == _currentIndex;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildImageCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingS,
        vertical: Dimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(Dimensions.radiusS),
      ),
      child: Text(
        '${_currentIndex + 1} / ${widget.images.length}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildZoomButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () => _showFullScreenImage(_currentIndex),
        icon: const Icon(Icons.zoom_in, color: Colors.white, size: 20),
      ),
    );
  }

  void _previousImage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextImage() {
    if (_currentIndex < widget.images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showFullScreenImage(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => FullScreenImageGallery(
              images: widget.images,
              initialIndex: index,
            ),
        fullscreenDialog: true,
      ),
    );
  }
}

/// Full-screen image gallery for detailed viewing
class FullScreenImageGallery extends StatefulWidget {
  const FullScreenImageGallery({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  final List<String> images;
  final int initialIndex;

  @override
  State<FullScreenImageGallery> createState() => _FullScreenImageGalleryState();
}

class _FullScreenImageGalleryState extends State<FullScreenImageGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        title: Text(
          '${_currentIndex + 1} of ${widget.images.length}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            minScale: 0.5,
            maxScale: 3.0,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: widget.images[index],
                fit: BoxFit.contain,
                placeholder:
                    (context, url) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                errorWidget:
                    (context, url, error) => const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 64,
                        color: Colors.white54,
                      ),
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Single image display widget for campsite detail views
class CampsiteImageDisplay extends StatelessWidget {
  const CampsiteImageDisplay({
    super.key,
    required this.imageUrl,
    this.height = 250,
    this.borderRadius,
    this.onTap,
  });

  final String imageUrl;
  final double height;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: CachedImageWidget(
          imageUrl: imageUrl,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: Container(
            height: height,
            color: AppColors.surfaceGrey,
            child: const Center(
              child: Icon(
                Icons.image,
                size: 48,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          errorWidget: Container(
            height: height,
            color: AppColors.surfaceGrey,
            child: const Center(
              child: Icon(
                Icons.broken_image,
                size: 48,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
