import 'package:flutter/material.dart';
import 'package:myveteran/shared/config/environment.dart';

// const Color mainColor = const Color(0xFF780206);
const Color mainColor = Color(0xFF000000);
const Color secondColor = Color(0xFF27409A);
const Color alertColor = Color(0xff950114);

// const apiUrl = 'https://vibes2uat.jhev.gov.my/vibes2dev/webservices/mobileapp/login.asmx/';
// const String apiUrl = 'http://vibes2.sytes.net/api/';
String apiUrl = Environment.apiUrl;
const String splash = '/';
const String intro = '/intro';
const String login = '/login';
const String firstRegister = '/firstRegister';
const String forgetPassword = '/forgetPassword';
const String layout = '/layout';
const String home = '/home';
const String notifications = '/notifications';
const String calendar = '/calendar';
const String setting = '/setting';
const String veteranProfile = '/veteranProfile';
const String veteranCard = '/veteranCard';
const String personalInformation = '/personalInformation';
const String serviceInformation = '/serviceInformation';
const String educationInformation = '/educationInformation';
const String resumeTemplate = '/resumeTemplate';
const String updateEducation = '/updateEducation';
const String heirsAndDependentInformation = '/heirsAndDependentInformation';
const String editProfil = '/editProfil';
const String transactionHistory = '/transactionHistory';
const String paymentStatement = '/paymentStatement';
const String careerOpportunity = '/careerOpportunity';
const String careerListOption = '/careerListOption';
const String courseOpportunity = '/courseOpportunity';
const String courseListOption = '/courseListOption';
const String medical = '/medical';
const String welfare = '/welfare';
const String bmj = '/bmj';
const String portalTrackMedical = '/portalTrackMedical';
const String portalTrackWelfare = '/portalTrackWelfare';
const String portalTrackBmj = '/portalTrackBmj';

const String countryCode = 'country_code';
const String languageCode = 'language_code';
List<LanguageModel> languages = [
  LanguageModel(imageUrl: '', languageName: 'Malay', countryCode: 'MY', languageCode: 'ms'),
  LanguageModel(imageUrl: '', languageName: 'English', countryCode: 'US', languageCode: 'en'),
];
class LanguageModel {
  String? imageUrl;
  String? languageName;
  String? languageCode;
  String? countryCode;

  LanguageModel({this.imageUrl, this.languageName, this.countryCode, this.languageCode});
}
