class CalendarModel {
  List<CalendarInfoModel>? calendarList;
  int? returnCode;
  String? responseMessage;

  CalendarModel(
    {
      this.calendarList,
      this.returnCode,
      this.responseMessage
    }
  );

  factory CalendarModel.fromJson(Map<String, dynamic> objJson) {
    return CalendarModel(
      calendarList: objJson['list'] != null ? CalendarInfoModel.listFromJson(objJson['list']) : [],
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}

class CalendarInfoModel {
  int? contentId;
  String? contentType;
  String? contentCode;
  String? contentName;
  String? contentSubject;
  String? contentDescription;
  String? contentFileUpload1;
  String? contentFileUpload2;
  String? contentStartDate;
  String? contentEndDate;
  String? contentStatus;
  String? contentSort;
  String? contentColor;
 
  CalendarInfoModel(
    {
      this.contentId,
      this.contentType,
      this.contentCode,
      this.contentName,
      this.contentSubject,
      this.contentDescription,
      this.contentFileUpload1,
      this.contentFileUpload2,
      this.contentStartDate,
      this.contentEndDate,
      this.contentStatus,
      this.contentSort,
      this.contentColor,
    }
  );

  static listFromJson(List<dynamic> listJson) {
    List<CalendarInfoModel> data = [];
    for (var value in listJson) {
      data.add(CalendarInfoModel.fromJson(value));
    }
    return data;
  }

  factory CalendarInfoModel.fromJson(Map<String, dynamic> objJson) {
    return CalendarInfoModel(
      contentId: objJson['ContentId'] ?? 0,
      contentType: objJson['ContentType'] ?? '-',
      contentCode: objJson['ContentCode'] ?? '-',
      contentName: objJson['ContentName'] ?? '-',
      contentSubject: objJson['ContentSubject'] ?? '-',
      contentDescription: objJson['ContentDescription'] ?? '-',
      contentFileUpload1: objJson['ContentFileUpload1'] ?? '',
      contentFileUpload2: objJson['ContentFileUpload2'] ?? '',
      contentStartDate: objJson['ContentStartDate'] ?? '-',
      contentEndDate: objJson['ContentEndDate'] ?? '-',
      contentStatus: objJson['ContentStatus'] ?? '-',
      contentSort: objJson['ContentSort'] ?? '-',
      contentColor: objJson['ContentColor'] ?? '-'
    );
  }
}