import 'package:flutter/material.dart';
import 'package:myveteran/core/models/calendar/calendar_model.dart';
import 'dart:async';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/core/services/calendar/calendar_service.dart';

class CalendarBloc {
  CalendarService? _calendarService;
  final _resultController = StreamController<Response<CalendarModel>>();

  StreamSink<Response<CalendarModel>> get resultSink => _resultController.sink;
  Stream<Response<CalendarModel?>> get resultStream => _resultController.stream;

  CalendarBloc() {
    _calendarService = CalendarService();
  }

  loadCalendar({String? token, String? month, String? year}) async {
    resultSink.add(Response.loading('Getting record...'));
    try {
      CalendarModel record = await _calendarService!.fetchCalendarData(token: token, month: month, year: year);
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