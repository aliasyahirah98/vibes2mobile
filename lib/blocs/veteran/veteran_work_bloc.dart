import 'package:flutter/material.dart';
import 'dart:async';
import 'package:myveteran/core/models/veteran/veteran_work_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/core/services/veteran/veteran_work_service.dart';

class VeteranWorkBloc {
  VeteranWorkService? _veteranWorkService;
  final _resultController = StreamController<Response<VeteranWorkModel>>();

  StreamSink<Response<VeteranWorkModel>> get resultSink => _resultController.sink;
  Stream<Response<VeteranWorkModel?>> get resultStream => _resultController.stream;

  VeteranWorkBloc() {
    _veteranWorkService = VeteranWorkService();
  }

  loadVeteranWork({String? token}) async {
    resultSink.add(Response.loading('Getting record...'));
    try {
      VeteranWorkModel record = await _veteranWorkService!.fetchVeteranWorkData(token: token);
      resultSink.add(Response.completed(record));
    } catch (e) {
      resultSink.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  dispose() {
    _resultController.close();
  }
}