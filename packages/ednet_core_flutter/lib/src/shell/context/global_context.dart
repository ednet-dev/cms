part of ednet_core_flutter;

/// Global context to access shell app from anywhere
class GlobalContext {
  static GlobalContext? _instance;

  /// Get the singleton instance
  static GlobalContext? get instance => _instance;

  /// Initialize the global context
  static void initialize(ShellApp shellApp) {
    _instance ??= GlobalContext._(shellApp);
  }

  /// The shell app instance
  final ShellApp? shellApp;

  /// Private constructor
  GlobalContext._(this.shellApp);
}
