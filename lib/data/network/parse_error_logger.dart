import 'package:dio/dio.dart';

class ParseErrorLogger {
  void logError(
      Object error,
      StackTrace stackTrace,
      RequestOptions requestOptions, {
        Response? response, // ✅ ADD THIS
      }) {
    // You can log anything you want here
    print("ERROR: $error");
    print("URL: ${requestOptions.uri}");

    if (response != null) {
      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE DATA: ${response.data}");
    }
  }
}