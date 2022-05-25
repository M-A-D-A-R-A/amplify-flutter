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

import 'package:ansicolor/ansicolor.dart';

/// An enumeration of the different levels of logging.
/// The levels are progressive, with lower-value items being lower priority
enum LogLevel implements Comparable<LogLevel> {
  /// Logs for showing behavior of particular components/flows
  /// Not suitable for production as they may contain sensitive information
  verbose,

  /// Logs for understanding system behavior
  /// May contain information inappropriate for emission into production environments
  debug,

  /// Logs providing terse info about general operation and flow of software
  info,

  /// Logs indicating potential issues
  warn,

  /// Logs when system is not operating as expected
  error,

  /// Highest priority log to use as threshold value to prevent any logs from being emitted
  none;

  int compareTo(LogLevel other) {
    return this.index - other.index;
  }

  bool operator >(LogLevel value) => index > value.index;
  bool operator >=(LogLevel value) => index >= value.index;
  bool operator <(LogLevel value) => index < value.index;
  bool operator <=(LogLevel value) => index <= value.index;

  /// Creates a formatted string based on the log level.
  String toFormattedString() {
    switch (this) {
      case LogLevel.verbose:
        return (AnsiPen()
              ..white(bold: true)
              ..gray(level: .8, bg: true))(' V ')
            .toString();
      case LogLevel.info:
        return (AnsiPen()
          ..white(bold: true)
          ..blue(bg: true))(' I ');
      case LogLevel.debug:
        return (AnsiPen()
          ..white(bold: true)
          ..gray(level: .6, bg: true))(' D ');
      case LogLevel.warn:
        return (AnsiPen()
          ..white(bold: true)
          ..yellow(bg: true))(' W ');
      case LogLevel.error:
        return (AnsiPen()
          ..white(bold: true)
          ..red(bg: true))(' E ');
      default:
        return (AnsiPen()
              ..white(bold: true)
              ..gray(level: .8, bg: true))(
            ' ' + this.toString().substring(0, 1) + ' ');
    }
  }
}
