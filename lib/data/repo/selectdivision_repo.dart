import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../app/app_prefs.dart';
import '../../app/constant.dart';
import '../../app/di.dart';
import '../../app/loader_helper.dart';
import '../../presentation/commponent/generalFunction.dart';


class SelectDivisionRepo {

  GeneralFunction generalFunction = GeneralFunction();

  Future<List?> bindSubCategory(BuildContext context) async {

    AppPreferences _appPreferences = instance<AppPreferences>();

    final token = await _appPreferences.getUserToken();
    print('Token  27 : $token');
    // get a login data
    final userData = await _appPreferences.getLoginUserData();

    try {
      //var baseURL = BaseRepo().baseurl;
      var baseURL = Constant.baseUrl;
      var endPoint = "BindDivision/BindDivision";
      var bindComplaintSubCategoryApi = "$baseURL$endPoint";
      showLoader();

      var headers = {
        'token': '$token',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$bindComplaintSubCategoryApi'));
      // body
      request.body = json.encode(
          {
            "iUserId":"${userData?['userId']}",
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
