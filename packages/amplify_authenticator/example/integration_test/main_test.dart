/*
 * Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */


import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'confirm_sign_up_test.dart' as confirm_sign_up_tests;
import 'custom_ui_test.dart' as custom_ui_test;
import 'reset_password_test.dart' as reset_password_test;
import 'sign_in_force_new_password_test.dart'
    as sign_in_force_new_password_test;
import 'sign_in_mfa_test.dart' as sign_in_mfa_test;
import 'sign_in_with_email_test.dart' as sign_in_with_email_test;
import 'sign_in_with_phone_test.dart' as sign_in_with_phone_test;
import 'sign_in_with_username_test.dart' as sign_in_with_username_test;
import 'sign_up_with_email_test.dart' as sign_up_with_email_test;
import 'sign_up_with_email_with_lambda_trigger_test.dart'
    as sign_up_with_email_with_lambda_trigger_test;
import 'sign_up_with_phone_test.dart' as sign_up_with_phone_test;
import 'sign_up_with_username_test.dart' as sign_up_with_username_test;
import 'unprotected_routes_test.dart' as unprotected_routes_test;
import 'verify_user_test.dart' as verify_user_test;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // 1. We need a mechanism to bypass the AmplifyAlreadyConfiguredException when running serial tests.
  // 2. We need to use a single serial test group for web integration tests (or else call Flutter driver
  // multiple times).
  // 3. Amplify.reset does not work on hybrid implementations.
  // 4. We do not want to call this main_test.dart file for non-web integration tests.
  //
  // In order to satisfy these constraints, we pass an env parameter when calling the driver command
  // for web integration tests, and bypass these tests when it is missing.
  var webIntegrationTest = const bool.fromEnvironment('WEB_INTEG');
  print(webIntegrationTest);

  if(webIntegrationTest) {
    group('amplify_authenticator', () {  
      setUp(() => Amplify.reset());  
      confirm_sign_up_tests.main();
      custom_ui_test.main();
      reset_password_test.main();
      sign_in_force_new_password_test.main();
      sign_in_mfa_test.main();
      sign_in_with_email_test.main();
      sign_in_with_phone_test.main();
      sign_in_with_username_test.main();
      sign_up_with_email_test.main();
      sign_up_with_email_with_lambda_trigger_test.main();
      sign_up_with_phone_test.main();
      sign_up_with_username_test.main();
      unprotected_routes_test.main();
      verify_user_test.main();
    });
  }
  else {
    safePrint('Warning: main_test.dart not executing. This is should not happen when running web tests.');
  }
}
