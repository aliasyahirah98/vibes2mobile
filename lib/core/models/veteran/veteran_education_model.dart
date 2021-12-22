class VeteranEducationModel {
  String? height;
  String? weight;
  String? jobCurrentPosition;
  String? jobCurrentCompanyName;
  String? jobCurrentSalary;
  String? expectedSalary;
  String? strengthTechnical1;
  String? strengthTechnical2;
  String? strengthTechnical3;
  String? strengthTechnical4;
  String? strengthTechnical5;
  String? strengthTechnicalSpecial1;
  String? strengthTechnicalSpecial2;
  String? strengthTechnicalSpecial3;
  String? strengthTechnicalSpecial4;
  String? strengthTechnicalSpecial5;
  String? malayWrite;
  String? malayLinten;
  String? malayRead;
  String? englishWrite;
  String? englishLinten;
  String? englishRead;
  String? chineseWrite;
  String? chineseLinten;
  String? chineseRead;
  String? otherLanguage1;
  String? otherLanguage1Write;
  String? otherLanguage1Linten;
  String? otherLanguage1Read;
  String? otherLanguage2;
  String? otherLanguage2Write;
  String? otherLanguage2Linten;
  String? otherLanguage2Read;
  String? educationlevel1StudyLevel;
  String? educationlevel1FieldStudy;
  String? educationlevel1SchoolName;
  String? educationlevel1CGPApangkat;
  String? educationlevel1GraduationYear;
  String? educationlevel2StudyLevel;
  String? educationlevel2FieldStudy;
  String? educationlevel2SchoolName;
  String? educationlevel2CGPApangkat;
  String? educationlevel2GraduationYear;
  String? educationlevel3StudyLevel;
  String? educationlevel3FieldStudy;
  String? educationlevel3SchoolName;
  String? educationlevel3CGPApangkat;
  String? educationlevel3GraduationYear;
  String? jobHist1CompanyName;
  String? jobHist1Position;
  String? jobHist1StartDate;
  String? jobHist1EndDate;
  String? jobHist2CompanyName;
  String? jobHist2Position;
  String? jobHist2StartDate;
  String? jobHist2EndDate;
  String? drivingLicense;
  int? returnCode;
  String? responseMessage;

  VeteranEducationModel(
    {
      this.height,
      this.weight,
      this.jobCurrentPosition,
      this.jobCurrentCompanyName,
      this.jobCurrentSalary,
      this.expectedSalary,
      this.strengthTechnical1,
      this.strengthTechnical2,
      this.strengthTechnical3,
      this.strengthTechnical4,
      this.strengthTechnical5,
      this.strengthTechnicalSpecial1,
      this.strengthTechnicalSpecial2,
      this.strengthTechnicalSpecial3,
      this.strengthTechnicalSpecial4,
      this.strengthTechnicalSpecial5,
      this.malayWrite,
      this.malayLinten,
      this.malayRead,
      this.englishWrite,
      this.englishLinten,
      this.englishRead,
      this.chineseWrite,
      this.chineseLinten,
      this.chineseRead,
      this.otherLanguage1,
      this.otherLanguage1Write,
      this.otherLanguage1Linten,
      this.otherLanguage1Read,
      this.otherLanguage2,
      this.otherLanguage2Write,
      this.otherLanguage2Linten,
      this.otherLanguage2Read,
      this.educationlevel1StudyLevel,
      this.educationlevel1FieldStudy,
      this.educationlevel1SchoolName,
      this.educationlevel1CGPApangkat,
      this.educationlevel1GraduationYear,
      this.educationlevel2StudyLevel,
      this.educationlevel2FieldStudy,
      this.educationlevel2SchoolName,
      this.educationlevel2CGPApangkat,
      this.educationlevel2GraduationYear,
      this.educationlevel3StudyLevel,
      this.educationlevel3FieldStudy,
      this.educationlevel3SchoolName,
      this.educationlevel3CGPApangkat,
      this.educationlevel3GraduationYear,
      this.jobHist1CompanyName,
      this.jobHist1Position,
      this.jobHist1StartDate,
      this.jobHist1EndDate,
      this.jobHist2CompanyName,
      this.jobHist2Position,
      this.jobHist2StartDate,
      this.jobHist2EndDate,
      this.drivingLicense,
      this.returnCode,
      this.responseMessage
    }
  );

  factory VeteranEducationModel.fromJson(Map<String, dynamic> objJson) {
    return VeteranEducationModel(
      height: objJson['Height'] ?? '-',
      weight: objJson['Weight'] ?? '-',
      jobCurrentPosition: objJson['JobCurrentPosition'] ?? '-',
      jobCurrentCompanyName: objJson['JobCurrentCompanyName'] ?? '-',
      jobCurrentSalary: objJson['JobCurrentSalary'] ?? '-',
      expectedSalary: objJson['ExpectedSalary'] ?? '-',
      strengthTechnical1: objJson['StrengthTechnical1'] ?? '-',
      strengthTechnical2: objJson['StrengthTechnical2'] ?? '-',
      strengthTechnical3: objJson['StrengthTechnical3'] ?? '-',
      strengthTechnical4: objJson['StrengthTechnical4'] ?? '-',
      strengthTechnical5: objJson['StrengthTechnical5'] ?? '-',
      strengthTechnicalSpecial1: objJson['StrengthTechnicalSpecial1'] ?? '-',
      strengthTechnicalSpecial2: objJson['StrengthTechnicalSpecial2'] ?? '-',
      strengthTechnicalSpecial3: objJson['StrengthTechnicalSpecial3'] ?? '-',
      strengthTechnicalSpecial4: objJson['StrengthTechnicalSpecial4'] ?? '-',
      strengthTechnicalSpecial5: objJson['StrengthTechnicalSpecial5'] ?? '-',
      malayWrite: objJson['MalayWrite'] ?? '-',
      malayLinten: objJson['MalayLinten'] ?? '-',
      malayRead: objJson['MalayRead'] ?? '-',
      englishWrite: objJson['EnglishWrite'] ?? '-',
      englishLinten: objJson['EnglishLinten'] ?? '-',
      englishRead: objJson['EnglishRead'] ?? '-',
      chineseWrite: objJson['ChineseWrite'] ?? '-',
      chineseLinten: objJson['ChineseLinten'] ?? '-',
      chineseRead: objJson['ChineseRead'] ?? '-',
      otherLanguage1: objJson['OtherLanguage1'] ?? '-',
      otherLanguage1Write: objJson['OtherLanguage1Write'] ?? '-',
      otherLanguage1Linten: objJson['OtherLanguage1Linten'] ?? '-',
      otherLanguage1Read: objJson['OtherLanguage1Read'] ?? '-',
      otherLanguage2: objJson['OtherLanguage2'] ?? '-',
      otherLanguage2Write: objJson['OtherLanguage2Write'] ?? '-',
      otherLanguage2Linten: objJson['OtherLanguage2Linten'] ?? '-',
      otherLanguage2Read: objJson['OtherLanguage2Read'] ?? '-',
      educationlevel1StudyLevel: objJson['Educationlevel1__study_level'] ?? '-',
      educationlevel1FieldStudy: objJson['Educationlevel1__field_study'] ?? '-',
      educationlevel1SchoolName: objJson['Educationlevel1_school_name'] ?? '-',
      educationlevel1CGPApangkat: objJson['Educationlevel1_CGPA_pangkat'] ?? '-',
      educationlevel1GraduationYear: objJson['Educationlevel1_graduation_year'] ?? '-',
      educationlevel2StudyLevel: objJson['Educationlevel2__study_level'] ?? '-',
      educationlevel2FieldStudy: objJson['Educationlevel2__field_study'] ?? '-',
      educationlevel2SchoolName: objJson['Educationlevel2_school_name'] ?? '-',
      educationlevel2CGPApangkat: objJson['Educationlevel2_CGPA_pangkat'] ?? '-',
      educationlevel2GraduationYear: objJson['Educationlevel2_graduation_year'] ?? '-',
      educationlevel3StudyLevel: objJson['Educationlevel3__study_level'] ?? '-',
      educationlevel3FieldStudy: objJson['Educationlevel3__field_study'] ?? '-',
      educationlevel3SchoolName: objJson['Educationlevel3_school_name'] ?? '-',
      educationlevel3CGPApangkat: objJson['Educationlevel3_CGPA_pangkat'] ?? '-',
      educationlevel3GraduationYear: objJson['Educationlevel3_graduation_year'] ?? '-',
      jobHist1CompanyName: objJson['JobHist1CompanyName'] ?? '-',
      jobHist1Position: objJson['JobHist1Position'] ?? '-',
      jobHist1StartDate: objJson['JobHist1StartDate'] ?? '-',
      jobHist1EndDate: objJson['JobHist1EndDate'] ?? '-',
      jobHist2CompanyName: objJson['JobHist2CompanyName'] ?? '-',
      jobHist2Position: objJson['JobHist2Position'] ?? '-',
      jobHist2StartDate: objJson['JobHist2StartDate'] ?? '-',
      jobHist2EndDate: objJson['JobHist2EndDate'] ?? '-',
      drivingLicense: objJson['DrivingLicense'] ?? '-',
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}

class VeteranEducationResponseModel {
  dynamic result;
  int? returnCode;
  String? responseMessage;

  VeteranEducationResponseModel(
    {
      this.result,
      this.returnCode,
      this.responseMessage
    }
  );

  factory VeteranEducationResponseModel.fromJson(Map<String, dynamic> objJson) {
    return VeteranEducationResponseModel(
      result: objJson['Result'] ?? [],
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}