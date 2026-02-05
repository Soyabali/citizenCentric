import 'dart:convert';
import 'package:citizencentric/app/constant.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../app/loader_helper.dart';
import '../../domain/model/parksonmapModel.dart';


class ParkSonMapRepo {
  AppPreferences _appPreferences = instance<AppPreferences>();

  /// ✅ Strongly typed list
  List<ParksonmapModel> parksonMapParkList = [];

  Future<List<ParksonmapModel>> parksonPark(BuildContext context, selectedSubCategoryId) async {

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //String? sToken = prefs.getString('sToken');
    final token = await _appPreferences.getUserToken();
    print('Token  27 : $token');

    try {
      showLoader();

      final baseURL = Constant.base_Url;
      final endPoint = "Parksonmap/Parksonmap";
      final parksonParkApi = "$baseURL$endPoint";

      final request = http.Request(
        'POST',
        Uri.parse(parksonParkApi),
      );

      request.headers.addAll({
        'token': token,
        'Content-Type': 'application/json',
      });

      request.body = jsonEncode({
        "iDivisionCode": selectedSubCategoryId, /// todo it a testing you should put here as a dynamcic divisonCode
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

       hideLoader();

      if (response.statusCode == 200) {
        final Map<String, dynamic> parsedJson = jsonDecode(responseBody);

        /// ✅ Only extract `Data`
        final List<dynamic> dataList = parsedJson['Data'] ?? [];

        /// ✅ Convert List → ParkModel
        parksonMapParkList = dataList
            .map((e) => ParksonmapModel.fromJson(e))
            .toList();

        debugPrint(
            "Nearby Park List count: ${parksonMapParkList.length}");

        return parksonMapParkList;
      } else {
        return [];
      }
    } catch (e) {
       hideLoader();
      debugPrint("Parksonmap  API Error: $e");
      rethrow;
    }
  }
}
