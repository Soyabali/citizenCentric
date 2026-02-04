import 'package:dio/dio.dart';

class ParseErrorLogger {
  void logError(
      Object error,
      StackTrace stackTrace,
      RequestOptions requestOptions,
      Response? response,
      ) {
    // You can log everything safely here
    print("ERROR: $error");
    print("URL: ${requestOptions.path}");
    print("STATUS: ${response?.statusCode}");
    print("DATA: ${response?.data}");
  }
}
