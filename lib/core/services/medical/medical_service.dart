import 'dart:async';
import 'package:myveteran/core/models/medical/medical_track_details_model.dart';
import 'package:myveteran/core/models/medical/medical_track_list_model.dart';
import 'package:myveteran/core/provider/api_sync.dart';
// import 'package:flutter/material.dart';

class MedicalService {
  final ApiSync _provider = ApiSync();

  Future<MedicalTrackListModel> fetchMedicalTrackListData({String? token}) async {
    final response = await _provider.getWithHeader('profile/info/medical/list', token!); //api_medical_list
    // debugPrint('medical_track $response');
    return MedicalTrackListModel.fromJson(response);
  }

  Future<MedicalTrackDetailsModel> fetchMedicalTrackDetailsData({String? token, String? claimId}) async {
    final response = await _provider.getWithHeader('profile/info/medical/detail?claimId=' + claimId!, token!); //api_medical_track_details
    // debugPrint('medical_track details $response');
    return MedicalTrackDetailsModel.fromJson(response);
  }

  Future<MedicalResponseModel> applyAttendanceData({String? token, Map? body}) async {
    final response = await _provider.postWithHeader('profile/medical/attendance', token!, body: body); //api_apply_medical_attendance
    // debugPrint('apply_medical_attendance $response');
    return MedicalResponseModel.fromJson(response);
  }
}