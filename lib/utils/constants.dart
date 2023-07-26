import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:vayroll/firebase_remote_config.dart';
import 'package:vayroll/theme/app_themes.dart';

class Urls {
  //static const String baseUrl = "https://demo-vpay-apis.transskills.com/vpay/api/vapis/";
  static  String baseUrl = FirebaseRemoteConfigService().getString("base_api_url") ;
  //static const String baseUrl =
  //    "https://prod-vpay-apis.transskills.com/vpay/api/vapis/";

  // Auth
  static const String login = "login";
  static const String logout = "login/logout";
  static const String refreshToken = "login/refreshToken";

  // User
  static const String getUser = "user";
  static const String getDataConsent = "user/consent";
  static const String acceptDataConsent = "user/consent/accept";
  static const String resetPassword = "user/password/reset";
  static const String newPassword = "user/password/new";
  static const String changePassword = "user/password/change";
  static const String updateFCMToken = "user/update/fcm-token";

  // verification
  static const String sendOtp = "verification/send-otp";
  static const String verifyOtp = "verification/verify-otp";

  // Employee
  static const String getEmployee = "employee";
  static const String getEmployeeInfo = "employee/baseInfo";
  static const String getEmergencyContacts = "employee/emergency-contacts";
  static const String confirmEmployeeProfile = "employee/profile/confirm";
  static const String getPayslips = "employee/payslips";
  static const String emailPayslip = "employee/send-payslip-email";
  static const String expenseClaim = "employee/expense";
  static const String getEmployeeReportees = "employee/reportees";

  // Employee Group
  static const String getPositions = "employees-group/positions";
  static const String getManagers = "employees-group/managers";
  static const String getSkillProficiencies =
      "employees-group/skill-proficiency";
  static const String getHRContacts = "employees-group/hr-contacts";
  static const String getCompanyInfo = "employees-group/info";
  static const String getDepartmentEmployess = "employees-group/employees";
  static const String getEmployeeGroupChart = "employees-group/chart";

  // Attendance
  static const String getAnnualAttendance = "attedance/attendance";
  static const String getAttendanceSessions =
      "attedance/attendance/day/sessions";
  static const String checkIn = "attedance/checkIn";
  static const String checkOut = "attedance/checkOut";
  static const String getAccessibleAttendanceDepartments =
      "attedance/department/accessible";
  static const String getAllAccessibleAttendanceDepartments =
      "attedance/department/all";
  static const String getAttendanceDepartments = "attedance/department";
  static const String getAttendanceDepartmentSummary =
      "attedance/department-summary";
  static const String getTeamAttendance = "attedance/team";
  static const String getTeamAttendanceSummary = "attedance/team-summary";
  static const String getCalendarAttendance = "attedance/employee";

  //Departments
  static const String getAllDepartments = "department/list";

  // lookups
  static const String getOCRKeywords = "lookup/OCRKeyWords";
  static const String getOCRNegativeKeywords = "lookup/OCRKeyWords/negative";
  static const String getCountries = "lookup/countries";
  static const String getCurrencies = "lookup/currencies";

  // Request
  static const String getRequestdetials = "request";
  static const String sendEmployeeInfoRequest = "request/info";
  static const String sendEmergencyContactsRequest =
      "request/emergency-contact";
  static const String certificatesRiseRequest = "request/certification";
  static const String educationsRiseRequest = "request/education";
  static const String experiencesRiseRequest = "request/experience";
  static const String skillsRiseRequest = "request/skill";
  static const String emergencyContactRiseRequest =
      "request/emergency-contacts";
  static const String infoRiseRequest = "request/info";
  static const String getMyActiveRequests = "request/active";
  static const String getRequests = "request/search";
  static const String actions = "request/active/action";
  static const String attendanceAppealRequest = "request/attendance/appeal";
  static const String resubmitAttendanceAppealRequest =
      "request/attendance/appeal/resubmit";
  static const String resubmitCertificationRequest =
      "request/resubmit/certification";
  static const String resubmiteducationRequest = "request/resubmit/education";
  static const String resubmitEmergencyContactRequest =
      "request/resubmit/emergency-contact";
  static const String resubmitexperienceRequest = "request/resubmit/experience";
  static const String resubmitinfoRequest = "request/resubmit/info";
  static const String resubmitskillRequest = "request/resubmit/skill";
  static const String getDecidableRequest = "/request/decidable";
  static const String isRequestApproverByDefinition =
      "request/isRequestApproverByDefinition";
  static const String makeDecidableRequestAction = "/request/decidable/action";
  static const String isRequestApprover = "request/isRequestApprover";

