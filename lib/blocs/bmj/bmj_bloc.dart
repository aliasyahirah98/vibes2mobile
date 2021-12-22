import 'package:flutter/material.dart';
import 'package:myveteran/core/models/bmj/bmj_track_list_model.dart';
import 'dart:async';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/core/services/bmj/bmj_service.dart';

class BmjBloc {
  BmjService? _bmjService;
  final _resultControllerTrack = StreamController<Response<BmjTrackListModel>>();

  StreamSink<Response<BmjTrackListModel>> get resultSink => _resultControllerTrack.sink;
  Stream<Response<BmjTrackListModel?>> get resultStream => _resultControllerTrack.stream;

  BmjBloc() {
    _bmjService = BmjService();
  }

  loadBmjTrackList({String? token}) async {
    resultSink.add(Response.loading('Getting record...'));
    try {
      BmjTrackListModel record = await _bmjService!.fetchBmjTrackListData(token: token);
      resultSink.add(Response.completed(record));
    } catch (e) {
      resultSink.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  dispose() {
    _resultControllerTrack.close();
  }
}