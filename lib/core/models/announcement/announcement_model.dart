class AnnouncementModel {
  List<AnnouncementInfoModel>? announcementList;
  int? returnCode;
  String? responseMessage;

  AnnouncementModel(
    {
      this.announcementList,
      this.returnCode,
      this.responseMessage
    }
  );

  factory AnnouncementModel.fromJson(Map<String, dynamic> objJson) {
    return AnnouncementModel(
      announcementList: objJson['list'] != null ? AnnouncementInfoModel.listFromJson(objJson['list']) : [],
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}

class AnnouncementInfoModel {
  int? contentId;
  String? contentName;
  String? contentSubject;
  String? contentFileUpload1;
  String? contentStartDate;
 
  AnnouncementInfoModel(
    {
      this.contentId,
      this.contentName,
      this.contentSubject,
      this.contentFileUpload1,
      this.contentStartDate
    }
  );

  static listFromJson(List<dynamic> listJson) {
    List<AnnouncementInfoModel> data = [];
    for (var value in listJson) {
      data.add(AnnouncementInfoModel.fromJson(value));
    }
    return data;
  }

  factory AnnouncementInfoModel.fromJson(Map<String, dynamic> objJson) {
    return AnnouncementInfoModel(
      contentId: objJson['ContentId'] ?? 0,
      contentName: objJson['ContentName'] ?? '-',
      contentSubject: objJson['ContentSubject'] ?? '-',
      contentFileUpload1: objJson['ContentFileUpload1'] ?? '',
      contentStartDate: objJson['ContentStartDate'] ?? '-'
    );
  }
}