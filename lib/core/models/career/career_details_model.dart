class CareerDetailsModel {
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
  String? createdDate;
  String? benefit;
  int? returnCode;
  String? responseMessage;
 
  CareerDetailsModel(
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
      this.createdDate,
      this.benefit,
      this.returnCode,
      this.responseMessage
    }
  );

  static listFromJson(List<dynamic> listJson) {
    List<CareerDetailsModel> data = [];
    for (var value in listJson) {
      data.add(CareerDetailsModel.fromJson(value));
    }
    return data;
  }

  factory CareerDetailsModel.fromJson(Map<String, dynamic> objJson) {
    return CareerDetailsModel(
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
      createdDate: objJson['CreatedDate'] ?? '-',
      benefit: objJson['Benefit'] ?? '-',
      returnCode: objJson['ReturnCode'] ?? 0,
      responseMessage: objJson['ResponseMessage'] ?? '-'
    );
  }
}