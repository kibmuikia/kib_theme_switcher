import 'package:flutter/foundation.dart' show kDebugMode, debugPrint, DebugPrintCallback;

/// Sets up optimized debug printing configuration
/// Returns the original debugPrint function if you need to restore it later
DebugPrintCallback setupDebugPrint() {
  final originalDebugPrint = debugPrint;
  var counter = 0;
  final stopwatch = Stopwatch()..start();

  if (!kDebugMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  } else {
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message?.isNotEmpty ?? false) {
        originalDebugPrint!(
          '#${++counter} [${stopwatch.elapsedMilliseconds}ms] $message *',
          wrapWidth: wrapWidth,
        );
      }
    };
  }

  return originalDebugPrint;
}

/// A service class to manage debug print functionality.
/// This class provides methods to initialize and restore the debug print configuration.
class DebugPrintService {
  /// Holds the original debug print callback function.
  static DebugPrintCallback? _originalDebugPrint;

  /// Initializes the debug print configuration.
  /// This method sets up the debug print function to include a timestamp in debug mode.
  static void initialize() {
    _originalDebugPrint = setupDebugPrint();
  }

  /// Restores the original debug print configuration.
  /// This method reverts the debug print function to its original state if it was modified.
  static void restore() {
    if (_originalDebugPrint != null) {
      debugPrint = _originalDebugPrint!;
      _originalDebugPrint = null;
    }
  }
}

/// A utility class for logging messages in debug mode.
/// This class provides methods to log different types of messages (log, error, warning) with specific prefixes.
class dprint {
  /// Logs a message with a note prefix.
  ///
  /// \param message The message to log.
  /// \param symbol The symbol to use with the message
  /// Sample symbols: '🌐'-network, '🗑️'-cache/cleanup, '⏱️'-timing, '✅'-success, '💾'-database, '🔔'-notification
  static void lg(String message, {String symbol = '📝'}) {
    if (kDebugMode) {
      debugPrint('$symbol $message');
    }
  }

  /// Logs a message with an error prefix.
  ///
  /// \param message The message to log.
  static void err(String message) {
    if (kDebugMode) {
      debugPrint('❌ $message');
    }
  }

  /// Logs a message with a warning prefix.
  ///
  /// \param message The message to log.
  static void warn(String message) {
    if (kDebugMode) {
      debugPrint('⚠️ $message');
    }
  }
}
