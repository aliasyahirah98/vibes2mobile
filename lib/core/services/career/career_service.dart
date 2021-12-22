import 'dart:async';
import 'package:myveteran/core/models/career/career_details_model.dart';
import 'package:myveteran/core/models/career/career_list_model.dart';
import 'package:myveteran/core/models/career/career_track_details_model.dart';
import 'package:myveteran/core/models/career/career_track_list_model.dart';
import 'package:myveteran/core/provider/api_sync.dart';
// import 'package:flutter/material.dart';

class CareerService {
  final ApiSync _provider = ApiSync();

  Future<CareerListModel> fetchCareerListData({String? token}) async {
    final response = await _provider.getWithHeader('profile/info/job/list', token!); //api_career_list
    // debugPrint('career $response');
    return CareerListModel.fromJson(response);
  }

  Future<CareerDetailsModel> fetchCareerDetailsData({String? token, String? jobId}) async {
    final response = await _provider.getWithHeader('profile/info/job/details?jobId=' + jobId!, token!); //api_career_details
    // debugPrint('career details $response');
    return CareerDetailsModel.fromJson(response);
  }

  Future<CareerTrackListModel> fetchCareerTrackListData({String? token, String? myKad}) async {
    final response = await _provider.getWithHeader('profile/info/job/semakan/list?myKad=' + myKad!, token!); //api_career_track_list
    // debugPrint('career_track $response');
    return CareerTrackListModel.fromJson(response);
  }

  Future<CareerTrackDetailsModel> fetchCareerTrackDetailsData({String? token, String? applyJobNo}) async {
    final response = await _provider.getWithHeader('profile/info/job/semakan/details?applyJobNo=' + applyJobNo!, token!); //api_career_track_details
    // debugPrint('career_track details $response');
    return CareerTrackDetailsModel.fromJson(response);
  }

  Future<CareerResponseModel> applyCareerData({String? token, Map? body}) async {
    final response = await _provider.postWithHeader('profile/job/application', token!, body: body); //api_apply_career
    // debugPrint('apply_career $response');
    return CareerResponseModel.fromJson(response);
  }
}