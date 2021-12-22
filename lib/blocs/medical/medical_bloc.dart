import 'package:flutter/material.dart';
import 'package:myveteran/core/models/medical/medical_track_details_model.dart';
import 'package:myveteran/core/models/medical/medical_track_list_model.dart';
import 'dart:async';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/core/services/medical/medical_service.dart';

class MedicalBloc {
  MedicalService? _medicalService;
  final _resultControllerTrack = StreamController<Response<MedicalTrackListModel>>();
  final _resultControllerTrackDetails = StreamController<Response<MedicalTrackDetailsModel>>();
  final _resultControllerResponse = StreamController<Response<MedicalResponseModel>>();

  StreamSink<Response<MedicalTrackListModel>> get resultSink => _resultControllerTrack.sink;
  Stream<Response<MedicalTrackListModel?>> get resultStream => _resultControllerTrack.stream;

  StreamSink<Response<MedicalTrackDetailsModel>> get resultSinkTrackDetails => _resultControllerTrackDetails.sink;
  Stream<Response<MedicalTrackDetailsModel?>> get resultStreamTrackDetails => _resultControllerTrackDetails.stream;

  StreamSink<Response<MedicalResponseModel>> get resultSinkResponse => _resultControllerResponse.sink;
  Stream<Response<MedicalResponseModel?>> get resultStreamResponse => _resultControllerResponse.stream;

  MedicalBloc() {
    _medicalService = MedicalService();
  }

  loadMedicalTrackList({String? token}) async {
    resultSink.add(Response.loading('Getting record...'));
    try {
      MedicalTrackListModel record = await _medicalService!.fetchMedicalTrackListData(token: token);
      resultSink.add(Response.completed(record));
    } catch (e) {
      resultSink.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  loadMedicalTrackDetails({String? token, String? claimId}) async {
    resultSinkTrackDetails.add(Response.loading('Getting record...'));
    try {
      MedicalTrackDetailsModel record = await _medicalService!.fetchMedicalTrackDetailsData(token: token, claimId: claimId);
      resultSinkTrackDetails.add(Response.completed(record));
    } catch (e) {
      resultSinkTrackDetails.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  applyAttendance({String? token, Map? body}) async {
    resultSinkResponse.add(Response.loading('Create record...'));
    try {
      MedicalResponseModel record = await _medicalService!.applyAttendanceData(token: token, body: body);
      resultSinkResponse.add(Response.completed(record));
    } catch (e) {
      resultSinkResponse.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  dispose() {
    _resultControllerTrack.close();
    _resultControllerTrackDetails.close();
    _resultControllerResponse.close();
  }
}