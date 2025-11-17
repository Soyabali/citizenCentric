
import 'package:dio/dio.dart';

class ParseErrorLogger {
  void logError(Object error, StackTrace stackTrace, RequestOptions options) {
    print('Error: $error');
  }
}