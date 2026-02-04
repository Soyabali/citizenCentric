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

    AppPreferences _appPreferences = instance<AppPreferences>();
    final token = await _appPreferences.getUserToken();
    print('Token  27 : $token');
    print("------selectsub--xxxxxx--$selectedSubCategoryId");
    // get a login data
    final userData = await _appPreferences.getLoginUserData();

    try {
      //var baseURL = BaseRepo().baseurl;
      var baseURL = Constant.baseUrl;
      var endPoint = "BindSector/BindSector";
      var bindSectorApi = "$baseURL$endPoint";
      showLoader();

      var headers = {
        'token': '$token',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$bindSectorApi'));
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
        print("---57--$subCategory");

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
      throw e;
    }
  }
}

// class SelectSector {
//
//   GeneralFunction generalFunction = GeneralFunction();
//
//   Future<List?> getbindWard(BuildContext context) async {
//
//     AppPreferences _appPreferences = instance<AppPreferences>();
//     final token = await _appPreferences.getUserToken();
//     print('Token  27 : $token');
//     // get a login data
//     final userData = await _appPreferences.getLoginUserData();
//
//     try {
//       //var baseURL = BaseRepo().baseurl;
//       var baseURL = Constant.baseUrl;
//       var endPoint = "BindSector/BindSector";
//       var bindComplaintSubCategoryApi = "$baseURL$endPoint";
//       //showLoader();
//
//       var headers = {
//         'token': '$token',
//         'Content-Type': 'application/json'
//       };
//       var request = http.Request('POST', Uri.parse('$bindComplaintSubCategoryApi'));
//       // body
//       request.body = json.encode(
//           {
//             "iUserId":"${userData?['userId']}",
//             "iDivisionCode":"1",
//
//           });
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request.send();
//       if(response.statusCode ==401){
//         generalFunction.logout(context);
//       }
//       if (response.statusCode == 200) {
//         //hideLoader();
//         var data = await response.stream.bytesToString();
//         Map<String, dynamic> parsedJson = jsonDecode(data);
//         List<dynamic>? subCategory = parsedJson['Data'];
//         print("---57--$subCategory");
//
//         return subCategory;
//
//         // if (dataList != null) {
//         //   List<Map<String, dynamic>> notificationList = dataList.cast<Map<String, dynamic>>();
//         //   print("xxxxx------46----: $notificationList");
//         //   return notificationList;
//         // } else{
//         //   return null;
//         // }
//       } else {
//         // hideLoader();
//         return null;
//       }
//     } catch (e) {
//       // hideLoader();
//       debugPrint("Exception: $e");
//       throw e;
//     }
//   }
// }
// class BindCityzenWardRepo
// {
//   GeneralFunction generalFunction = GeneralFunction();
//
//   List bindcityWardList = [];
//   Future<List> getbindWard(BuildContext context) async
//   {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? sToken = prefs.getString('sToken');
//
//     print('---19-  TOKEN---$sToken');
//
//     try
//     {
//       showLoader();
//       //  var baseURL = BaseRepo().baseurl;
//       var baseURL = Constant.baseUrl;
//       var endPoint = "BindCitizenWard/BindCitizenWard";
//       var bindCityzenWardApi = "$baseURL$endPoint";
//       var headers = {
//         'token': '$sToken'
//       };
//       var request = http.Request('POST', Uri.parse('$bindComplaintSubCategoryApi'));
//       // body
//       request.body = json.encode(
//           {
//             "iUserId":"${userData?['userId']}",
//           });
//
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request.send();
//
//       if(response.statusCode ==401){
//         generalFunction.logout(context);
//       }
//
//       if (response.statusCode == 200)
//       {
//         hideLoader();
//         var data = await response.stream.bytesToString();
//         Map<String, dynamic> parsedJson = jsonDecode(data);
//         bindcityWardList = parsedJson['Data'];
//         print("Dist list Marklocation Api ----71------>:$bindcityWardList");
//         return bindcityWardList;
//       } else
//       {
//         hideLoader();
//         return bindcityWardList;
//       }
//     } catch (e)
//     {
//       hideLoader();
//       throw (e);
//     }
//   }
// }
