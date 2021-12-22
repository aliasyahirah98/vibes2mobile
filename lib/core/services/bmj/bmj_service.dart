import 'dart:async';
import 'package:myveteran/core/models/bmj/bmj_track_list_model.dart';
import 'package:myveteran/core/provider/api_sync.dart';
// import 'package:flutter/material.dart';

class BmjService {
  final ApiSync _provider = ApiSync();

  Future<BmjTrackListModel> fetchBmjTrackListData({String? token}) async {
    final response = await _provider.getWithHeader('profile/info/bmj/info', token!); //api_bmj_list
    // debugPrint('bmj_track $response');
    return BmjTrackListModel.fromJson(response);
  }
}