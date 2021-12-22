import 'dart:async';
import 'package:myveteran/core/models/calendar/calendar_model.dart';
import 'package:myveteran/core/provider/api_sync.dart';
// import 'package:flutter/material.dart';

class CalendarService {
  final ApiSync _provider = ApiSync();

  Future<CalendarModel> fetchCalendarData({String? token, String? month, String? year}) async {
    final response = await _provider.getWithHeader('profile/info/calendar/list?selectedMonth=' + month! + '&selectedYear=' + year!, token!); //api_calendar_list
    // debugPrint('calendar $response');
    return CalendarModel.fromJson(response);
  }
}