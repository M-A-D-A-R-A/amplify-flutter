import 'package:amplify_logger/amplify_logger.dart';
import 'package:logging/logging.dart';

void main() {
  hierarchicalLoggingEnabled = true;

  Logger.root.level = Level.ALL;

  var logger = AmplifyLogger()
    ..registerPlugin(AnsiPrettyPrinter())
    ..verbose('Verbose')
    ..debug('Debug')
    ..info('Info')
    ..warn('Warning')
    ..error('Error', Exception('An unknown error'));

//  Logger.root.children["Amplify"]!.level = Level.WARNING;
  logger.level = Level.WARNING;

  var authLogger = AmplifyLogger.category(Category.Auth)
    ..verbose('Verbose')
    ..debug('Debug')
    ..info('Info')
    ..warn('Warning')
    ..error('Error', Exception('An unknown error'));

  //Logger.root.children["Amplify"]!.children["Auth"]!.level = Level.WARNING;

  //var test = Logger.root.name;
  //Logger.detached(Category.Auth.toString())
}
