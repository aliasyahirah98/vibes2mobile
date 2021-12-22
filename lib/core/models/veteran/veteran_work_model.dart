class VeteranWorkModel {
  String? forceType;
  String? accreditationDate;
  int? ageWorkStart;
  int? ageWorkEnd;
  String? rank;
  String? rankCategory;
  String? serviceType;
  String? kor;
  String? workStartDate;
  String? workEndDate;
  String? retiredDate;
  int? returnCode;
  String? responseMessage;

  VeteranWorkModel(
    {
      this.forceType,
      this.accreditationDate,
      this.ageWorkStart,
      this.ageWorkEnd,
      this.rank,
      this.rankCategory,
      this.serviceType,
      this.kor,
      this.workStartDate,
      this.workEndDate,
      this.retiredDate,
      this.returnCode,
      this.responseMessage
    }
  );

  factory VeteranWorkModel.fromJson(Map<String, dynamic> objJson) {
    return VeteranWorkModel(
      forceType: objJson['JenisAngkatan'] ?? '-',
      accreditationDate: objJson['TarikhTauliah'] ?? '-',
      ageWorkStart: objJson['UmurMasukKhidmat'] ?? 0,
      ageWorkEnd: objJson['UmurTamatKhidmat'] ?? 0,
      rank: objJson['Pangkat'] ?? '-',
      rankCategory: objJson['KategoriPangkat'] ?? '-',
      serviceType: objJson['JenisPerkhidmatan'] ?? '-',
      kor: objJson['Kor'] ?? '',
      workStartDate: objJson['TarikhMulaKhidmat'] ?? '-',
      workEndDate: objJson['TarikhTamatPerkhidmatan'] ?? '-',
      retiredDate: objJson['TarikhBersara'] ?? '-',
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}
