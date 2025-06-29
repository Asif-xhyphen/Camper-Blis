import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../constants/dimensions.dart';
import '../constants/strings.dart';

/// Loading widget with customizable size and appearance
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.size = Dimensions.loadingIndicatorSize,
    this.color,
    this.message,
  });

  final double size;
  final Color? color;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: size,
          width: size,
          child: CircularProgressIndicator(
            color: color ?? AppColors.primary,
            strokeWidth: 3,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: Dimensions.spaceM),
          Text(
            message!,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Small loading widget for cards and compact spaces
class LoadingWidgetSmall extends StatelessWidget {
  const LoadingWidgetSmall({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        color: color ?? AppColors.primary,
        strokeWidth: 2,
      ),
    );
  }
}

/// Large loading widget for full screen loading states
class LoadingWidgetLarge extends StatelessWidget {
  const LoadingWidgetLarge({
    super.key,
    this.message = 'Loading...',
    this.color,
  });

  final String message;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: Dimensions.loadingIndicatorSizeLarge,
            width: Dimensions.loadingIndicatorSizeLarge,
            child: CircularProgressIndicator(
              color: color ?? AppColors.primary,
              strokeWidth: 4,
            ),
          ),
          const SizedBox(height: Dimensions.spaceL),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Loading widget with custom indicator for specific states
class LoadingWidgetWithIcon extends StatelessWidget {
  const LoadingWidgetWithIcon({
    super.key,
    required this.icon,
    this.message = 'Loading...',
    this.color,
  });

  final IconData icon;
  final String message;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: color ?? AppColors.primary),
          const SizedBox(height: Dimensions.spaceM),
          SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: color ?? AppColors.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: Dimensions.spaceM),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// App-wide loading widget following design specification
class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key, this.message, this.showLogo = false});

  final String? message;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLogo) ...[
            // App logo or icon would go here
            const Icon(Icons.landscape, size: 48, color: AppColors.primary),
            const SizedBox(height: Dimensions.spaceL),
          ],
          const LoadingWidget(),
          if (message != null) ...[
            const SizedBox(height: Dimensions.spaceM),
            Text(
              message!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading overlay that can be shown over content
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingMessage;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: AppColors.overlay.withOpacity(0.3),
            child: LoadingWidget(message: loadingMessage ?? Strings.loading),
          ),
      ],
    );
  }
}

/// Loading list item for skeleton loading
class LoadingListItem extends StatelessWidget {
  const LoadingListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: Dimensions.marginM,
        vertical: Dimensions.marginS,
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingM),
        child: Row(
          children: [
            // Image placeholder
            Container(
              width: Dimensions.thumbnailSize,
              height: Dimensions.thumbnailSize,
              decoration: BoxDecoration(
                color: AppColors.surfaceGrey,
                borderRadius: BorderRadius.circular(Dimensions.radiusS),
              ),
            ),
            const SizedBox(width: Dimensions.spaceM),
            // Content placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGrey,
                      borderRadius: BorderRadius.circular(Dimensions.radiusXS),
                    ),
                  ),
                  const SizedBox(height: Dimensions.spaceS),
                  Container(
                    width: 150,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGrey,
                      borderRadius: BorderRadius.circular(Dimensions.radiusXS),
                    ),
                  ),
                  const SizedBox(height: Dimensions.spaceS),
                  Container(
                    width: 100,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGrey,
                      borderRadius: BorderRadius.circular(Dimensions.radiusXS),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer effect for loading placeholders
class ShimmerWidget extends StatefulWidget {
  final Widget child;

  const ShimmerWidget({super.key, required this.child});

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Colors.transparent,
                Colors.white54,
                Colors.transparent,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Loading grid for campsite cards
class LoadingGrid extends StatelessWidget {
  final int itemCount;

  const LoadingGrid({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(Dimensions.paddingM),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Dimensions.spaceM,
        mainAxisSpacing: Dimensions.spaceM,
        childAspectRatio: 0.8,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ShimmerWidget(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceGrey,
              borderRadius: BorderRadius.circular(Dimensions.radiusM),
            ),
          ),
        );
      },
    );
  }
}
