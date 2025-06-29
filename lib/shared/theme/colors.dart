import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF00C896);
  static const Color primaryDark = Color(0xFF00A67D);

  static const Color background = Color(0xFFF6FBF7);
  static const Color surface = Color(0xFFEFF7F2);

  static const Color textPrimary = Color(0xFF1A3A2D);
  static const Color textSecondary = Color(0xFF5B8576);
  static const Color textLight = Color(0xFFB6CFC2);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFD6E9DE);
  static const Color divider = Color(0xFFD6E9DE);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  static const Color shadow = Color(0x1A000000);

  static const Color primaryGreen = primary;
  static const Color primaryGreenLight = Color(0xFF33D4AA);
  static const Color primaryGreenDark = primaryDark;

  static const Color backgroundWhite = background;
  static const Color backgroundGrey = surface;
  static const Color surfaceWhite = surface;
  static const Color surfaceGrey = surface;

  static const Color waterFeature = Color(0xFF0277BD);
  static const Color campfireFeature = Color(0xFFE65100);
  static const Color priceTag = Color(0xFFDFF5E7);
  static const Color filterActive = Color(0xFFDFF5E7);

  static const Color mapMarker = primary;
  static const Color mapMarkerSelected = warning;
  static const Color mapCluster = primary;

  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

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