  // File
  static const String getFile = "file";

  // events
  static const String getBirthdays = "calendar/birthdays";
  static const String getEvents = "calendar/events";
  static const String getNotes = "calendar/notes";
  static const String createNote = "calendar/note/create";
  static const String deleteNote = "calendar/note/delete/";
  static const String updateNote = "calendar/note/update";

  //profile
  static const String experiences = "employee/experiences";
  static const String educations = "employee/educations";
  static const String certificates = "employee/certificates";
  static const String skills = "employee/skills";

  // Data Consent
  static const String privacyPolicy = "privacy";
  static const String termsAndConditions = "terms";

  // Lookups
  static const String getReligions = "lookup/religion";

  // Leave
  static const String getLeaveBalance = "employee/leave-balances";

  // Feedback
  static const String sendFeedback = "feedbacks/create";

  // Appeal Requests
  static const String getAppealRequests = "appeal/search";
  static const String sendAppealRequest = "appeal/submit";
  static const String getAppealRequestDetails = "appeal";
  static const String sendAppealNote = "appeal/note";

  // Dynamic Requests
  static const String getDrewFieldsSubmit = "dynamic/request/draw/submit";
  static const String getDrewFieldsResubmit = "dynamic/request/draw/resubmit";
  static const String requestSubjects = "dynamic/request/subjects";
  static const String submitRequest = "dynamic/request/submit";
  static const String reSubmitRequest = "dynamic/request/resubmit";
  static const String summaryRequest = "dynamic/request/summary";
  static const String leaveBalancesDynamic =
      "/dynamic/request/summary/leave/balances";
  static const String leaveBalancePeriod =
      "dynamic/request/summary/leave/period/balance";

  // Announcements
  static const String getUserAnnouncements = "announcement/list";
  static const String getAnnouncementById = "announcement";
  static const String getUnreadAnnouncementsCount = "announcement/unread-count";
  static const String markAnnouncementAsRead = "announcement/read";

  // Email
  static const String getEmails = "email/search";
  static const String sendEmailToHR = "email/send/hr-contact";
  static const String sendEmail = "email/send";
  static const String getEmailDetails = "email";
  static const String downloadMailAttachment = "email/download-attachment";

  // Employee Call
  static const String saveCall = "call";
  static const String callHistory = "call/history";

  // Organization
  static const String support = "organization/support";

  // Notification
  static const String getUserNotifications = "notification/list";
  static const String getUnreadNotificationsCount = "notification/unread";
  static const String markNotificationAsRead = "notification/updateIsRead";

  // Dashboard
  static const String getContracts = "dashboard/contracts";
  static const String getExperience = "dashboard/experience";
  static const String getPositionsAndGenders = "dashboard/position-and-gender";

  // Document
  static const String getCompanydocuments = "document/list";

  // Help
  static const String getHelpDocuments = "help/list";
  static const String downloadHelpDocuments = "help/download";

  //Admin
  static const String sendMailSupport = "admin​/support";

  static final _noAuth = [
    login,
    resetPassword,
  ].map((e) => e.toLowerCase());

  static bool requiresAuth({String? url}) {
    final _url = url?.toLowerCase();
    if ((_url ?? "").isEmpty) return false;

    var result =
        _noAuth.firstWhereOrNull((path) => _url!.contains(path));
    return result == null;
  }
}

class RequestAction {
  static const String add = "ADD";
  static const String update = "UPDATE";
  static const String delete = "DELETE";
}

class RequestStatus {
  static const String statusNew = "NEW";
  static const String statusSubmitted = "SUBMITTED";
  static const String statusClosed = "CLOSED";
  static const String statusSkipped = "SKIPPED";
  static const String statusDeleted = "DELETED";
}

class RequestCategory {
  static const String leave = "LEAVE";
  static const String expenseClaim = "EXPENSE_CLAIM";
  static const String payroll = "PAYROLL";
}

class RequestKind {
  static const String attendanceAppealRequest = "ATTENDANCE_APPEAL_REQUEST";
  static const String leave = "LEAVE";
  static const String profileUpdate = "EMPLOYEE_PROFILE_UPDATE";
  static const String expenseClaim = "EXPENSE_CLAIM";
  static const String ducoment = "COMPANY_DOCUMENT";
}

class RequestProfileType {
  static const String employeeCertificate = "EmployeeCertificate";
  static const String employeeEducation = "EmployeeEducation";
  static const String employeeSkill = "EmployeeSkill";
  static const String employeeWorkExperience = "EmployeeWorkExperience";
  static const String personalInformation = "PersonalInformation";
  static const String employeeEmergencyContact = "EmployeeEmergencyContact";
}

