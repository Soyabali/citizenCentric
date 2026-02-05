import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../app/loader_helper.dart';
import '../../presentation/commponent/generalFunction.dart';


class TempRactureRepo {

  GeneralFunction generalFunction = GeneralFunction();

  Future<List?> tempracture(BuildContext context) async {

    try {

      var bindComplaintSubCategoryApi = "https://api.openweathermap.org/data/2.5/weather?lat=28.6016564&lon=77.3570279&appid=6956cabe579591ab4aa2869c08169147";
      showLoader();
      var request = http.Request('Get', Uri.parse('$bindComplaintSubCategoryApi'));

      http.StreamedResponse response = await request.send();
      if(response.statusCode ==401){
        generalFunction.logout(context);
      }
      if (response.statusCode == 200) {
        hideLoader();
        var data = await response.stream.bytesToString();
        List<dynamic>? parsedJson = jsonDecode(data);
        print("-----50----$parsedJson");

        return parsedJson;

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
