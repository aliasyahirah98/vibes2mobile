import 'dart:async';
import 'package:myveteran/core/models/welfare/welfare_details_model.dart';
import 'package:myveteran/core/models/welfare/welfare_list_model.dart';
import 'package:myveteran/core/provider/api_sync.dart';
// import 'package:flutter/material.dart';

class WelfareService {
  final ApiSync _provider = ApiSync();

  Future<WelfareListModel> fetchWelfareListData({String? token, String? myKadNo}) async {
    final response = await _provider.getWithHeader('profile/kebajikan/application/list?BKAppVeteranMykadNo=' + myKadNo!, token!); //api_welfare_list
    // debugPrint('welfare $response');
    return WelfareListModel.fromJson(response);
  }

  Future<WelfareDetailsModel> fetchWelfareDetailsData({String? token, String? bKAppCode}) async {
    final response = await _provider.getWithHeader('profile/kebajikan/application/details?BKAppCode=' + bKAppCode!, token!); //api_welfare_details
    // debugPrint('welfare details $response');
    return WelfareDetailsModel.fromJson(response);
  }
}