class AppealCategory {
  static const String payroll = "PAYROLL";
  static const String leave = "LEAVE";
  static const String expenseClaim = "EXPENSE_CLAIM";
  static const String attendance = "ATTENDANCE";
}

class Encryption {
  static const String publicKey =
      "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCwVpitcwmwdplgaPMNawM0iUeRm4HsSiuWztZD/MA9DvBreYgUBR+84ciJ8DD24opBGQ40n8/4nVLhkHNI4AYE6+cJdfH+pbEX0Rk3MgMj2SUnOLiCKE7XIcFvy/92tXx4Z8ob6kjsVIaFIuVxaobZ/+PRjHP05pXMs9uQMigPewIDAQAB\n-----END PUBLIC KEY-----";
}

class AppScheme {
  static const String gmailAndroid = "http://gmail.app.goo.gl";
  static const String outlookAndroidIos = "ms-outlook://";
  static const String gmailIos = "googlegmail://";
  static const String mailAppIos = "message://";
}

class AppRoute {
  static const String home = "Home";
  static const String leaveManagement = "LeaveManagement";
  static const String attendance = "Attendance";
  static const String payslips = "Payslips";
  static const String decidableRequests = "DecidableRequests";
  static const String expenseClaim = "ExpenseClaim";
  static const String contactHR = "ContactHR";
  static const String document = "Document";
  static const String documentRequests = "DocumentRequests";
}

class SalaryChange {
  static const String increased = "INCREASED";
  static const String decreased = "DECREASED";
  static const String same = "SAME";
}

class PieChartColors {
  static Color first = DefaultThemeColors.nepal;
  static Color second = DefaultThemeColors.mayaBlue;
  static Color third = Color(0xFF013C68);
  static Color fourth = Color(0xFFFD5675);
}

class RecipientType {
  static const String hr = "HR";
  static const String emp = "EMP";
}

class DynamicRequestTypes {
  static const String text = "TEXT";
  static const String bigText = "BIG_TEXT";
  static const String decimal = "DECIMAL";
  static const String number = "NUMBER";
  static const String email = "EMAIL";
  static const String phoneNumber = "PHONE_NUMBER";
  static const String password = "PASSWORD";
  static const String checkbox = "CHECKBOX";
  static const String date = "DATE";
  static const String time = "TIME";
  static const String dateTime = "DATE_TIME";
  static const String file = "FILE";
  static const String lookup = "LOOKUP";
  static const String list = "LIST";
  static const String image = "IMAGE";
}

List<String> allowExtensions = [
  'jpg',
  'png',
  'tiff',
  'jpeg',
  'gif',
  'dib',
  'webp',
  'bmp',
  'heic',
  'pdf',
  'docx',
  'doc',
  'xls',
  'xlsx',
  'txt',
  'csv'
];
List<String> imageExtensions = [
  'jpg',
  'png',
  'tiff',
  'jpeg',
  'gif',
  'dib',
  'webp',
  'bmp',
  'heic'
];
List<String> fileExtensions = [
  'pdf',
  'docx',
  'doc',
  'xls',
  'xlsx',
  'txt',
  'csv'
];

List<Color> darkColorBallet = [
  Color(0xFF012763),
  Color(0xFF01A086),
  Color(0xFFCC929C),
  Color(0xFF4893C1),
  Color(0xFF8D525D),
  Color(0xFF5D5D5D),
  Color(0xFF816982),
  Color(0xFF81ACA5),
  Color(0xFF4D6F84),
  Color(0xFF9E9D2A),
  Color(0xFF263238),
  Color(0xFFEF926A),
  Color(0xFF3D8075),
  Color(0xFF684430),
  Color(0xFFF27766),
];

List<Color> colorBallet = [
  Color(0xFF012763),
  Color(0xFFF23D5E),
  Color(0xFFA6CEE3),
  Color(0xFF9DD0F5),
  Color(0xFFCCCE8A),
  Color(0xFF816982),
  Color(0xFFFFB088),
  Color(0xFFF788BA),
  Color(0xFF01A086),
  Color(0xFFCC929C),
  Color(0xFF4893C1),
  Color(0xFF8D525D),
  Color(0xFF5D5D5D),
  Color(0xFF816982),
  Color(0xFFCF8AD2),
  Color(0xFF81ACA5),
  Color(0xFF4D6F84),
  Color(0xFF9E9D2A),
  Color(0xFF263238),
  Color(0xFFEF926A),
  Color(0xFF3D8075),
  Color(0xFF684430),
  Color(0xFFF27766),
];
