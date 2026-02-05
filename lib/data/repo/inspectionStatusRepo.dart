import 'package:flutter/cupertino.dart';

import '../../app/app_prefs.dart';
import '../../app/constant.dart';
import '../../app/di.dart';
import '../../app/loader_helper.dart';
import '../../domain/model/InspectionStatusModel.dart';
import '../../presentation/commponent/generalFunction.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InspectionStartRepo {

  GeneralFunction generalFunction = GeneralFunction();

  Future<List<InspectionStatusModel>?> inspectionStartRepo(BuildContext context) async {
    AppPreferences _appPreferences = instance<AppPreferences>();
    final token = await _appPreferences.getUserToken();
    final userData = await _appPreferences.getLoginUserData();

    try {
      var apiUrl = "${Constant.baseUrl}InspectionStatus/InspectionStatus";
      showLoader();

      var headers = {
        'token': token,
        'Content-Type': 'application/json',
      };

      var request = http.Request('POST', Uri.parse(apiUrl));
      request.body = jsonEncode({
        "iUserId": "${userData?['userId']}",
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
        print("-----45----$parsedJson");
        final List<dynamic>? dataList = parsedJson['Data'];
        print("-----47----$parsedJson");

        if (dataList == null) return [];
        hideLoader();

        /// 🔥 Convert JSON → Model
        return dataList
            .map((e) => InspectionStatusModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      hideLoader();
      debugPrint("Exception: $e");
    }
    return null;
  }
}
