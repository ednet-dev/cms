part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Utility class for platform-specific operations and detection
///
/// This utility helps with platform detection and executing
/// platform-specific code in a clean, centralized way.
class PlatformUtils {
  /// Returns true if the app is running on a web platform
  static bool get isWeb => kIsWeb;

  /// Returns true if the app is running on iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Returns true if the app is running on Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Returns true if the app is running on macOS
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Returns true if the app is running on Windows
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Returns true if the app is running on Linux
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// Returns true if the app is running on a mobile platform (iOS or Android)
  static bool get isMobile => isIOS || isAndroid;

  /// Returns true if the app is running on a desktop platform (macOS, Windows, or Linux)
  static bool get isDesktop => isMacOS || isWindows || isLinux;

  /// Executes platform-specific code
  ///
  /// Provide handlers for each platform you want to support.
  /// Returns the result of the executed handler.
  static T platformSwitch<T>({
    required T Function() defaultHandler,
    T Function()? webHandler,
    T Function()? iosHandler,
    T Function()? androidHandler,
    T Function()? macosHandler,
    T Function()? windowsHandler,
    T Function()? linuxHandler,
    T Function()? mobileHandler,
    T Function()? desktopHandler,
  }) {
    // Check for specific platform handlers first
    if (isWeb && webHandler != null) {
      return webHandler();
    } else if (isIOS && iosHandler != null) {
      return iosHandler();
    } else if (isAndroid && androidHandler != null) {
      return androidHandler();
    } else if (isMacOS && macosHandler != null) {
      return macosHandler();
    } else if (isWindows && windowsHandler != null) {
      return windowsHandler();
    } else if (isLinux && linuxHandler != null) {
      return linuxHandler();
    }

    // Check for platform category handlers
    if (isMobile && mobileHandler != null) {
      return mobileHandler();
    } else if (isDesktop && desktopHandler != null) {
      return desktopHandler();
    }

    // Use the default handler if no specific handler is found
    return defaultHandler();
  }

  /// Gets an appropriate dimension based on the platform
  ///
  /// Use this to adjust UI dimensions based on the platform.
  static double getDimension({
    required double defaultDimension,
    double? webDimension,
    double? iosDimension,
    double? androidDimension,
    double? macosDimension,
    double? windowsDimension,
    double? linuxDimension,
    double? mobileDimension,
    double? desktopDimension,
  }) {
    return platformSwitch<double>(
      defaultHandler: () => defaultDimension,
      webHandler: webDimension != null ? () => webDimension : null,
      iosHandler: iosDimension != null ? () => iosDimension : null,
      androidHandler: androidDimension != null ? () => androidDimension : null,
      macosHandler: macosDimension != null ? () => macosDimension : null,
      windowsHandler: windowsDimension != null ? () => windowsDimension : null,
      linuxHandler: linuxDimension != null ? () => linuxDimension : null,
      mobileHandler: mobileDimension != null ? () => mobileDimension : null,
      desktopHandler: desktopDimension != null ? () => desktopDimension : null,
    );
  }
}
