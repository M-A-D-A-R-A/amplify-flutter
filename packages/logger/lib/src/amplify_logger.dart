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

import 'package:amplify_core/amplify_core.dart';
import 'package:ansicolor/ansicolor.dart';
import 'package:aws_common/aws_common.dart';

import 'log_event.dart';
import 'log_level.dart';

class AmplifyLogger {
  static final StreamController<LogEvent> _logStreamController =
      StreamController<LogEvent>();

  static final Sink<LogEvent> _logSink = _logStreamController.sink;

  /// A map of existing logger instances.
  static final Map<String, AmplifyLogger> _logsMap = {};

  /// A stream of logs from all logger instances.
  static final Stream<LogEvent> logStream = _logStreamController.stream;

  /// Default logger instance without a namespace.
  static get defaultLogger => getInstance();

  LogLevel logLevel = LogLevel.info;
  static LogLevel globalLogLevel = LogLevel.info;

  static bool useDefaultLogHandler = true;

  /// The namespace of the logger instance.
  String get namespace {
    return _namespace;
  }

  String _namespace;

  AmplifyLogger({String namespace = 'default'}) : _namespace = namespace;

  /// Log a message with an optional log level.
  ///
  /// The log level defaults to [LogLevel.info].
  void log({
    required String message,
    LogLevel level = LogLevel.info,
  }) {
    if (level < logLevel) return;

    final logEvent = LogEvent(
      level: level,
      namespace: namespace,
      message: message,
    );
    _logSink.add(logEvent);
  }

  /// Log a message with a log level of [LogLevel.verbose].
  void verbose(String message) {
    log(message: message, level: LogLevel.verbose);
  }

  /// Log a message with a log level of [LogLevel.debug].
  void debug(String message) {
    log(message: message, level: LogLevel.debug);
  }

  /// Log a message with a log level of [LogLevel.info].
  void info(String message) {
    log(message: message, level: LogLevel.info);
  }

  /// Log a message with a log level of [LogLevel.warn].
  void warn(String message) {
    log(message: message, level: LogLevel.warn);
  }

  /// Log a message with a log level of [LogLevel.error].
  void error(String message) {
    log(message: message, level: LogLevel.error);
  }

  /// Get or create a logger instance.
  ///
  /// If no instance exists with the given namespace, a new
  /// instance will be created.
  static AmplifyLogger getInstance({String namespace = 'default'}) {
    return _logsMap[namespace] ??= AmplifyLogger(namespace: namespace);
  }

  static AmplifyLogger getCategoryInstance({required Category category}) {
    return getInstance(namespace: category.toString());
  }

  /// Initialize the logger by listening to the log stream.
  static void initDefaultLogHandler() {
    ansiColorDisabled = false;

    logStream
        .where((event) => event.level >= globalLogLevel)
        .listen((logEvent) {
      if (useDefaultLogHandler) _printLog(logEvent);
    });
  }

  static void _printLog(LogEvent logEvent) {
    StringBuffer buffer = StringBuffer();

    // Log Level
    buffer.write(logEvent.level.toFormattedString());

    // Log Namespace
    buffer.write(' ');

    String? namespace = logEvent.namespace;
    buffer.write(_formatLogNamespace(namespace));

    // Log Message
    buffer.write(' ');
    buffer.write(logEvent.message);

    safePrint(buffer.toString());
  }

  static String _formatLogNamespace(String? namespace) {
    if (namespace == null) return '';

    return (AnsiPen()
      ..white(bold: true)
      ..gray(level: .2, bg: true))(' ' + namespace + ' ');
  }
}
