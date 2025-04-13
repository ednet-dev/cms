part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Screen size categories
enum ScreenSize {
  /// Extra small screens (phones in portrait)
  xs,

  /// Small screens (phones in landscape, small tablets)
  sm,

  /// Medium screens (tablets in portrait)
  md,

  /// Large screens (tablets in landscape, small desktops)
  lg,

  /// Extra large screens (large desktops)
  xl,
}

/// Utility for device-specific information and functionality
class DeviceUtils {
  /// Breakpoints for screen sizes in logical pixels
  static const Map<ScreenSize, double> breakpoints = {
    ScreenSize.xs: 0,
    ScreenSize.sm: 600,
    ScreenSize.md: 960,
    ScreenSize.lg: 1280,
    ScreenSize.xl: 1920,
  };

  /// Returns the current screen size category based on width
  static ScreenSize getScreenSizeFromWidth(double width) {
    if (width >= breakpoints[ScreenSize.xl]!) {
      return ScreenSize.xl;
    } else if (width >= breakpoints[ScreenSize.lg]!) {
      return ScreenSize.lg;
    } else if (width >= breakpoints[ScreenSize.md]!) {
      return ScreenSize.md;
    } else if (width >= breakpoints[ScreenSize.sm]!) {
      return ScreenSize.sm;
    } else {
      return ScreenSize.xs;
    }
  }

  /// Returns the current screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return getScreenSizeFromWidth(width);
  }

  /// Returns true if the device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Returns true if the device is in portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Returns true if the device has a notch
  static bool hasNotch(BuildContext context) {
    return MediaQuery.of(context).viewPadding.top > 20;
  }

  /// Returns the device pixel ratio
  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  /// Returns the status bar height
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).viewPadding.top;
  }

  /// Returns true if the device is a phone (based on screen size)
  static bool isPhone(BuildContext context) {
    final size = getScreenSize(context);
    return size == ScreenSize.xs || size == ScreenSize.sm;
  }

  /// Returns true if the device is a tablet (based on screen size)
  static bool isTablet(BuildContext context) {
    final size = getScreenSize(context);
    return size == ScreenSize.md || size == ScreenSize.lg;
  }

  /// Returns true if the device is a desktop (based on screen size)
  static bool isDesktop(BuildContext context) {
    final size = getScreenSize(context);
    return size == ScreenSize.xl;
  }

  /// Gets a responsive value based on the screen size
  ///
  /// This allows you to return different values for different screen sizes.
  static T getResponsiveValue<T>({
    required BuildContext context,
    required T xsValue,
    T? smValue,
    T? mdValue,
    T? lgValue,
    T? xlValue,
  }) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.xl:
        return xlValue ?? lgValue ?? mdValue ?? smValue ?? xsValue;
      case ScreenSize.lg:
        return lgValue ?? mdValue ?? smValue ?? xsValue;
      case ScreenSize.md:
        return mdValue ?? smValue ?? xsValue;
      case ScreenSize.sm:
        return smValue ?? xsValue;
      case ScreenSize.xs:
        return xsValue;
    }
  }

  /// Returns a responsive padding based on the screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return getResponsiveValue<EdgeInsets>(
      context: context,
      xsValue: const EdgeInsets.all(8.0),
      smValue: const EdgeInsets.all(12.0),
      mdValue: const EdgeInsets.all(16.0),
      lgValue: const EdgeInsets.all(24.0),
      xlValue: const EdgeInsets.all(32.0),
    );
  }

  /// Returns a responsive spacing value based on the screen size
  static double getResponsiveSpacing(BuildContext context) {
    return getResponsiveValue<double>(
      context: context,
      xsValue: 8.0,
      smValue: 12.0,
      mdValue: 16.0,
      lgValue: 24.0,
      xlValue: 32.0,
    );
  }

  /// Returns a responsive font size based on the screen size
  static double getResponsiveFontSize(BuildContext context,
      {double baseFontSize = 14.0}) {
    return getResponsiveValue<double>(
      context: context,
      xsValue: baseFontSize,
      smValue: baseFontSize * 1.1,
      mdValue: baseFontSize * 1.2,
      lgValue: baseFontSize * 1.3,
      xlValue: baseFontSize * 1.4,
    );
  }
}
