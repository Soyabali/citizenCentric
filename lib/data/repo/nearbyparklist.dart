import 'dart:convert';
import 'package:citizencentric/app/constant.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../app/loader_helper.dart';
import '../../domain/model/park_model.dart';


class NearByParkListRepo {
  AppPreferences _appPreferences = instance<AppPreferences>();

  /// ✅ Strongly typed list
  List<ParkModel> nearByParkList = [];

  Future<List<ParkModel>> nearByPark(
      BuildContext context,
      double latitude,
      double longitude,
      ) async {

   // SharedPreferences prefs = await SharedPreferences.getInstance();
    //String? sToken = prefs.getString('sToken');
    final token = await _appPreferences.getUserToken();
    print('Token  27 : $token');

    try {
      showLoader();

      final baseURL = Constant.base_Url;
      final endPoint = "Nearbyparks/Nearbyparks";
      final nearByParkApi = "$baseURL$endPoint";

      final request = http.Request(
        'POST',
        Uri.parse(nearByParkApi),
      );

      request.headers.addAll({
        'token': token ?? '',
        'Content-Type': 'application/json',
      });

      request.body = jsonEncode({
        "fLatitude": latitude,
        "fLongitude": longitude,
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      hideLoader();

      if (response.statusCode == 200) {
        final Map<String, dynamic> parsedJson = jsonDecode(responseBody);

        /// ✅ Only extract `Data`
        final List<dynamic> dataList = parsedJson['Data'] ?? [];

        /// ✅ Convert List → ParkModel
        nearByParkList = dataList
            .map((e) => ParkModel.fromJson(e))
            .toList();

        debugPrint(
            "Nearby Park List count: ${nearByParkList.length}");

        return nearByParkList;
      } else {
        return [];
      }
    } catch (e) {
      hideLoader();
      debugPrint("NearByPark API Error: $e");
      rethrow;
    }
  }
}
