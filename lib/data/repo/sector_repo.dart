import 'dart:convert';

import 'package:citizencentric/app/constant.dart';
import 'package:flutter/material.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../app/loader_helper.dart';
import '../../presentation/commponent/generalFunction.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


class SelectSectorRepo {

  GeneralFunction generalFunction = GeneralFunction();

  Future<List?> bindSector(BuildContext context, selectedSubCategoryId) async {

    AppPreferences appPreferences = instance<AppPreferences>();
    final token = await appPreferences.getUserToken();
    // get a login data
    final userData = await appPreferences.getLoginUserData();

    try {
      //var baseURL = BaseRepo().baseurl;
      var baseURL = Constant.baseUrl;
      var endPoint = "BindSector/BindSector";
      var bindSectorApi = "$baseURL$endPoint";
      showLoader();

      var headers = {
        'token': token,
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(bindSectorApi));
      // body
      request.body = json.encode(
          {
            "iUserId":"${userData?['userId']}",
            "iDivisionCode":selectedSubCategoryId,

          });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if(response.statusCode ==401){
        generalFunction.logout(context);
      }
      if (response.statusCode == 200) {
        hideLoader();
        var data = await response.stream.bytesToString();
        Map<String, dynamic> parsedJson = jsonDecode(data);
        List<dynamic>? subCategory = parsedJson['Data'];


        return subCategory;

        // if (dataList != null) {
        //   List<Map<String, dynamic>> notificationList = dataList.cast<Map<String, dynamic>>();
        //   print("xxxxx------46----: $notificationList");
        //   return notificationList;
        // } else{
        //   return null;
        // }
      } else {
        hideLoader();
        return null;
      }
    } catch (e) {
       hideLoader();
      debugPrint("Exception: $e");
      rethrow;
    }
  }
}