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
    AppPreferences _appPreferences = instance<AppPreferences>();
    final token = await _appPreferences.getUserToken();
    print('Token  27 : $token');
    // get a login data
    final userData = await _appPreferences.getLoginUserData();
    print("----24----${userData?['userId']}");

    try {
      print('----phone-----18--$phone');

      var baseURL =  Constant.baseUrl;
      var endPoint = "DeleteUser/DeleteUser";
      var delete_account_Api = "$baseURL$endPoint";
      print('------------17---delete_account_Api---$delete_account_Api');

      showLoader();

      var headers = {
        'token': '$token',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST', Uri.parse('$delete_account_Api'));
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
        // create an instance of auth class
        print('----54-${response.statusCode}');
        hideLoader();
        print('----------22-----$map');
        return map;
      } else {
        print('----------59---delet accont RESPONSE----$map');
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