import 'package:flutter/material.dart';
import 'package:myveteran/core/models/announcement/announcement_details_model.dart';
import 'package:myveteran/core/models/announcement/announcement_model.dart';
import 'dart:async';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/core/services/announcement/announcement_service.dart';

class AnnouncementBloc {
  AnnouncementService? _announcementService;
  final _resultController = StreamController<Response<AnnouncementModel>>();
  final _resultControllerDetails = StreamController<Response<AnnouncementDetailsModel>>();

  StreamSink<Response<AnnouncementModel>> get resultSink => _resultController.sink;
  Stream<Response<AnnouncementModel?>> get resultStream => _resultController.stream;

  StreamSink<Response<AnnouncementDetailsModel>> get resultSinkDetails => _resultControllerDetails.sink;
  Stream<Response<AnnouncementDetailsModel?>> get resultStreamDetails => _resultControllerDetails.stream;

  AnnouncementBloc() {
    _announcementService = AnnouncementService();
  }

  loadAnnouncement({String? token}) async {
    resultSink.add(Response.loading('Getting record...'));
    try {
      AnnouncementModel record = await _announcementService!.fetchAnnouncementData(token: token);
      resultSink.add(Response.completed(record));
    } catch (e) {
      resultSink.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  loadAnnouncementDetails({String? token, String? contentId}) async {
    resultSinkDetails.add(Response.loading('Getting record...'));
    try {
      AnnouncementDetailsModel record = await _announcementService!.fetchAnnouncementDetailsData(token: token, contentId: contentId);
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