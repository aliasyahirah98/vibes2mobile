class CourseListModel {
  List<CourseInfoModel>? courseList;
  int? returnCode;
  String? responseMessage;

  CourseListModel(
    {
      this.courseList,
      this.returnCode,
      this.responseMessage
    }
  );

  factory CourseListModel.fromJson(Map<String, dynamic> objJson) {
    return CourseListModel(
      courseList: objJson['list'] != null ? CourseInfoModel.listFromJson(objJson['list']) : [],
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}

class CourseInfoModel {
  int? id;
  String? organizationEventTypeCode;
  String? no;
  String? organizationNo;
  String? name;
  String? description;
  String? location;
  String? locationName;
  String? eventStartDate;
  String? eventEndDate;
  String? eventStartTime;
  String? eventEndTime;
  String? registraterEndDate;
  int? noOfPosition;
  String? jobFullOrPartTime;
  String? jobSalary;
  String? qualify;
  String? ageRange;
  String? bmi;
  String? expertise;
  String? contactName;
  String? contactNo;
  String? contactEmel;
  String? noOfAttendance;
  String? status;
  String? createdBy;
  String? createdDate;
  String? category;
  String? userSubmitBy;
  String? userSubmitDateTime;
  String? officerFailBy;
  String? officerFailDateTime;
  String? officerFailReason;
  String? orgRegistrationName;
  String? orgAddress1;
  String? orgAddressPostCode;
  String? orgAddressTown;
  String? orgAddressState;
  String? orgAddressCountry;
  String? cTrainingTargetGroup;
 
  CourseInfoModel(
    {
      this.id,
      this.organizationEventTypeCode,
      this.no,
      this.organizationNo,
      this.name,
      this.description,
      this.location,
      this.locationName,
      this.eventStartDate,
      this.eventEndDate,
      this.eventStartTime,
      this.eventEndTime,
      this.registraterEndDate,
      this.noOfPosition,
      this.jobFullOrPartTime,
      this.jobSalary,
      this.qualify,
      this.ageRange,
      this.bmi,
      this.expertise,
      this.contactName,
      this.contactNo,
      this.contactEmel,
      this.noOfAttendance,
      this.status,
      this.createdBy,
      this.createdDate,
      this.category,
      this.userSubmitBy,
      this.userSubmitDateTime,
      this.officerFailBy,
      this.officerFailDateTime,
      this.officerFailReason,
      this.orgRegistrationName,
      this.orgAddress1,
      this.orgAddressPostCode,
      this.orgAddressTown,
      this.orgAddressState,
      this.orgAddressCountry,
      this.cTrainingTargetGroup
    }
  );

  static listFromJson(List<dynamic> listJson) {
    List<CourseInfoModel> data = [];
    for (var value in listJson) {
      data.add(CourseInfoModel.fromJson(value));
    }
    return data;
  }

  factory CourseInfoModel.fromJson(Map<String, dynamic> objJson) {
    return CourseInfoModel(
      id: objJson['Id'] ?? 0,
      organizationEventTypeCode: objJson['OrganizationEventTypeCode'] ?? '-',
      no: objJson['No'] ?? '-',
      organizationNo: objJson['OrganizationNo'] ?? '-',
      name: objJson['Name'] ?? '-',
      description: objJson['Description'] ?? '-',
      location: objJson['Location'] ?? '-',
      locationName: objJson['LocationName'] ?? '-',
      eventStartDate: objJson['EventStartDate'] ?? '-',
      eventEndDate: objJson['EventEndDate'] ?? '-',
      eventStartTime: objJson['EventStartTime'] ?? '-',
      eventEndTime: objJson['EventEndTime'] ?? '-',
      registraterEndDate: objJson['RegistraterEndDate'] ?? '-',
      noOfPosition: objJson['NoOfPosition'] ?? 0,
      jobFullOrPartTime: objJson['JobFullOrPartTime'] ?? '-',
      jobSalary: objJson['JobSalary'] ?? '-',
      qualify: objJson['Qualify'] ?? '-',
      ageRange: objJson['AgeRange'] ?? '-',
      bmi: objJson['BMI'] ?? '-',
      expertise: objJson['Expertise'] ?? '-',
      contactName: objJson['ContactName'] ?? '-',
      contactNo: objJson['ContactNo'] ?? '-',
      contactEmel: objJson['ContactEmel'] ?? '-',
      noOfAttendance: objJson['NoOfAttendance'] ?? '-',
      status: objJson['Status'] ?? '-',
      createdBy: objJson['CreatedBy'] ?? '-',
      createdDate: objJson['CreatedDate'] ?? '-',
      category: objJson['Category'] ?? '-',
      userSubmitBy: objJson['UserSubmitBy'] ?? '-',
      userSubmitDateTime: objJson['UserSubmitDateTime'] ?? '-',
      officerFailBy: objJson['OfficerFailBy'] ?? '-',
      officerFailDateTime: objJson['OfficerFailDateTime'] ?? '-',
      officerFailReason: objJson['OfficerFailReason'] ?? '-',
      orgRegistrationName: objJson['OrgRegistrationName'] ?? '-',
      orgAddress1: objJson['OrgAddress1'] ?? '-',
      orgAddressPostCode: objJson['OrgAddressPostCode'] ?? '-',
      orgAddressTown: objJson['OrgAddressTown'] ?? '-',
      orgAddressState: objJson['OrgAddressState'] ?? '-',
      orgAddressCountry: objJson['OrgAddressCountry'] ?? '-',
      cTrainingTargetGroup: objJson['C_TrainingTargetGroup'] ?? '-'
    );
  }
}

class CourseResponseModel {
  dynamic result;
  int? returnCode;
  String? responseMessage;

  CourseResponseModel(
    {
      this.result,
      this.returnCode,
      this.responseMessage
    }
  );

  factory CourseResponseModel.fromJson(Map<String, dynamic> objJson) {
    return CourseResponseModel(
      result: objJson['Result'] ?? [],
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}