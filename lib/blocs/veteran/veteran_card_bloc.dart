import 'package:flutter/material.dart';
import 'package:myveteran/core/models/veteran/veteran_card_model.dart';
import 'dart:async';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/core/services/veteran/veteran_card_service.dart';

class VeteranCardBloc {
  VeteranCardService? _veteranCardService;
  final _resultController = StreamController<Response<VeteranCardModel>>();

  StreamSink<Response<VeteranCardModel>> get resultSink => _resultController.sink;
  Stream<Response<VeteranCardModel?>> get resultStream => _resultController.stream;

  VeteranCardBloc() {
    _veteranCardService = VeteranCardService();
  }

  loadVeteranCard({String? token}) async {
    resultSink.add(Response.loading('Getting record...'));
    try {
      VeteranCardModel record = await _veteranCardService!.fetchVeteranCardData(token: token);
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