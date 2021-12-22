import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  // static String get fileName => kReleaseMode ? '.env.production' : (kProfileMode ? '.env.uat' : '.env.development');
  static String get fileName => '.env.uat';
  static String get apiUrl => dotenv.env['API_URL'] ?? 'NO_URL';
  static String get location => dotenv.env['LOCATION'] ?? 'NO_ENV';
}