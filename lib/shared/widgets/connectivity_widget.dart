import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../constants/dimensions.dart';
import '../theme/text_styles.dart';

/// A widget that displays connectivity status and handles offline states
class ConnectivityWidget extends StatelessWidget {
  final Widget child;
  final bool isConnected;
  final VoidCallback? onRetry;

  const ConnectivityWidget({
    super.key,
    required this.child,
    this.isConnected = true,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isConnected) _buildOfflineBanner(),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingM,
        vertical: Dimensions.paddingS,
      ),
      color: AppColors.warning,
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: AppColors.surfaceWhite, size: 20),
          const SizedBox(width: Dimensions.spaceS),
          Expanded(
            child: Text(
              'No internet connection',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.surfaceWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: Dimensions.spaceS),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.surfaceWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingS,
                  vertical: Dimensions.paddingXS,
                ),
              ),
              child: Text(
                'Retry',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.surfaceWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A widget that displays loading state with optional message
class StateLoadingWidget extends StatelessWidget {
  final String message;
  final bool showProgress;

  const StateLoadingWidget({
    super.key,
    this.message = 'Loading...',
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showProgress) ...[
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
            const SizedBox(height: Dimensions.spaceL),
          ],
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// A widget that displays success state with message and optional action
class StateSuccessWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const StateSuccessWidget({
    super.key,
    required this.message,
    this.icon = Icons.check_circle,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 64, color: AppColors.success),
            const SizedBox(height: Dimensions.spaceL),
          ],
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: Dimensions.spaceL),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: AppColors.surfaceWhite,
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

/// A widget that handles multiple states (loading, error, success, empty)
class MultiStateWidget extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final bool isEmpty;
  final String? loadingMessage;
  final String? emptyMessage;
  final VoidCallback? onRetry;
  final Widget child;

  const MultiStateWidget({
    super.key,
    this.isLoading = false,
    this.errorMessage,
    this.isEmpty = false,
    this.loadingMessage,
    this.emptyMessage,
    this.onRetry,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return StateLoadingWidget(message: loadingMessage ?? 'Loading...');
    }

    if (errorMessage != null) {
      return Center(
        child: AppErrorWidget(message: errorMessage!, onRetry: onRetry),
      );
    }

    if (isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: Dimensions.spaceL),
            Text(
              emptyMessage ?? 'No data available',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return child;
  }
}

/// Enhanced error widget that matches app design
class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 64, color: AppColors.error),
            const SizedBox(height: Dimensions.spaceL),
          ],
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: Dimensions.spaceL),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: AppColors.surfaceWhite,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
