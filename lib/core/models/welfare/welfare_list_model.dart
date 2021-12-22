class WelfareListModel {
  List<WelfareInfoModel>? welfareList;
  int? returnCode;
  String? responseMessage;

  WelfareListModel(
    {
      this.welfareList,
      this.returnCode,
      this.responseMessage
    }
  );

  factory WelfareListModel.fromJson(Map<String, dynamic> objJson) {
    return WelfareListModel(
      welfareList: objJson['list'] != null ? WelfareInfoModel.listFromJson(objJson['list']) : [],
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}

class WelfareInfoModel {
  int? bKAppId;
  String? bKAppCode;
  String? bKAppSubmittedDate;
  int? bKAppStatus;
  String? bKAppStatusName;
  String? bKAppType;
  String? bKAppTypeName;
 
  WelfareInfoModel(
    {
      this.bKAppId,
      this.bKAppCode,
      this.bKAppSubmittedDate,
      this.bKAppStatus,
      this.bKAppStatusName,
      this.bKAppType,
      this.bKAppTypeName,
    }
  );

  static listFromJson(List<dynamic> listJson) {
    List<WelfareInfoModel> data = [];
    for (var value in listJson) {
      data.add(WelfareInfoModel.fromJson(value));
    }
    return data;
  }

  factory WelfareInfoModel.fromJson(Map<String, dynamic> objJson) {
    return WelfareInfoModel(
      bKAppId: objJson['BKAppId'] ?? 0,
      bKAppCode: objJson['BKAppCode'] ?? '-',
      bKAppSubmittedDate: objJson['BKAppSubmittedDate'] ?? '-',
      bKAppStatus: objJson['BKAppStatus'] ?? 0,
      bKAppStatusName: objJson['BKAppStatusName'] ?? '-',
      bKAppType: objJson['BKAppType'] ?? '-',
      bKAppTypeName: objJson['BKAppTypeName'] ?? '-'
    );
  }
}