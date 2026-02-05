import 'dart:convert';
import 'package:citizencentric/app/constant.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../app/loader_helper.dart';
import '../../domain/model/park_model.dart';


class NearByParkListRepo {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  /// ✅ Strongly typed list
  List<ParkModel> nearByParkList = [];

  Future<List<ParkModel>> nearByPark(
      BuildContext context,
      double latitude,
      double longitude,
      ) async {
    final token = await _appPreferences.getUserToken();
    try {
      showLoader();

      final baseURL = Constant.baseUrl;
      final endPoint = "Nearbyparks/Nearbyparks";
      final nearByParkApi = "$baseURL$endPoint";

      final request = http.Request(
        'POST',
        Uri.parse(nearByParkApi),
      );

      request.headers.addAll({
        'token': token,
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
