import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../app/constant.dart';
import '../../app/loader_helper.dart';
import '../../presentation/commponent/generalFunction.dart';

class VerifyAppVersionRepo {

  GeneralFunction generalFunction = GeneralFunction();
  Future verifyAppVersion(BuildContext context, String sVersion) async {

    try {

      var baseURL = Constant.baseUrl;
      var endPoint = "VerifyAppVersion/VerifyAppVersion";
      var verifyAppVersionApi = "$baseURL$endPoint";

      showLoader();
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse(verifyAppVersionApi));
      request.body = json.encode({"sVersion": sVersion});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);

      if (response.statusCode == 200) {
        // create an instance of auth class
        hideLoader();

        return map;
      } else {
        hideLoader();
        print(response.reasonPhrase);
        return map;
      }
    } catch (e) {
      hideLoader();
      debugPrint("exception: $e");
      rethrow;
    }
  }
}
