class WelfareDetailsModel {
  int? bKAppId;
  String? bKAppCode;
  String? bKAppType;
  String? bKAppTypeName;
  String? bKAppSubmittedDate;
  String? bKAppStatus;
  String? bKAppStatusName;
  String? bKAppAplicantCategory;
  String? bKAppAplicantName;
  String? bKAppAplicantMykadNo;
  String? bKAppReceipientCategory;
  String? bKAppReceipientName;
  // String? bKAppReceiverMykad;
  String? bKAppReceipientCode;
  double? bKAppTotalAmount;
  String? bankCode;
  String? bankName;
  String? bKAppReceipientBankAccount;
  // String? orgApplNo;
  // String? orgRegistrationName;
  // String? orgBankCode;
  // String? orgBankAccountNo;
  int? returnCode;
  String? responseMessage;
 
  WelfareDetailsModel(
    {
      this.bKAppId,
      this.bKAppCode,
      this.bKAppType,
      this.bKAppTypeName,
      this.bKAppSubmittedDate,
      this.bKAppStatus,
      this.bKAppStatusName,
      this.bKAppAplicantCategory,
      this.bKAppAplicantName,
      this.bKAppAplicantMykadNo,
      this.bKAppReceipientCategory,
      this.bKAppReceipientName,
      // this.bKAppReceiverMykad,
      this.bKAppReceipientCode,
      this.bKAppTotalAmount,
      this.bankCode,
      this.bankName,
      this.bKAppReceipientBankAccount,
      // this.orgApplNo,
      // this.orgRegistrationName,
      // this.orgBankCode,
      // this.orgBankAccountNo,
      this.returnCode,
      this.responseMessage
    }
  );

  static listFromJson(List<dynamic> listJson) {
    List<WelfareDetailsModel> data = [];
    for (var value in listJson) {
      data.add(WelfareDetailsModel.fromJson(value));
    }
    return data;
  }

  factory WelfareDetailsModel.fromJson(Map<String, dynamic> objJson) {
    return WelfareDetailsModel(
      bKAppId: objJson['BKAppId'] ?? 0,
      bKAppCode: objJson['BKAppCode'] ?? '-',
      bKAppType: objJson['BKAppType'] ?? '-',
      bKAppTypeName: objJson['BKAppTypeName'] ?? '-',
      bKAppSubmittedDate: objJson['BKAppSubmittedDate'] ?? '-',
      bKAppStatus: objJson['BKAppStatus'] ?? '-',
      bKAppStatusName: objJson['BKAppStatusName'] ?? '-',
      bKAppAplicantCategory: objJson['BKAppAplicantCategory'] ?? '-',
      bKAppAplicantName: objJson['BKAppAplicantName'] ?? '-',
      bKAppAplicantMykadNo: objJson['BKAppAplicantMykadNo'] ?? '-',
      bKAppReceipientCategory: objJson['BKAppReceipientCategory'] ?? '-',
      bKAppReceipientName: objJson['BKAppReceipientName'] ?? '-',
      // bKAppReceiverMykad: objJson['BKAppReceiverMykad'] ?? '-',
      bKAppReceipientCode: objJson['BKAppReceipientCode'] ?? '-',
      bKAppTotalAmount: objJson['BKAppTotalAmount'] ?? 0.0,
      bankCode: objJson['BankCode'] ?? '-',
      bankName: objJson['BankName'] ?? '-',
      bKAppReceipientBankAccount: objJson['BKAppReceipientBankAccount'] ?? '-',
      // orgApplNo: objJson['OrgApplNo'] ?? '-',
      // orgRegistrationName: objJson['OrgRegistrationName'] ?? '-',
      // orgBankCode: objJson['OrgBankCode'] ?? '-',
      // orgBankAccountNo: objJson['OrgBankAccountNo'] ?? '-',
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}