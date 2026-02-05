
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../app/app_prefs.dart';
import '../../app/constant.dart';
import '../../app/di.dart';
import '../../app/loader_helper.dart';
import '../../presentation/commponent/generalFunction.dart';



class ChangePasswordRepo {

  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future changePassword(BuildContext context, String oldpassword, String newpassword) async {

    AppPreferences appPreferences = instance<AppPreferences>();
    final token = await appPreferences.getUserToken();
    final userData = await appPreferences.getLoginUserData();
    try {
      var baseURL = Constant.baseUrl;
      var endPoint = "ChangePassword/ChangePassword";
      var ChandgepasswordApi = "$baseURL$endPoint";

      showLoader();
      var headers = {
        'token': token,
        'Content-Type': 'application/json'
         };
      var request = http.Request('POST', Uri.parse(ChandgepasswordApi));
      request.body = json.encode({
        "iUserId": "${userData?['userId']}",
        "sOldPassword": oldpassword,
        "sNewPassword":newpassword});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);

      if(response.statusCode ==401){
        generalFunction.logout(context);
      }

      if (response.statusCode == 200) {
        hideLoader();
        return map;
      } else{
        hideLoader();
        return map;
      }
    } catch (e) {
      hideLoader();
      debugPrint("exception: $e");
      rethrow;
    }
  }
}
