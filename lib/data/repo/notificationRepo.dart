
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../Helpers/loader_helper.dart';
import 'package:http/http.dart' as http;
import '../screens/generalFunction.dart';
import 'baseurl.dart';

class NotificationRepo {
  GeneralFunction generalFunction = GeneralFunction();
  Future<List<Map<String, dynamic>>?> notification(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? iUserId = prefs.getString('iUserId');

    print('-----16---$sToken');
    print('-----17---$iUserId');

    try {
      var baseURL = BaseRepo().baseurl;
      var endPoint = "GetNotificationList/GetNotificationList";
      var notificationApi = "$baseURL$endPoint";
      showLoader();

      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$notificationApi'));
      request.body = json.encode({
        "iUserId": "$iUserId",
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
