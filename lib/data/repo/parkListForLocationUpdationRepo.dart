import 'package:citizencentric/app/loader_helper.dart';

import '../../app/app_prefs.dart';
import '../../app/constant.dart';
import '../../app/di.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/model/parklistmodel.dart';
import '../../presentation/commponent/generalFunction.dart';
import 'package:flutter/material.dart';

class ParkListForLocationUpdationRepo {
  GeneralFunction generalFunction = GeneralFunction();

  Future<List<ParkListModel>?> parklistupdate(
      BuildContext context,
      selectedSubCategoryId,
      selectedDropDownSectorCode,
      ) async {
    AppPreferences appPreferences = instance<AppPreferences>();
    final token = await appPreferences.getUserToken();

    try {
      var apiUrl = "${Constant.baseUrl}ParkListForLocationUpdation/ParkListForLocationUpdation";

      var headers = {
        'token': token,
        'Content-Type': 'application/json',
      };
       showLoader();

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
        hideLoader();
        final data = await response.stream.bytesToString();
        final parsedJson = jsonDecode(data);

        final List<dynamic>? dataList = parsedJson['Data'];

        if (dataList == null) return [];

        /// 🔥 Convert JSON → Model
        return dataList
            .map((e) => ParkListModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      hideLoader();
      debugPrint("Exception: $e");
    }
    return null;
  }
}
