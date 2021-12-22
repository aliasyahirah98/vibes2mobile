import 'package:flutter/material.dart';
import 'package:myveteran/core/models/welfare/welfare_details_model.dart';
import 'package:myveteran/core/models/welfare/welfare_list_model.dart';
import 'dart:async';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/core/services/welfare/welfare_service.dart';

class WelfareBloc {
  WelfareService? _welfareService;
  final _resultController = StreamController<Response<WelfareListModel>>();
  final _resultControllerDetails = StreamController<Response<WelfareDetailsModel>>();

  StreamSink<Response<WelfareListModel>> get resultSink => _resultController.sink;
  Stream<Response<WelfareListModel?>> get resultStream => _resultController.stream;

  StreamSink<Response<WelfareDetailsModel>> get resultSinkDetails => _resultControllerDetails.sink;
  Stream<Response<WelfareDetailsModel?>> get resultStreamDetails => _resultControllerDetails.stream;

  WelfareBloc() {
    _welfareService = WelfareService();
  }

  loadWelfareList({String? token, String? myKadNo}) async {
    resultSink.add(Response.loading('Getting record...'));
    try {
      WelfareListModel record = await _welfareService!.fetchWelfareListData(token: token, myKadNo: myKadNo);
      resultSink.add(Response.completed(record));
    } catch (e) {
      resultSink.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  loadWelfareDetails({String? token, String? bKAppCode}) async {
    resultSinkDetails.add(Response.loading('Getting record...'));
    try {
      WelfareDetailsModel record = await _welfareService!.fetchWelfareDetailsData(token: token, bKAppCode: bKAppCode);
      resultSinkDetails.add(Response.completed(record));
    } catch (e) {
      resultSinkDetails.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  dispose() {
    _resultController.close();
    _resultControllerDetails.close();
  }
}