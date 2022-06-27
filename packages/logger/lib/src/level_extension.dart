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
import 'package:logging/logging.dart';

import 'log_level.dart';

extension AmplifyLevelExtension on Level {
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

  LogLevel get logLevel {
    if (this.value >= Level.ALL.value) {
      return LogLevel.verbose;
    } else if (this.value >= Level.SEVERE.value) {
      return LogLevel.error;
    } else if (this.value >= Level.WARNING.value) {
      return LogLevel.warn;
    } else if (this.value >= Level.INFO.value) {
      return LogLevel.info;
    } else if (this.value >= Level.ALL.value) {
      return LogLevel.verbose;
    }
    return LogLevel.verbose;
  }
}
