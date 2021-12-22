class VeteranCardModel {
  String? veteranName;
  String? veteranMyKad;
  String? veteranMilitaryNo;
  String? veteranRank;
  String? veteranTTP;
  List<SpouseListModel>? spouseList;
  List<CardHistoryListModel>? cardHistoryList;
  int? returnCode;
  String? responseMessage;


  VeteranCardModel(
    {
      this.veteranName,
      this.veteranMyKad,
      this.veteranMilitaryNo,
      this.veteranRank,
      this.veteranTTP,
      this.spouseList,
      this.cardHistoryList,
      this.returnCode,
      this.responseMessage
    }
  );

  factory VeteranCardModel.fromJson(Map<String, dynamic> objJson) {
    return VeteranCardModel(
      veteranName: objJson['VeteranName'] ?? '-',
      veteranMyKad: objJson['VeteranMyKad'] ?? '-',
      veteranMilitaryNo: objJson['VeteranMilitaryNo'] ?? '-',
      veteranRank: objJson['VeteranRank'] ?? '-',
      veteranTTP: objJson['VeteranTTP'] ?? '-',
      spouseList: SpouseListModel.listFromJson(objJson['spouseList']),
      cardHistoryList: CardHistoryListModel.listFromJson(objJson['cardHistoryList']),
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}

class SpouseListModel {
  String? name;
 
  SpouseListModel({
    this.name
  });

  static listFromJson(List<dynamic> listJson) {
    List<SpouseListModel> data = [];
    for (var value in listJson) {
      data.add(SpouseListModel.fromJson(value));
    }
    return data;
  }

  factory SpouseListModel.fromJson(Map<String, dynamic> objJson) {
    return SpouseListModel(
      name: objJson['Name'] ?? '-'
    );
  }
}

class CardHistoryListModel {
  String? printedDate;
  String? issuingOffice;
  String? issuedBy;
  String? expiryDate;
 
  CardHistoryListModel({
    this.printedDate,
    this.issuingOffice,
    this.issuedBy,
    this.expiryDate
  });

  static listFromJson(List<dynamic> listJson) {
    List<CardHistoryListModel> data = [];
    for (var value in listJson) {
      data.add(CardHistoryListModel.fromJson(value));
    }
    return data;
  }

  factory CardHistoryListModel.fromJson(Map<String, dynamic> objJson) {
    return CardHistoryListModel(
      printedDate: objJson['PrintedDate'] ?? '-',
      issuingOffice: objJson['IssuingOffice'] ?? '-',
      issuedBy: objJson['IssuedBy'] ?? '-',
      expiryDate: objJson['ExpiryDate'] ?? '-'
    );
  }
}