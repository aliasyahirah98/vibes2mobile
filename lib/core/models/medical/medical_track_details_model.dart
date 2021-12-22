class MedicalTrackDetailsModel {
  int? claimID;
  String? claimTypeCode;
  String? claimItemType;
  String? claimApplNo;
  String? claimPersonIdentidyID;
  String? claimRegistraterDate;
  String? claimPatientsFullName;
  String? claimPatientsIdentidyID;
  String? claimPatientsRelationship;
  String? claimChildIndicator;
  String? claimChildYears;
  String? claimChildMonth;
  String? claimPatientsIsPoor;
  String? claimPatientsIsStudent;
  String? claimHospitalName;
  String? claimHospitalAddressID;
  String? claimTreatmentDate;
  String? claimSupplierID;
  String? claimSupplierName;
  String? claimFacilitiesReceiveDate;
  String? claimBankName;
  String? claimBankNo;
  double? claimTotal;
  double? claimTotalApproved;
  String? claimStatus;
  String? claimRemarks;
  String? claimCreateBy;
  String? claimCreatedDate;
  String? claimModifiedBy;
  String? claimModifiedDate;
  String? claimApproveBy;
  String? claimApproveDate;
  String? claimRejectBy;
  String? claimRejectDate;
  String? personIdentidyName;
  String? personMilitaryNo;
  String? userNo;
  int? returnCode;
  String? responseMessage;
 
  MedicalTrackDetailsModel(
    {
      this.claimID,
      this.claimTypeCode,
      this.claimItemType,
      this.claimApplNo,
      this.claimPersonIdentidyID,
      this.claimRegistraterDate,
      this.claimPatientsFullName,
      this.claimPatientsIdentidyID,
      this.claimPatientsRelationship,
      this.claimChildIndicator,
      this.claimChildYears,
      this.claimChildMonth,
      this.claimPatientsIsPoor,
      this.claimPatientsIsStudent,
      this.claimHospitalName,
      this.claimHospitalAddressID,
      this.claimTreatmentDate,
      this.claimSupplierID,
      this.claimSupplierName,
      this.claimFacilitiesReceiveDate,
      this.claimBankName,
      this.claimBankNo,
      this.claimTotal,
      this.claimTotalApproved,
      this.claimStatus,
      this.claimRemarks,
      this.claimCreateBy,
      this.claimCreatedDate,
      this.claimModifiedBy,
      this.claimModifiedDate,
      this.claimApproveBy,
      this.claimApproveDate,
      this.claimRejectBy,
      this.claimRejectDate,
      this.personIdentidyName,
      this.personMilitaryNo,
      this.userNo,
      this.returnCode,
      this.responseMessage
    }
  );

  static listFromJson(List<dynamic> listJson) {
    List<MedicalTrackDetailsModel> data = [];
    for (var value in listJson) {
      data.add(MedicalTrackDetailsModel.fromJson(value));
    }
    return data;
  }

  factory MedicalTrackDetailsModel.fromJson(Map<String, dynamic> objJson) {
    return MedicalTrackDetailsModel(
      claimID: objJson['ClaimID'] ?? 0,
      claimTypeCode: objJson['ClaimTypeCode'] ?? '-',
      claimItemType: objJson['ClaimItemType'] ?? '-',
      claimApplNo: objJson['ClaimApplNo'] ?? '-',
      claimPersonIdentidyID: objJson['ClaimPersonIdentidyID'] ?? '-',
      claimRegistraterDate: objJson['ClaimRegistraterDate'] ?? '-',
      claimPatientsFullName: objJson['ClaimPatientsFullName'] ?? '-',
      claimPatientsIdentidyID: objJson['ClaimPatientsIdentidyID'] ?? '-',
      claimPatientsRelationship: objJson['ClaimPatientsRelationship'] ?? '-',
      claimChildIndicator: objJson['ClaimChildIndicator'] ?? '-',
      claimChildYears: objJson['ClaimChildYears'] ?? '-',
      claimChildMonth: objJson['ClaimChildMonth'] ?? '-',
      claimPatientsIsPoor: objJson['ClaimPatientsIsPoor'] ?? '-',
      claimPatientsIsStudent: objJson['ClaimPatientsIsStudent'] ?? '-',
      claimHospitalName: objJson['ClaimHospitalName'] ?? '-',
      claimHospitalAddressID: objJson['ClaimHospitalAddressID'] ?? '-',
      claimTreatmentDate: objJson['ClaimTreatmentDate'] ?? '-',
      claimSupplierID: objJson['ClaimSupplierID'] ?? '-',
      claimSupplierName: objJson['ClaimSupplierName'] ?? '-',
      claimFacilitiesReceiveDate: objJson['ClaimFacilitiesReceiveDate'] ?? '-',
      claimBankName: objJson['ClaimBankName'] ?? '-',
      claimBankNo: objJson['ClaimBankNo'] ?? '-',
      claimTotal: objJson['ClaimTotal'] ?? 0.0,
      claimTotalApproved: objJson['ClaimTotalApproved'] ?? 0.0,
      claimStatus: objJson['ClaimStatus'] ?? '-',
      claimRemarks: objJson['ClaimRemarks'] ?? '-',
      claimCreateBy: objJson['ClaimCreateBy'] ?? '-',
      claimCreatedDate: objJson['ClaimCreatedDate'] ?? '-',
      claimModifiedBy: objJson['ClaimModifiedBy'] ?? '-',
      claimModifiedDate: objJson['ClaimModifiedDate'] ?? '-',
      claimApproveBy: objJson['ClaimApproveBy'] ?? '-',
      claimApproveDate: objJson['ClaimApproveDate'] ?? '-',
      claimRejectBy: objJson['ClaimRejectBy'] ?? '-',
      claimRejectDate: objJson['ClaimRejectDate'] ?? '-',
      personIdentidyName: objJson['PersonIdentidyName'] ?? '-',
      personMilitaryNo: objJson['PersonMilitaryNo'] ?? '-',
      userNo: objJson['UserNo'] ?? '-',
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}