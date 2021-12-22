class BmjTrackListModel {
  List<BmjTrackInfoModel>? bmjTrackList;
  int? returnCode;
  String? responseMessage;

  BmjTrackListModel(
    {
      this.bmjTrackList,
      this.returnCode,
      this.responseMessage
    }
  );

  factory BmjTrackListModel.fromJson(Map<String, dynamic> objJson) {
    return BmjTrackListModel(
      bmjTrackList: objJson['list'] != null ? BmjTrackInfoModel.listFromJson(objJson['list']) : [],
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}

class BmjTrackInfoModel {
  String? applicationNo;
  String? applicationName;
  String? applicationStatusCode;
  String? applicationType;
  String? deceasedName;
  String? deceasedMyKad;
  String? deceasedBirthDate;
  String? deceasedAge;
  String? deceasedRace;
  String? deceasedGender;
  String? deathDate;
  String? deathCertNo;
  String? applicationDate;
 
  BmjTrackInfoModel(
    {
      this.applicationNo,
      this.applicationName,
      this.applicationStatusCode,
      this.applicationType,
      this.deceasedName,
      this.deceasedMyKad,
      this.deceasedBirthDate,
      this.deceasedAge,
      this.deceasedRace,
      this.deceasedGender,
      this.deathDate,
      this.deathCertNo,
      this.applicationDate
    }
  );

  static listFromJson(List<dynamic> listJson) {
    List<BmjTrackInfoModel> data = [];
    for (var value in listJson) {
      data.add(BmjTrackInfoModel.fromJson(value));
    }
    return data;
  }

  factory BmjTrackInfoModel.fromJson(Map<String, dynamic> objJson) {
    return BmjTrackInfoModel(
      applicationNo: objJson['NoPermohonan'] ?? '-',
      applicationName: objJson['ApplicationName'] ?? '-',
      applicationStatusCode: objJson['ApplicationStatusCode'] ?? '-',
      applicationType: objJson['ApplicationType'] ?? '-',
      deceasedName: objJson['DeceasedName'] ?? '-',
      deceasedMyKad: objJson['DeceasedMyKad'] ?? '-',
      deceasedBirthDate: objJson['DeceasedBirthDate'] ?? '-',
      deceasedAge: objJson['DeceasedAge'] ?? '-',
      deceasedRace: objJson['DeceasedRace'] ?? '-',
      deceasedGender: objJson['DeceasedGender'] ?? '-',
      deathDate: objJson['DeathDate'] ?? '-',
      deathCertNo: objJson['DeathCertNo'] ?? '-',
      applicationDate: objJson['ApplicationDate'] ?? '-'
    );
  }
}