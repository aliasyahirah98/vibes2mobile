class CareerTrackListModel {
  List<CareerTrackInfoModel>? careerTrackList;
  int? returnCode;
  String? responseMessage;

  CareerTrackListModel(
    {
      this.careerTrackList,
      this.returnCode,
      this.responseMessage
    }
  );

  factory CareerTrackListModel.fromJson(Map<String, dynamic> objJson) {
    return CareerTrackListModel(
      careerTrackList: objJson['list'] != null ? CareerTrackInfoModel.listFromJson(objJson['list']) : [],
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}

class CareerTrackInfoModel {
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
  String? category;
  String? registraterEndDate;
  String? organizationEventPersonTypeCode;
  String? organizationEventPersonNo;
  String? personNo;
  String? registraterDate;
  String? status;
  String? createdDate;
  String? jhevInterviewLocation;
  String? jhevInterviewDate;
  String? jhevInterviewStartTime;
  String? jhevInterviewEndTime;
  String? jhevInterviewNotes;
  String? companyInterviewLocation;
  String? companyInterviewDate;
  String? companyInterviewStartTime;
  String? companyInterviewEndTime;
  String? companyInterviewNotes;
 
  CareerTrackInfoModel(
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
      this.category,
      this.registraterEndDate,
      this.organizationEventPersonTypeCode,
      this.organizationEventPersonNo,
      this.personNo,
      this.registraterDate,
      this.status,
      this.createdDate,
      this.jhevInterviewLocation,
      this.jhevInterviewDate,
      this.jhevInterviewStartTime,
      this.jhevInterviewEndTime,
      this.jhevInterviewNotes,
      this.companyInterviewLocation,
      this.companyInterviewDate,
      this.companyInterviewStartTime,
      this.companyInterviewEndTime,
      this.companyInterviewNotes
    }
  );

  static listFromJson(List<dynamic> listJson) {
    List<CareerTrackInfoModel> data = [];
    for (var value in listJson) {
      data.add(CareerTrackInfoModel.fromJson(value));
    }
    return data;
  }

  factory CareerTrackInfoModel.fromJson(Map<String, dynamic> objJson) {
    return CareerTrackInfoModel(
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
      category: objJson['Category'] ?? '-',
      registraterEndDate: objJson['RegistraterEndDate'] ?? '-',
      organizationEventPersonTypeCode: objJson['OrganizationEventPersonTypeCode'] ?? '-',
      organizationEventPersonNo: objJson['OrganizationEventPersonNo'] ?? '-',
      personNo: objJson['PersonNo'] ?? '-',
      registraterDate: objJson['RegistraterDate'] ?? '-',
      status: objJson['Status'] ?? '-',
      createdDate: objJson['CreatedDate'] ?? '-',
      jhevInterviewLocation: objJson['JhevInterviewLocation'] ?? '-',
      jhevInterviewDate: objJson['JhevInterviewDate'] ?? '-',
      jhevInterviewStartTime: objJson['JhevInterviewStartTime'] ?? '-',
      jhevInterviewEndTime: objJson['JhevInterviewEndTime'] ?? '-',
      jhevInterviewNotes: objJson['JhevInterviewNotes'] ?? '-',
      companyInterviewLocation: objJson['CompanyInterviewLocation'] ?? '-',
      companyInterviewDate: objJson['CompanyInterviewDate'] ?? '-',
      companyInterviewStartTime: objJson['CompanyInterviewStartTime'] ?? '-',
      companyInterviewEndTime: objJson['CompanyInterviewEndTime'] ?? '-',
      companyInterviewNotes: objJson['CompanyInterviewNotes'] ?? '-'
    );
  }
}