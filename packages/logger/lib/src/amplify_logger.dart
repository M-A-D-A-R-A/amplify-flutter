// Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'package:logging/logging.dart';

import '../amplify_logger.dart';

enum Category { Analytics, API, Auth, Storage, DataStore }

class AmplifyLogger {
  AmplifyLogger._(this._logger);

  set logLevel(LogLevel logLevel) {
    _logger.level = logLevel.level;
  }

  static final Map<String, StreamSubscription<LogRecord>> _subscriptions = {};
  final Logger _logger;

  factory AmplifyLogger([String namespace = 'Amplify']) =>
      AmplifyLogger._(Logger(namespace));

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
