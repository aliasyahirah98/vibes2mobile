import 'package:flutter/material.dart';
import 'package:myveteran/core/models/career/career_details_model.dart';
import 'package:myveteran/core/models/career/career_list_model.dart';
import 'package:myveteran/core/models/career/career_track_details_model.dart';
import 'package:myveteran/core/models/career/career_track_list_model.dart';
import 'dart:async';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/core/services/career/career_service.dart';

class CareerBloc {
  CareerService? _careerService;
  final _resultController = StreamController<Response<CareerListModel>>();
  final _resultControllerDetails = StreamController<Response<CareerDetailsModel>>();
  final _resultControllerTrack = StreamController<Response<CareerTrackListModel>>();
  final _resultControllerTrackDetails = StreamController<Response<CareerTrackDetailsModel>>();
  final _resultControllerResponse = StreamController<Response<CareerResponseModel>>();

  StreamSink<Response<CareerListModel>> get resultSink => _resultController.sink;
  Stream<Response<CareerListModel?>> get resultStream => _resultController.stream;

  StreamSink<Response<CareerDetailsModel>> get resultSinkDetails => _resultControllerDetails.sink;
  Stream<Response<CareerDetailsModel?>> get resultStreamDetails => _resultControllerDetails.stream;

  StreamSink<Response<CareerTrackListModel>> get resultSinkTrack => _resultControllerTrack.sink;
  Stream<Response<CareerTrackListModel?>> get resultStreamTrack => _resultControllerTrack.stream;

  StreamSink<Response<CareerTrackDetailsModel>> get resultSinkTrackDetails => _resultControllerTrackDetails.sink;
  Stream<Response<CareerTrackDetailsModel?>> get resultStreamTrackDetails => _resultControllerTrackDetails.stream;

  StreamSink<Response<CareerResponseModel>> get resultSinkResponse => _resultControllerResponse.sink;
  Stream<Response<CareerResponseModel?>> get resultStreamResponse => _resultControllerResponse.stream;

  CareerBloc() {
    _careerService = CareerService();
  }

  loadCareerList({String? token}) async {
    resultSink.add(Response.loading('Getting record...'));
    try {
      CareerListModel record = await _careerService!.fetchCareerListData(token: token);
      resultSink.add(Response.completed(record));
    } catch (e) {
      resultSink.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  loadCareerDetails({String? token, String? jobId}) async {
    resultSinkDetails.add(Response.loading('Getting record...'));
    try {
      CareerDetailsModel record = await _careerService!.fetchCareerDetailsData(token: token, jobId: jobId);
      resultSinkDetails.add(Response.completed(record));
    } catch (e) {
      resultSinkDetails.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  loadCareerTrackList({String? token, String? myKad}) async {
    resultSinkTrack.add(Response.loading('Getting record...'));
    try {
      CareerTrackListModel record = await _careerService!.fetchCareerTrackListData(token: token, myKad: myKad);
      resultSinkTrack.add(Response.completed(record));
    } catch (e) {
      resultSinkTrack.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  loadCareerTrackDetails({String? token, String? applyJobNo}) async {
    resultSinkTrackDetails.add(Response.loading('Getting record...'));
    try {
      CareerTrackDetailsModel record = await _careerService!.fetchCareerTrackDetailsData(token: token, applyJobNo: applyJobNo);
      resultSinkTrackDetails.add(Response.completed(record));
    } catch (e) {
      resultSinkTrackDetails.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  applyCareer({String? token, Map? body}) async {
    resultSinkResponse.add(Response.loading('Create record...'));
    try {
      CareerResponseModel record = await _careerService!.applyCareerData(token: token, body: body);
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