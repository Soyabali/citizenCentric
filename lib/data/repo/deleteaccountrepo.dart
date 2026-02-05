import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../app/app_prefs.dart';
import '../../app/constant.dart';
import '../../app/di.dart';
import '../../app/loader_helper.dart';
import '../../presentation/commponent/generalFunction.dart';

class DeleteAccountRepo {

  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future deleteAccount(BuildContext context, String phone) async {
    // get a token and userID
    AppPreferences appPreferences = instance<AppPreferences>();
    final token = await appPreferences.getUserToken();
    // get a login data
    final userData = await appPreferences.getLoginUserData();
    try {
      var baseURL =  Constant.baseUrl;
      var endPoint = "DeleteUser/DeleteUser";
      var deleteAccountApi = "$baseURL$endPoint";
      showLoader();

      var headers = {
        'token': token,
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST', Uri.parse(deleteAccountApi));
      request.body = json.encode(
          {
            "iUserId": "${userData?['userId']}",
          });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------50---Delete Account----$map');

      if (response.statusCode == 200) {
        hideLoader();
        return map;
      } else {
        hideLoader();
        return map;
      }
    } catch (e) {
      hideLoader();
      rethrow;
    }
  }

}