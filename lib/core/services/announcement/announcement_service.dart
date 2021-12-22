import 'dart:async';
import 'package:myveteran/core/models/announcement/announcement_details_model.dart';
import 'package:myveteran/core/models/announcement/announcement_model.dart';
import 'package:myveteran/core/provider/api_sync.dart';
// import 'package:flutter/material.dart';

class AnnouncementService {
  final ApiSync _provider = ApiSync();

  Future<AnnouncementModel> fetchAnnouncementData({String? token}) async {
    final response = await _provider.getWithHeader('profile/info/announcement/list', token!); //api_announcement_list
    // debugPrint('announcement $response');
    return AnnouncementModel.fromJson(response);
  }

  Future<AnnouncementDetailsModel> fetchAnnouncementDetailsData({String? token, String? contentId}) async {
    final response = await _provider.getWithHeader('profile/info/announcement/details?contentId=' + contentId!, token!); //api_announcement_details
    // debugPrint('announcement details $response');
    return AnnouncementDetailsModel.fromJson(response);
  }
}