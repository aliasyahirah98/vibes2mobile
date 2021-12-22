import 'package:flutter/material.dart';
import 'package:myveteran/core/models/veteran/veteran_education_model.dart';
import 'dart:async';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/core/services/veteran/veteran_education_service.dart';

class VeteranEducationBloc {
  VeteranEducationService? _veteranEducationService;
  final _resultController = StreamController<Response<VeteranEducationModel>>();
  final _resultControllerResponse = StreamController<Response<VeteranEducationResponseModel>>();

  StreamSink<Response<VeteranEducationModel>> get resultSink => _resultController.sink;
  Stream<Response<VeteranEducationModel?>> get resultStream => _resultController.stream;

  StreamSink<Response<VeteranEducationResponseModel>> get resultSinkResponse => _resultControllerResponse.sink;
  Stream<Response<VeteranEducationResponseModel?>> get resultStreamResponse => _resultControllerResponse.stream;

  VeteranEducationBloc() {
    _veteranEducationService = VeteranEducationService();
  }

  loadVeteranEducation({String? token}) async {
    resultSink.add(Response.loading('Getting record...'));
    try {
      VeteranEducationModel record = await _veteranEducationService!.fetchVeteranEducationData(token: token);
      resultSink.add(Response.completed(record));
    } catch (e) {
      resultSink.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  updateVeteranEducation({String? token, Map? body}) async {
    resultSinkResponse.add(Response.loading('Create record...'));
    try {
      VeteranEducationResponseModel record = await _veteranEducationService!.updateVeteranEducationData(token: token, body: body);
      resultSinkResponse.add(Response.completed(record));
    } catch (e) {
      resultSinkResponse.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  dispose() {
    _resultController.close();
    _resultControllerResponse.close();
  }
}