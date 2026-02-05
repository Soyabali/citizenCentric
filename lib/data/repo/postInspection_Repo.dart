import 'dart:convert';

import 'package:flutter/material.dart';

import '../../app/app_prefs.dart';
import '../../app/constant.dart';
import '../../app/di.dart';
import 'package:http/http.dart' as http;
import '../../app/loader_helper.dart';
import '../../domain/model/allParkLocationModel.dart';
import '../../presentation/commponent/generalFunction.dart';

class PostInspectionRepo {

  GeneralFunction generalFunction = GeneralFunction();

  Future<List<AllParkLocationModel>?> postinspection(BuildContext context,
      selectedSubCategoryId,
      selectedDropDownSectorCode,) async {
    AppPreferences appPreferences = instance<AppPreferences>();
    final token = await appPreferences.getUserToken();

    try {
      showLoader();
      var apiUrl = "${Constant
          .baseUrl}AllParkLocation/AllParkLocation";

      var headers = {
        'token': token,
        'Content-Type': 'application/json',
      };

      var request = http.Request('POST', Uri.parse(apiUrl));
      request.body = jsonEncode({
        "iDivisionCode": selectedSubCategoryId,
        "iSectorCode": selectedDropDownSectorCode,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 401) {
        hideLoader();
        generalFunction.logout(context);
        return null;
      }

      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        final parsedJson = jsonDecode(data);
        print("-----49------data----$parsedJson");
        hideLoader();


        final List<dynamic>? dataList = parsedJson['Data'];

        if (dataList == null) return [];

        /// 🔥 Convert JSON → Model
        return dataList
            .map((e) => AllParkLocationModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      hideLoader();
      debugPrint("Exception: $e");
    }
    return null;
  }
}