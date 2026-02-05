import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../app/app_prefs.dart';
import '../../app/constant.dart';
import '../../app/di.dart';
import '../../app/loader_helper.dart';
import '../../presentation/commponent/generalFunction.dart';


class UpdateParkLocationRepo {

  GeneralFunction generalFunction = GeneralFunction();

  Future<List?> updatePark(BuildContext context, parkId, double? lat, double? long, locationAddress, uplodedImage, String useriD, String parkName) async {

    AppPreferences appPreferences = instance<AppPreferences>();

    final token = await appPreferences.getUserToken();

    try {
      //var baseURL = BaseRepo().baseurl;
      var baseURL = Constant.baseUrl;
      var endPoint = "UpdateParkLocation/UpdateParkLocation";
      var updateParkLocationApi = "$baseURL$endPoint";
      showLoader();

      var headers = {
        'token': token,
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$updateParkLocationApi'));
      // body
      request.body = json.encode(
          {
            //"iUserId":"${userData?['userId']}",
            "iParkId":parkId,
            "fLatitude":lat,
            "fLongitude":long,
            "sGoogleLocation":locationAddress,
            "sParkPhoto":uplodedImage,
            "sLocUpdatedBy":useriD,
            "sParkName":parkName,

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

        return [parsedJson];

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
