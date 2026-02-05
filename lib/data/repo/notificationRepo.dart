
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../app/app_prefs.dart';
import '../../app/constant.dart';
import '../../app/di.dart';
import '../../app/loader_helper.dart';
import '../../presentation/commponent/generalFunction.dart';

class NotificationRepo {
  GeneralFunction generalFunction = GeneralFunction();

  Future<List<Map<String, dynamic>>?> notification(BuildContext context) async {

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? sToken = prefs.getString('sToken');
    // String? iUserId = prefs.getString('iUserId');

    AppPreferences _appPreferences = instance<AppPreferences>();
    final token = await _appPreferences.getUserToken();
    final userData = await _appPreferences.getLoginUserData();



    try {
      var baseURL = Constant.baseUrl;
      var endPoint = "GetNotificationList/GetNotificationList";
      var notificationApi = "$baseURL$endPoint";
      showLoader();

      var headers = {
        'token': '$token',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$notificationApi'));
      request.body = json.encode({
        "iUserId": "${userData?['userId']}",
        "iPage": "1",
        "iPageSize": "10"
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
        List<dynamic>? dataList = parsedJson['Data'];

        if (dataList != null) {
          List<Map<String, dynamic>> notificationList = dataList.cast<Map<String, dynamic>>();
          print("xxxxx------46----: $notificationList");
          return notificationList;
        } else{
          return null;
        }
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
