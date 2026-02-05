import 'dart:convert';

import 'package:citizencentric/app/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/loader_helper.dart';
import '../../presentation/commponent/generalFunction.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


class BindCityzenWardRepo
{
  GeneralFunction generalFunction = GeneralFunction();

  List bindcityWardList = [];
  Future<List> getbindWard(BuildContext context) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    try
    {
      showLoader();
    //  var baseURL = BaseRepo().baseurl;
      var baseURL = Constant.baseUrl;
      var endPoint = "BindSector/BindSector";
      var bindCityzenWardApi = "$baseURL$endPoint";
      var headers = {
        'token': '$sToken'
      };
      var request = http.Request('GET', Uri.parse('$bindCityzenWardApi'));

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if(response.statusCode ==401){
        generalFunction.logout(context);
      }

      if (response.statusCode == 200)
      {
        hideLoader();
        var data = await response.stream.bytesToString();
        Map<String, dynamic> parsedJson = jsonDecode(data);
        bindcityWardList = parsedJson['Data'];
        return bindcityWardList;
      } else
      {
        hideLoader();
        return bindcityWardList;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
