class Dimensions {
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  static const double paddingXS = spaceXS;
  static const double paddingS = spaceS;
  static const double paddingM = spaceM;
  static const double paddingL = spaceL;
  static const double paddingXL = spaceXL;
  static const double paddingXXL = spaceXXL;

  static const double marginXS = spaceXS;
  static const double marginS = spaceS;
  static const double marginM = spaceM;
  static const double marginL = spaceL;
  static const double marginXL = spaceXL;
  static const double marginXXL = spaceXXL;

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXS = 4.0;

  static const double borderRadiusSmall = radiusS;
  static const double borderRadiusMedium = radiusM;
  static const double borderRadiusLarge = radiusL;

  static const double appBarHeight = 56.0;

  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 32.0;
  static const double buttonHeightLarge = 56.0;

  static const double cardElevation = 2.0;
  static const double cardElevationHover = 4.0;
  static const double cardImageHeight = 120.0;
  static const double cardImageHeightLarge = 240.0;

  static const double inputHeight = 48.0;
  static const double inputHeightSmall = 40.0;

  static const double bottomNavHeight = 60.0;
  static const double tabBarHeight = 48.0;

  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  static const double avatarSize = 40.0;
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeLarge = 56.0;
  static const double thumbnailSize = 80.0;
  static const double thumbnailSizeLarge = 120.0;

  static const double loadingIndicatorSize = 24.0;
  static const double loadingIndicatorSizeLarge = 40.0;

  static const double dividerThickness = 1.0;
  static const double dividerIndent = 16.0;

  static const double fabSize = 56.0;
  static const double fabSizeSmall = 40.0;

  static const double searchBarHeight = 48.0;
  static const double searchBarRadius = 24.0;

  static const double chipHeight = 32.0;
  static const double chipRadius = 16.0;

  static const double starSize = 16.0;
  static const double starSizeSmall = 14.0;
  static const double starSizeLarge = 20.0;

  static const double markerSize = 40.0;

  static const double bottomSheetRadius = 16.0;
  static const double bottomSheetMinHeight = 280.0;

  static const double calendarDaySize = 40.0;
  static const double calendarDayRadius = 20.0;

  static const double campsiteCardWidth = 160.0;
  static const double campsiteCardImageHeight = 120.0;

  static const double mobileBreakpoint = 0.0;
  static const double tabletBreakpoint = 768.0;
  static const double desktopBreakpoint = 1024.0;
}

class ResponsiveDimensions {
  static double getPadding(double screenWidth) {
    if (screenWidth < Dimensions.mobileBreakpoint) {
      return Dimensions.paddingS;
    } else if (screenWidth < Dimensions.tabletBreakpoint) {
      return Dimensions.paddingM;
    } else {
      return Dimensions.paddingL;
    }
  }

  static double getMargin(double screenWidth) {
    if (screenWidth < Dimensions.mobileBreakpoint) {
      return Dimensions.marginS;
    } else if (screenWidth < Dimensions.tabletBreakpoint) {
      return Dimensions.marginM;
    } else {
      return Dimensions.marginL;
    }
  }

  static double getSpacing(double screenWidth) {
    if (screenWidth < Dimensions.mobileBreakpoint) {
      return Dimensions.spaceS;
    } else if (screenWidth < Dimensions.tabletBreakpoint) {
      return Dimensions.spaceM;
    } else {
      return Dimensions.spaceL;
    }
  }

  static bool isMobile(double screenWidth) {
    return screenWidth < Dimensions.mobileBreakpoint;
  }

  static bool isTablet(double screenWidth) {
    return screenWidth >= Dimensions.mobileBreakpoint &&
        screenWidth < Dimensions.desktopBreakpoint;
  }

  static bool isDesktop(double screenWidth) {
    return screenWidth >= Dimensions.desktopBreakpoint;
  }
}
