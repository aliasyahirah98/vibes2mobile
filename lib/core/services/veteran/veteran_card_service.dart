import 'dart:async';
import 'package:myveteran/core/models/veteran/veteran_card_model.dart';
import 'package:myveteran/core/provider/api_sync.dart';
// import 'package:flutter/material.dart';

class VeteranCardService {
  final ApiSync _provider = ApiSync();

  Future<VeteranCardModel> fetchVeteranCardData({String? token}) async {
    final response = await _provider.getWithHeader('profile/info/veterancard', token!); //api_veteran_card
    // debugPrint('veteran_card $response');
    return VeteranCardModel.fromJson(response);
  }
}