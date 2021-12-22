class TransactionHistoryModel {
  String? paidMonthYear;
  double? totalPaid;
  List<PaymentListModel>? paymentList;
  int? returnCode;
  String? responseMessage;


  TransactionHistoryModel(
    {
      this.paidMonthYear,
      this.totalPaid,
      this.paymentList,
      this.returnCode,
      this.responseMessage
    }
  );

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> objJson) {
    return TransactionHistoryModel(
      paidMonthYear: objJson['PaidMonthYear'] ?? '-',
      totalPaid: objJson['TotalPaid'] ?? 0.0,
      paymentList: PaymentListModel.listFromJson(objJson['paymentList']),
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}

class PaymentListModel {
  String? monthYear;
  String? description;
  String? paymentDate;
  String? paidAmount;
  String? grossAmount;
  String? deductionAmount;
 
  PaymentListModel({
    this.monthYear,
    this.description,
    this.paymentDate,
    this.paidAmount,
    this.grossAmount,
    this.deductionAmount
  });

  static listFromJson(List<dynamic> listJson) {
    List<PaymentListModel> data = [];
    for (var value in listJson) {
      data.add(PaymentListModel.fromJson(value));
    }
    return data;
  }

  factory PaymentListModel.fromJson(Map<String, dynamic> objJson) {
    return PaymentListModel(
      monthYear: objJson['MonthYear'] ?? '-',
      description: objJson['Description'] ?? '-',
      paymentDate: objJson['PaymentDate'] ?? '-',
      paidAmount: objJson['PaidAmount'] ?? '-',
      grossAmount: objJson['GrossAmount'] ?? '-',
      deductionAmount: objJson['DeductionAmount'] ?? '-'
    );
  }
}