import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/views/admin/first_time_register.dart';
import 'package:myveteran/views/admin/forget_password.dart';
import 'package:myveteran/views/admin/login.dart';
import 'package:myveteran/views/app/layout.dart';
import 'package:myveteran/views/app/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myveteran/views/home/panel_info/veteran_card/veteran_card.dart';
import 'package:myveteran/views/home/panel_info/veteran_profile/education_information/education_information.dart';
import 'package:myveteran/views/home/panel_info/veteran_profile/education_information/resume_template/resume_template.dart';
import 'package:myveteran/views/home/panel_info/veteran_profile/education_information/update_details/update_education.dart';
import 'package:myveteran/views/home/panel_info/veteran_profile/heirs_and_dependent_information/heirs_and_dependent_information.dart';
import 'package:myveteran/views/home/panel_info/veteran_profile/personal_information/personal_information.dart';
import 'package:myveteran/views/home/panel_info/veteran_profile/service_information/service_information.dart';
import 'package:myveteran/views/home/panel_info/veteran_profile/veteran_profile.dart';
import 'package:myveteran/views/home/panel_service/bmj/bmj.dart';
import 'package:myveteran/views/home/panel_service/career_opportunity/career_list/career_list_details.dart';
import 'package:myveteran/views/home/panel_service/career_opportunity/career_list/career_list_option.dart';
import 'package:myveteran/views/home/panel_service/career_opportunity/career_opportunity.dart';
import 'package:myveteran/views/home/panel_service/career_opportunity/career_track/career_track_details.dart';
import 'package:myveteran/views/home/panel_service/course_opportunity/course_list/course_list_details.dart';
import 'package:myveteran/views/home/panel_service/course_opportunity/course_list/course_list_option.dart';
import 'package:myveteran/views/home/panel_service/course_opportunity/course_opportunity.dart';
import 'package:myveteran/views/home/panel_service/course_opportunity/course_track/course_track_details.dart';
import 'package:myveteran/views/home/panel_service/medical/medical.dart';
import 'package:myveteran/views/home/panel_service/payment_statement/payment_statement.dart';
import 'package:myveteran/views/home/panel_service/welfare/welfare.dart';
import 'package:myveteran/views/home/panel_service/welfare/welfare_track/welfare_track_details.dart';
import 'package:myveteran/views/home/panel_transaction/transaction_history/transaction_history.dart';
import 'package:myveteran/views/sidebar/calendar/calendar.dart';
import 'package:myveteran/views/sidebar/notifications/notifications.dart';
import 'package:myveteran/views/sidebar/settings/edit_profile/edit_profile.dart';
import 'package:myveteran/views/sidebar/settings/settings.dart';
import 'package:myveteran/views/web_portal/portal_track/portal_track_bmj.dart';
import 'package:myveteran/views/web_portal/portal_track/portal_track_medical.dart';
import 'package:myveteran/views/web_portal/portal_track/portal_track_welfare.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  return MaterialPageRoute(
    settings: settings,
    builder: (BuildContext context) {
      switch (settings.name) {
        case splash:
          return const SplashState();
        case login:
          return const LoginState();
        case firstRegister:
          return const FirstTimeRegisterState();
        case forgetPassword:
          return const ForgetPasswordState();
        case layout:
          return const LayoutState();
        case notifications:
          return const NotificationsState();
        case calendar:
          return const CalendarState();
        case setting:
          return const SettingsState();
        case veteranProfile:
          return const VeteranProfileState();
        case veteranCard:
          return const VeteranCardState();
        case personalInformation:
          return const PersonalInformationState();
        case serviceInformation:
          return const ServiceInformationState();
        case educationInformation:
          return const EducationInformationState();
        case resumeTemplate:
          return const ResumeTemplateState();
        case updateEducation:
          return const UpdateEducationState();
        case heirsAndDependentInformation:
          return const HeirsAndDependentInformationState();
        case editProfil:
          return const EditProfileState();
        case transactionHistory:
          return const TransactionHistoryState();
        case paymentStatement:
          return const PaymentStatementState();
        case careerOpportunity:
          return const CareerOpportunityState(selectedTab: 0);
        case careerListOption:
          return const CareerListOptionState();
        case courseOpportunity:
          return const CourseOpportunityState(selectedTab: 0);
        case courseListOption:
          return const CourseListOptionState();
        case medical:
          return const MedicalState(selectedTab: 0);
        case welfare:
          return const WelfareState(selectedTab: 0);
        case bmj:
          return const BmjState(selectedTab: 0);
        case portalTrackMedical:
          return const PortalTrackMedicalState();
        case portalTrackWelfare:
          return const PortalTrackWelfareState();
        case portalTrackBmj:
          return const PortalTrackBmjState();
        default: 
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}')
            ),
          );
      }
    }
  );
}