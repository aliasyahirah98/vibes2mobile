import 'package:flutter/material.dart';
import 'package:myveteran/core/models/course/course_details_model.dart';
import 'package:myveteran/core/models/course/course_list_model.dart';
import 'package:myveteran/core/models/course/course_track_details_model.dart';
import 'package:myveteran/core/models/course/course_track_list_model.dart';
import 'dart:async';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/core/services/course/course_service.dart';

class CourseBloc {
  CourseService? _courseService;
  final _resultController = StreamController<Response<CourseListModel>>();
  final _resultControllerDetails = StreamController<Response<CourseDetailsModel>>();
  final _resultControllerTrack = StreamController<Response<CourseTrackListModel>>();
  final _resultControllerTrackDetails = StreamController<Response<CourseTrackDetailsModel>>();
  final _resultControllerResponse = StreamController<Response<CourseResponseModel>>();

  StreamSink<Response<CourseListModel>> get resultSink => _resultController.sink;
  Stream<Response<CourseListModel?>> get resultStream => _resultController.stream;

  StreamSink<Response<CourseDetailsModel>> get resultSinkDetails => _resultControllerDetails.sink;
  Stream<Response<CourseDetailsModel?>> get resultStreamDetails => _resultControllerDetails.stream;

  StreamSink<Response<CourseTrackListModel>> get resultSinkTrack => _resultControllerTrack.sink;
  Stream<Response<CourseTrackListModel?>> get resultStreamTrack => _resultControllerTrack.stream;

  StreamSink<Response<CourseTrackDetailsModel>> get resultSinkTrackDetails => _resultControllerTrackDetails.sink;
  Stream<Response<CourseTrackDetailsModel?>> get resultStreamTrackDetails => _resultControllerTrackDetails.stream;

  StreamSink<Response<CourseResponseModel>> get resultSinkResponse => _resultControllerResponse.sink;
  Stream<Response<CourseResponseModel?>> get resultStreamResponse => _resultControllerResponse.stream;

  CourseBloc() {
    _courseService = CourseService();
  }

  loadCourseList({String? token}) async {
    resultSink.add(Response.loading('Getting record...'));
    try {
      CourseListModel record = await _courseService!.fetchCourseListData(token: token);
      resultSink.add(Response.completed(record));
    } catch (e) {
      resultSink.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  loadCourseDetails({String? token, String? courseNo}) async {
    resultSinkDetails.add(Response.loading('Getting record...'));
    try {
      CourseDetailsModel record = await _courseService!.fetchCourseDetailsData(token: token, courseNo: courseNo);
      resultSinkDetails.add(Response.completed(record));
    } catch (e) {
      resultSinkDetails.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  loadCourseTrackList({String? token, String? myKad}) async {
    resultSinkTrack.add(Response.loading('Getting record...'));
    try {
      CourseTrackListModel record = await _courseService!.fetchCourseTrackListData(token: token, myKad: myKad);
      resultSinkTrack.add(Response.completed(record));
    } catch (e) {
      resultSinkTrack.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  loadCourseTrackDetails({String? token, String? courseNo}) async {
    resultSinkTrackDetails.add(Response.loading('Getting record...'));
    try {
      CourseTrackDetailsModel record = await _courseService!.fetchCourseTrackDetailsData(token: token, courseNo: courseNo);
      resultSinkTrackDetails.add(Response.completed(record));
    } catch (e) {
      resultSinkTrackDetails.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  applyCourse({String? token, Map? body}) async {
    resultSinkResponse.add(Response.loading('Create record...'));
    try {
      CourseResponseModel record = await _courseService!.applyCourseData(token: token, body: body);
      resultSinkResponse.add(Response.completed(record));
    } catch (e) {
      resultSinkResponse.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  dispose() {
    _resultController.close();
    _resultControllerDetails.close();
    _resultControllerTrack.close();
    _resultControllerTrackDetails.close();
    _resultControllerResponse.close();
  }
}