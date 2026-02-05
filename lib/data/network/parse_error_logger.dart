import 'package:dio/dio.dart';

class ParseErrorLogger {
  void logError(
      Object error,
      StackTrace stackTrace,
      RequestOptions requestOptions,
      Response? response,
      ) {
    // You can log everything safely here
  }
}
