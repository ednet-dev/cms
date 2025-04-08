part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Log levels for the logger
enum LogLevel {
  /// Detailed tracing information
  trace,

  /// Debugging information
  debug,

  /// General information
  info,

  /// Warning information
  warning,

  /// Error information
  error,

  /// Fatal error information
  fatal,
}

/// A simple logging utility for consistent logging across the application
class LoggerUtils {
  /// Current logging level
  static LogLevel _currentLevel = LogLevel.info;

  /// Whether to include timestamps in log messages
  static bool _includeTimestamp = true;

  /// Whether to include log levels in log messages
  static bool _includeLogLevel = true;

  /// List of log listeners
  static final List<void Function(String, LogLevel)> _listeners = [];

  /// Sets the current logging level
  static void setLogLevel(LogLevel level) {
    _currentLevel = level;
  }

  /// Enable or disable timestamps in log messages
  static void setIncludeTimestamp(bool include) {
    _includeTimestamp = include;
  }

  /// Enable or disable log levels in log messages
  static void setIncludeLogLevel(bool include) {
    _includeLogLevel = include;
  }

  /// Add a listener for log messages
  static void addListener(void Function(String, LogLevel) listener) {
    _listeners.add(listener);
  }

  /// Remove a listener
  static void removeListener(void Function(String, LogLevel) listener) {
    _listeners.remove(listener);
  }

  /// Clear all listeners
  static void clearListeners() {
    _listeners.clear();
  }

  /// Log a trace message
  static void trace(String message, {String? tag}) {
    _log(LogLevel.trace, message, tag: tag);
  }

  /// Log a debug message
  static void debug(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag);
  }

  /// Log an info message
  static void info(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag);
  }

  /// Log a warning message
  static void warning(String message, {String? tag}) {
    _log(LogLevel.warning, message, tag: tag);
  }

  /// Log an error message
  static void error(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    final errorMsg = error != null ? '\nError: $error' : '';
    final stackMsg = stackTrace != null ? '\nStack Trace:\n$stackTrace' : '';
    _log(LogLevel.error, '$message$errorMsg$stackMsg', tag: tag);
  }

  /// Log a fatal message
  static void fatal(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    final errorMsg = error != null ? '\nError: $error' : '';
    final stackMsg = stackTrace != null ? '\nStack Trace:\n$stackTrace' : '';
    _log(LogLevel.fatal, '$message$errorMsg$stackMsg', tag: tag);
  }

  /// Internal method for logging
  static void _log(LogLevel level, String message, {String? tag}) {
    // Only log if the current level is less than or equal to the specified level
    if (level.index < _currentLevel.index) {
      return;
    }

    final now = DateTime.now();
    final timestamp = _includeTimestamp ? '[${now.toIso8601String()}] ' : '';
    final levelStr = _includeLogLevel
        ? '[${level.toString().split('.').last.toUpperCase()}] '
        : '';
    final tagStr = tag != null ? '[$tag] ' : '';
    final formattedMessage = '$timestamp$levelStr$tagStr$message';

    // Print to console
    switch (level) {
      case LogLevel.trace:
      case LogLevel.debug:
        print(formattedMessage);
        break;
      case LogLevel.info:
        print(formattedMessage);
        break;
      case LogLevel.warning:
        print('\x1B[33m$formattedMessage\x1B[0m'); // Yellow
        break;
      case LogLevel.error:
        print('\x1B[31m$formattedMessage\x1B[0m'); // Red
        break;
      case LogLevel.fatal:
        print(
            '\x1B[41m\x1B[37m$formattedMessage\x1B[0m'); // White on red background
        break;
    }

    // Notify listeners
    for (final listener in _listeners) {
      listener(formattedMessage, level);
    }
  }
}
