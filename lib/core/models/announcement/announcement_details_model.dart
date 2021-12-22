class AnnouncementDetailsModel {
  int? contentId;
  String? contentName;
  String? contentSubject;
  String? contentDescription;
  String? contentFileUpload1;
  String? contentFileUpload2;
  String? contentStartDate;
  String? contentEndDate;
  int? returnCode;
  String? responseMessage;
 
  AnnouncementDetailsModel(
    {
      this.contentId,
      this.contentName,
      this.contentSubject,
      this.contentDescription,
      this.contentFileUpload1,
      this.contentFileUpload2,
      this.contentStartDate,
      this.contentEndDate,
      this.returnCode,
      this.responseMessage
    }
  );

  static listFromJson(List<dynamic> listJson) {
    List<AnnouncementDetailsModel> data = [];
    for (var value in listJson) {
      data.add(AnnouncementDetailsModel.fromJson(value));
    }
    return data;
  }

  factory AnnouncementDetailsModel.fromJson(Map<String, dynamic> objJson) {
    return AnnouncementDetailsModel(
      contentId: objJson['ContentId'] ?? 0,
      contentName: objJson['ContentName'] ?? '-',
      contentSubject: objJson['ContentSubject'] ?? '-',
      contentDescription: objJson['ContentDescription'] ?? '-',
      contentFileUpload1: objJson['ContentFileUpload1'] ?? '',
      contentFileUpload2: objJson['ContentFileUpload2'] ?? '',
      contentStartDate: objJson['ContentStartDate'] ?? '-',
      contentEndDate: objJson['ContentEndDate'] ?? '-',
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}