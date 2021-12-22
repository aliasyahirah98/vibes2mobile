import 'dart:async';
import 'package:myveteran/core/models/veteran/veteran_dependent_model.dart';
import 'package:myveteran/core/provider/api_sync.dart';
// import 'package:flutter/material.dart';

class VeteranDependentService {
  final ApiSync _provider = ApiSync();

  Future<VeteranDependentModel> fetchVeteranDependentData({String? token}) async {
    final response = await _provider.getWithHeader('profile/info/dependant', token!); //api_veteran_dependant
    // debugPrint('veteran_dependant $response');
    return VeteranDependentModel.fromJson(response);
  }
}