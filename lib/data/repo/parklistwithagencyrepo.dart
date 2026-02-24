import 'dart:convert';

import 'package:citizencentric/app/loader_helper.dart';
import 'package:flutter/material.dart';
import '../../app/app_prefs.dart';
import '../../app/constant.dart';
import '../../app/di.dart';
import 'package:http/http.dart' as http;
import '../../domain/model/parklistwithagencymodel.dart';
import '../../presentation/commponent/generalFunction.dart';

class ParkListWithAgencyRepo {

  GeneralFunction generalFunction = GeneralFunction();

  Future<List<ParkListWithAgencyModel>?> parkListWithAgency(BuildContext context, agencyCode) async {
    AppPreferences appPreferences = instance<AppPreferences>();
    final token = await appPreferences.getUserToken();

    try {
      var apiUrl = "${Constant.baseUrl}ParkListByAgency/ParkListByAgency";

      var headers = {
        'token': token,
        'Content-Type': 'application/json',
      };
        showLoader();
      var request = http.Request('POST', Uri.parse(apiUrl));
      request.body = jsonEncode({
        "iAgencyCode": agencyCode,// in a future you should dynamcic value

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
            .map((e) => ParkListWithAgencyModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      hideLoader();
      debugPrint("Exception: $e");
    }
    return null;
  }
}