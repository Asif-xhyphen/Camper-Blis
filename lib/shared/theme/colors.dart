import 'package:flutter/material.dart';

/// Application color palette following the design specification
class AppColors {
  // Primary colors from design spec
  static const Color primary = Color(0xFF00C896);
  static const Color primaryDark = Color(0xFF00A67D);

  // Background colors
  static const Color background = Color(0xFFF6FBF7); // Minty green
  static const Color surface = Color(0xFFEFF7F2); // Slightly deeper mint

  // Text colors
  static const Color textPrimary = Color(0xFF1A3A2D); // Deep green
  static const Color textSecondary = Color(0xFF5B8576); // Muted green/gray
  static const Color textLight = Color(0xFFB6CFC2); // Light mint
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border and divider colors
  static const Color border = Color(0xFFD6E9DE); // Soft mint border
  static const Color divider = Color(0xFFD6E9DE);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Shadow color
  static const Color shadow = Color(0x1A000000); // rgba(0, 0, 0, 0.1)

  // Legacy color mappings for compatibility
  static const Color primaryGreen = primary;
  static const Color primaryGreenLight = Color(0xFF33D4AA);
  static const Color primaryGreenDark = primaryDark;

  static const Color backgroundWhite = background;
  static const Color backgroundGrey = surface;
  static const Color surfaceWhite = surface;
  static const Color surfaceGrey = surface;

  // Feature-specific colors
  static const Color waterFeature = Color(0xFF0277BD);
  static const Color campfireFeature = Color(0xFFE65100);
  static const Color priceTag = Color(0xFFDFF5E7); // Light green pill
  static const Color filterActive = Color(
    0xFFDFF5E7,
  ); // Light green for active filter chip

  // Map colors
  static const Color mapMarker = primary;
  static const Color mapMarkerSelected = warning;
  static const Color mapCluster = primary;

  // Overlay colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [background, surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient overlayGradient = LinearGradient(
    colors: [Colors.transparent, overlay],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// Light theme color scheme following design specification
class LightColorScheme {
  static ColorScheme get colorScheme => ColorScheme.light(
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryDark,
    secondary: AppColors.textSecondary,
    secondaryContainer: AppColors.surface,
    surface: AppColors.surface,
    background: AppColors.background,
    error: AppColors.error,
    onPrimary: AppColors.textOnPrimary,
    onSecondary: AppColors.textPrimary,
    onSurface: AppColors.textPrimary,
    onBackground: AppColors.textPrimary,
    onError: AppColors.textOnPrimary,
    brightness: Brightness.light,
  );
}

/// Dark theme color scheme (future implementation)
class DarkColorScheme {
  static ColorScheme get colorScheme => ColorScheme.dark(
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryDark,
    secondary: AppColors.textSecondary,
    secondaryContainer: AppColors.surface,
    surface: const Color(0xFF121212),
    background: const Color(0xFF000000),
    error: AppColors.error,
    onPrimary: AppColors.textPrimary,
    onSecondary: AppColors.textPrimary,
    onSurface: AppColors.textOnPrimary,
    onBackground: AppColors.textOnPrimary,
    onError: AppColors.textOnPrimary,
    brightness: Brightness.dark,
  );
}
