import 'dart:async';
import 'package:myveteran/core/models/veteran/veteran_work_model.dart';
import 'package:myveteran/core/provider/api_sync.dart';
// import 'package:flutter/material.dart';

class VeteranWorkService {
  final ApiSync _provider = ApiSync();

  Future<VeteranWorkModel> fetchVeteranWorkData({String? token}) async {
    final response = await _provider.getWithHeader('profile/info/service', token!); //api_veteran_work
    // debugPrint('veteran_work $response');
    return VeteranWorkModel.fromJson(response);
  }
}