class UserModel {
  String? userNo;
  String? personIdentidyID;
  String? personIdentidyName;
  String? personMilitaryNo;
  String? personStatus;
  String? personPhoneNo;
  String? personPhoneNo2;
  String? personEmail;
  String? userType;
  int? returnCode;
  String? responseMessage;

  UserModel(
    {
      this.userNo,
      this.personIdentidyID,
      this.personIdentidyName,
      this.personMilitaryNo,
      this.personStatus,
      this.personPhoneNo,
      this.personPhoneNo2,
      this.personEmail,
      this.userType,
      this.returnCode,
      this.responseMessage
    }
  );

  factory UserModel.fromJson(Map<String, dynamic> objJson) {
    return UserModel(
      userNo: objJson['UserNo'],
      personIdentidyID: objJson['PersonIdentidyID'],
      personIdentidyName: objJson['PersonIdentidyName'],
      personMilitaryNo: objJson['PersonMilitaryNo'],
      personStatus: objJson['PersonStatus'],
      personPhoneNo: objJson['PersonPhoneNo'],
      personPhoneNo2: objJson['PersonPhoneNo2'],
      personEmail: objJson['PersonEmail'],
      userType: objJson['UserType'],
      returnCode: objJson['ReturnCode'],
      responseMessage: objJson['ResponseMessage']
    );
  }
}

class UserResponseModel {
  dynamic result;
  int? returnCode;
  String? responseMessage;

  UserResponseModel(
    {
      this.result,
      this.returnCode,
      this.responseMessage
    }
  );

  factory UserResponseModel.fromJson(Map<String, dynamic> objJson) {
    return UserResponseModel(
      result: objJson['Result'] ?? [],
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}

class UserVerifyModel {
  String? personName;
  String? personEmail;
  String? personPhoneNo;
  String? personMykad;
  String? relationship;
  int? returnCode;
  String? responseMessage;

  UserVerifyModel(
    {
      this.personName,
      this.personEmail,
      this.personPhoneNo,
      this.personMykad,
      this.relationship,
      this.returnCode,
      this.responseMessage
    }
  );

  factory UserVerifyModel.fromJson(Map<String, dynamic> objJson) {
    return UserVerifyModel(
      personName: objJson['PersonName'] ?? '-',
      personEmail: objJson['PersonEmail'] ?? '-',
      personPhoneNo: objJson['PersonPhoneNo'] ?? '-',
      personMykad: objJson['PersonMykad'] ?? '-',
      relationship: objJson['Relationship'] ?? '-',
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}