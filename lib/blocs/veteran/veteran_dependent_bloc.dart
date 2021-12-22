import 'package:flutter/material.dart';
import 'package:myveteran/core/models/veteran/veteran_dependent_model.dart';
import 'dart:async';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/core/services/veteran/veteran_dependent_service.dart';

class VeteranDependentBloc {
  VeteranDependentService? _veteranDependentService;
  final _resultController = StreamController<Response<VeteranDependentModel>>();

  StreamSink<Response<VeteranDependentModel>> get resultSink => _resultController.sink;
  Stream<Response<VeteranDependentModel?>> get resultStream => _resultController.stream;

  VeteranDependentBloc() {
    _veteranDependentService = VeteranDependentService();
  }

  loadVeteranDependent({String? token}) async {
    resultSink.add(Response.loading('Getting record...'));
    try {
      VeteranDependentModel record = await _veteranDependentService!.fetchVeteranDependentData(token: token);
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