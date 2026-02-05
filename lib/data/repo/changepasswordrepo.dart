
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

    /// Here you should get a value from a sharedPreferenc that is stored at a login time.
    ///
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? sToken = prefs.getString('sToken');
    // String? iUserId = prefs.getString('iUserId');
    //
    // print('-----22---$sToken');
    // print('-----23---$iUserId');

    AppPreferences _appPreferences = instance<AppPreferences>();
    final token = await _appPreferences.getUserToken();
    final userData = await _appPreferences.getLoginUserData();

    try {
      print('----Number---$oldpassword');
      print('----PassWord---$newpassword');

      var baseURL = Constant.baseUrl;
      var endPoint = "ChangePassword/ChangePassword";
      var ChandgepasswordApi = "$baseURL$endPoint";
      print('------------17---loginAPI---$ChandgepasswordApi');

      showLoader();
      var headers = {
        'token': '$token',
        'Content-Type': 'application/json'
         };
      var request = http.Request('POST', Uri.parse('$ChandgepasswordApi'));
      request.body = json.encode({
        "iUserId": "${userData?['userId']}",
        "sOldPassword": oldpassword,
        "sNewPassword":newpassword});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------50---changePassword Response----$map');
      if(response.statusCode ==401){
        generalFunction.logout(context);
      }

      if (response.statusCode == 200) {
        hideLoader();
        print('----------53-----$map');
        return map;
      } else{
        print('----------29---changePassword Response----$map');
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



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../Helpers/loader_helper.dart';
// import 'baseurl.dart';
//
//
// class LoginRepo1 {
//
//   // this is a loginApi call functin
//
//   Future authenticate(BuildContext context, String number, String pass) async {
//
//     try {
//       print('----Number---$number');
//       print('----PassWord---$pass');
//
//       var baseURL = BaseRepo().baseurl;
//       var endPoint = "AppLogin/AppLogin";
//       var loginApi = "$baseURL$endPoint";
//       print('------------17---loginAPI---$loginApi');
//
//       showLoader();
//       var headers = {'Content-Type': 'application/json'};
//       var request = http.Request(
//           'POST',
//           Uri.parse('$loginApi'));
//       request.body = json.encode({"sContactNo": number, "sPassword": pass,"sAppVersion":1});
//       request.headers.addAll(headers);
//
//       http.StreamedResponse response = await request.send();
//       var map;
//       var data = await response.stream.bytesToString();
//       map = json.decode(data);
//       print('----------20---LOGINaPI RESPONSE----$map');
//       if (response.statusCode == 200) {
//         hideLoader();
//         print('----------22-----$map');
//         return map;
//       } else {
//         print('----------29---LOGINaPI RESPONSE----$map');
//         hideLoader();
//         print(response.reasonPhrase);
//         return map;
//       }
//     } catch (e) {
//       hideLoader();
//       debugPrint("exception: $e");
//       throw e;
//     }
//   }
// }
