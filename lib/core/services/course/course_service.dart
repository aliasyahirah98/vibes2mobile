import 'dart:async';
import 'package:myveteran/core/models/course/course_details_model.dart';
import 'package:myveteran/core/models/course/course_list_model.dart';
import 'package:myveteran/core/models/course/course_track_details_model.dart';
import 'package:myveteran/core/models/course/course_track_list_model.dart';
import 'package:myveteran/core/provider/api_sync.dart';
// import 'package:flutter/material.dart';

class CourseService {
  final ApiSync _provider = ApiSync();

  Future<CourseListModel> fetchCourseListData({String? token}) async {
    final response = await _provider.getWithHeader('profile/info/course/list', token!); //api_course_list
    // debugPrint('course $response');
    return CourseListModel.fromJson(response);
  }

  Future<CourseDetailsModel> fetchCourseDetailsData({String? token, String? courseNo}) async {
    final response = await _provider.getWithHeader('profile/info/course/details?courseNo=' + courseNo!, token!); //api_course_details
    // debugPrint('course details $response');
    return CourseDetailsModel.fromJson(response);
  }

  Future<CourseTrackListModel> fetchCourseTrackListData({String? token, String? myKad}) async {
    final response = await _provider.getWithHeader('profile/info/course/semakan/list?myKad=' + myKad!, token!); //api_course_track_list
    // debugPrint('course_track $response');
    return CourseTrackListModel.fromJson(response);
  }

  Future<CourseTrackDetailsModel> fetchCourseTrackDetailsData({String? token, String? courseNo}) async {
    final response = await _provider.getWithHeader('profile/info/course/semakan/details?courseNo=' + courseNo!, token!); //api_course_track_details
    // debugPrint('course_track details $response');
    return CourseTrackDetailsModel.fromJson(response);
  }

  Future<CourseResponseModel> applyCourseData({String? token, Map? body}) async {
    final response = await _provider.postWithHeader('profile/course/application', token!, body: body); //api_apply_course
    // debugPrint('apply_course $response');
    return CourseResponseModel.fromJson(response);
  }
}