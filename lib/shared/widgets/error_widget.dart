import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../constants/dimensions.dart';
import '../constants/strings.dart';

class AppErrorWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? retryButtonText;

  const AppErrorWidget({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.icon,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: Dimensions.iconL,
              color: AppColors.error,
            ),
            const SizedBox(height: Dimensions.spaceL),
            if (title != null)
              Text(
                title!,
                style: AppTextStyles.headingLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            if (title != null) const SizedBox(height: Dimensions.spaceM),
            Text(
              message ?? Strings.genericError,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: Dimensions.spaceL),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(retryButtonText ?? Strings.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      title: Strings.connectionFailed,
      message: Strings.networkError,
      icon: Icons.wifi_off_outlined,
      onRetry: onRetry,
    );
  }
}

class NoDataWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRefresh;
  final IconData? icon;

  const NoDataWidget({
    super.key,
    this.title,
    this.message,
    this.onRefresh,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      title: title ?? Strings.noDataAvailable,
      message: message ?? Strings.noDataError,
      icon: icon ?? Icons.inbox_outlined,
      onRetry: onRefresh,
      retryButtonText: Strings.refresh,
    );
  }
}

class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const ServerErrorWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      title: Strings.serverError,
      message: 'Please try again later or contact support.',
      icon: Icons.error_outline,
      onRetry: onRetry,
    );
  }
}

class LocationErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const LocationErrorWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      title: Strings.locationError,
      message: 'Enable location permissions to see nearby campsites.',
      icon: Icons.location_off_outlined,
      onRetry: onRetry,
      retryButtonText: 'Enable Location',
    );
  }
}

class InlineErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const InlineErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusS),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_outlined,
            color: AppColors.error,
            size: Dimensions.iconS,
          ),
          const SizedBox(width: Dimensions.spaceS),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: Dimensions.spaceS),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingS,
                  vertical: Dimensions.paddingXS,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                Strings.retry,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.error,
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

class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.search_off_outlined,
              size: Dimensions.iconL,
              color: AppColors.textLight,
            ),
            const SizedBox(height: Dimensions.spaceL),
            if (title != null)
              Text(
                title!,
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            if (title != null) const SizedBox(height: Dimensions.spaceM),
            Text(
              message ?? Strings.noResults,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: Dimensions.spaceL),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class NoCampsitesWidget extends StatelessWidget {
  final VoidCallback? onClearFilters;
  final bool hasActiveFilters;

  const NoCampsitesWidget({
    super.key,
    this.onClearFilters,
    this.hasActiveFilters = false,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: Strings.noCampsitesFound,
      message:
          hasActiveFilters
              ? Strings.noCampsitesMessage
              : 'Start exploring amazing campsites around the world.',
      icon: Icons.nature_people_outlined,
      action:
          hasActiveFilters && onClearFilters != null
              ? OutlinedButton(
                onPressed: onClearFilters,
                child: Text(Strings.clearFilters),
              )
              : null,
    );
  }
}

class TimeoutErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const TimeoutErrorWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      title: Strings.timeoutError,
      message: 'The request took too long to complete. Please try again.',
      icon: Icons.schedule_outlined,
      onRetry: onRetry,
    );
  }
}
