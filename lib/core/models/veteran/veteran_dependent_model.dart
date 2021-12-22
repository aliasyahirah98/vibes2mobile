class VeteranDependentModel {
  List<VeteranDependentInfoModel>? spouse;
  List<VeteranDependentInfoModel>? parent;
  List<VeteranDependentInfoModel>? children;
  int? returnCode;
  String? responseMessage;

  VeteranDependentModel(
    {
      this.spouse,
      this.parent,
      this.children,
      this.returnCode,
      this.responseMessage
    }
  );

  factory VeteranDependentModel.fromJson(Map<String, dynamic> objJson) {
    return VeteranDependentModel(
      spouse: VeteranDependentInfoModel.listFromJson(objJson['spouseInfo']),
      parent: VeteranDependentInfoModel.listFromJson(objJson['parentInfo']),
      children: VeteranDependentInfoModel.listFromJson(objJson['childrenInfo']),
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}

class VeteranDependentInfoModel {
  String? name;
  String? icNo;
  String? relationship;
 
  VeteranDependentInfoModel({
    this.name,
    this.icNo,
    this.relationship
  });

  static listFromJson(List<dynamic> listJson) {
    List<VeteranDependentInfoModel> data = [];
    for (var value in listJson) {
      data.add(VeteranDependentInfoModel.fromJson(value));
    }
    return data;
  }
 
  factory VeteranDependentInfoModel.fromJson(Map<String, dynamic> objJson) {
    return VeteranDependentInfoModel(
      name: objJson["Name"] ?? '-',
      icNo: objJson["MyKad"] ?? '-',
      relationship: objJson["Relationship"] ?? '-'
    );
  }
}
