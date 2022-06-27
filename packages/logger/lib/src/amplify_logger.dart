import 'dart:async';

import 'package:ansicolor/ansicolor.dart';
import 'package:aws_common/aws_common.dart';
import 'package:logging/logging.dart';

enum Category { Analytics, API, Auth, Storage, DataStore }

class AmplifyLogger {
  AmplifyLogger._(this._logger);

  static final Map<String, StreamSubscription<LogRecord>> _subscriptions = {};
  final Logger _logger;

  factory AmplifyLogger() => AmplifyLogger._(Logger('Amplify'));

  factory AmplifyLogger.category(Category category) {
    return AmplifyLogger._(Logger('Amplify.${category.name}'));
  }

  void registerPlugin(AmplifyLoggerPlugin plugin) {
    final currentSubscription = _subscriptions.remove(_logger.fullName);
    if (currentSubscription != null) {
      unawaited(currentSubscription.cancel());
    }
    _subscriptions[_logger.fullName] =
        _logger.onRecord.listen(plugin.handleLogRecord);
  }

  void setLogLevel

  /// Log a message with a log level of [Level.FINER].
  void verbose(String message) {
    _logger.finer(message);
  }

  /// Log a message with a log level of [Level.FINE].
  void debug(String message) {
    _logger.fine(message);
  }

  /// Log a message with a log level of [Level.INFO].
  void info(String message) {
    _logger.info(message);
  }

  /// Log a message with a log level of [Level.WARNING].
  void warn(String message) {
    _logger.warning(message);
  }

  /// Log a message with a log level of [Level.SEVERE].
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }
}

abstract class AmplifyLoggerPlugin {
  void handleLogRecord(LogRecord record);
}

class AnsiPrettyPrinter implements AmplifyLoggerPlugin {
  AnsiPrettyPrinter() {
    ansiColorDisabled = false;
  }

  @override
  void handleLogRecord(LogRecord record) {
    final buffer = StringBuffer();

    // Log Level
    buffer.write(record.level.formattedString);

    // Log Namespace
    buffer.write(' ');

    final namespace =
        record.loggerName == 'Amplify' ? '' : record.loggerName.split('.')[1];
    if (namespace.isNotEmpty) {
      buffer.write(_formatLogNamespace(namespace));
    }

    // Log Message
    buffer.write(' ');
    buffer.write(record.message);

    safePrint(buffer.toString());
  }

  String _formatLogNamespace(String? namespace) {
    return (AnsiPen()
      ..white(bold: true)
      ..gray(level: .2, bg: true))(' $namespace ');
  }
}

extension on Level {
  String get formattedString {
    if (this <= Level.FINER) {
      return (AnsiPen()
            ..white(bold: true)
            ..gray(level: .8, bg: true))(' V ')
          .toString();
    } else if (this <= Level.FINE) {
      return (AnsiPen()
        ..white(bold: true)
        ..gray(level: .6, bg: true))(' D ');
    } else if (this <= Level.INFO) {
      return (AnsiPen()
        ..white(bold: true)
        ..blue(bg: true))(' I ');
    } else if (this <= Level.WARNING) {
      return (AnsiPen()
        ..white(bold: true)
        ..yellow(bg: true))(' W ');
    } else {
      return (AnsiPen()
        ..white(bold: true)
        ..red(bg: true))(' E ');
    }
  }
}
