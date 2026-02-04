import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';


class DeleteAccountRepo {

  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future deleteAccount(BuildContext context, String phone) async {
    // get a contact No
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? contactNo = prefs.getString('sContactNo');
    try {
      print('----phone-----18--$phone');

      var baseURL = BaseRepo().baseurl;
      var endPoint = "DeleteUserAccount/DeleteUserAccount";
      var loginApi = "$baseURL$endPoint";
      print('------------17---loginApi---$loginApi');

      showLoader();

      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST',
          Uri.parse('$loginApi'));
      request.body = json.encode(
          {
            "sContactNo": contactNo,
          });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------20---LOGINaPI RESPONSE----$map');

      if (response.statusCode == 200) {
        // create an instance of auth class
        print('----44-${response.statusCode}');
        hideLoader();
        print('----------22-----$map');
        return map;
      } else {
        print('----------29---LOGINaPI RESPONSE----$map');
        hideLoader();
        print(response.reasonPhrase);
        return map;
      }
    } catch (e) {
      hideLoader();
      debugPrint("exception: $e");
      throw e;
    }
  }

}