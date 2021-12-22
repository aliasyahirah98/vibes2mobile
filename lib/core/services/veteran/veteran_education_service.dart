import 'dart:async';
import 'package:myveteran/core/models/veteran/veteran_education_model.dart';
import 'package:myveteran/core/provider/api_sync.dart';
// import 'package:flutter/material.dart';

class VeteranEducationService {
  final ApiSync _provider = ApiSync();

  Future<VeteranEducationModel> fetchVeteranEducationData({String? token}) async {
    final response = await _provider.getWithHeader('profile/info/education', token!); //api_veteran_education
    // debugPrint('veteran_education $response');
    return VeteranEducationModel.fromJson(response);
  }

  Future<VeteranEducationResponseModel> updateVeteranEducationData({String? token, Map? body}) async {
    final response = await _provider.putWithHeader('profile/resume', token!, body: body); //api_update_veteran_education
    // debugPrint('update_veteran_education $response');
    return VeteranEducationResponseModel.fromJson(response);
  }
}