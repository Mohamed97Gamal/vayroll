import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';
import 'package:vayroll/models/announcement/notificationModel.dart';
import 'package:vayroll/models/employee.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/notifications.dart';
import 'package:vayroll/views/announcement/announcement_details.dart';
import 'package:vayroll/views/announcement/announcements.dart';
import 'package:vayroll/views/appeal_request/appeal_request.dart';
import 'package:vayroll/views/appeal_request/appeal_request_details.dart';
import 'package:vayroll/views/attendance/appeal_request.dart';
import 'package:vayroll/views/attendance/appeal_resubmit.dart';
import 'package:vayroll/views/attendance/attendance.dart';
import 'package:vayroll/views/auth/check_mail.dart';
import 'package:vayroll/views/auth/data_consent.dart';
import 'package:vayroll/views/auth/forget_password.dart';
import 'package:vayroll/views/auth/login.dart';
import 'package:vayroll/views/auth/login_first_time.dart';
import 'package:vayroll/views/auth/reset_password.dart';
import 'package:vayroll/views/auth/send_verification_otp.dart';
import 'package:vayroll/views/auth/verification_otp.dart';
import 'package:vayroll/views/dashboard/dashboard_widgets.dart';
import 'package:vayroll/views/decidable_requests/decidable_requests.dart';
import 'package:vayroll/views/department/department.dart';
import 'package:vayroll/views/dynamic_pages/request_details_page.dart';
import 'package:vayroll/views/dynamic_pages/submit_request.dart';
import 'package:vayroll/views/dynamic_pages/summary_request.dart';
import 'package:vayroll/views/expense_claim/expense.dart';
import 'package:vayroll/views/home/home.dart';
import 'package:vayroll/views/leave/leave.dart';
import 'package:vayroll/views/more/about_company.dart';
import 'package:vayroll/views/more/about_company_desc.dart';
import 'package:vayroll/views/more/analytics.dart';
import 'package:vayroll/views/more/appeal_manager/appeal_manager.dart';
import 'package:vayroll/views/more/contact_hr.dart';
import 'package:vayroll/views/more/department_employee.dart';
import 'package:vayroll/views/more/department_manager_employees.dart';
import 'package:vayroll/views/more/document_requests.dart';
import 'package:vayroll/views/more/documents.dart';
import 'package:vayroll/views/more/email_details.dart';
import 'package:vayroll/views/more/history.dart';
import 'package:vayroll/views/more/organization_chart.dart';
import 'package:vayroll/views/more/privacy_policy.dart';
import 'package:vayroll/views/more/support.dart';
import 'package:vayroll/views/more/terms.dart';
import 'package:vayroll/views/more/view_Email_attach.dart';
import 'package:vayroll/views/more/view_profile.dart';
import 'package:vayroll/views/notification/notification.dart';
import 'package:vayroll/views/notification/notification_details.dart';
import 'package:vayroll/views/payslip/payslip_details.dart';
import 'package:vayroll/views/payslip/payslips.dart';
import 'package:vayroll/views/profile/profile_requests.dart';
import 'package:vayroll/views/profile/view_certificate.dart';
import 'package:vayroll/views/requests/filter_requests.dart';
import 'package:vayroll/views/requests/filter_team_req.dart';
import 'package:vayroll/views/requests/search_requests.dart';
import 'package:vayroll/views/settings/change_language.dart';
import 'package:vayroll/views/settings/change_password.dart';
import 'package:vayroll/views/settings/feedback.dart';
import 'package:vayroll/views/settings/help_document.dart';
import 'package:vayroll/views/settings/view_doument.dart';
import 'package:vayroll/views/walkthrough/walkthrough.dart';
import 'package:vayroll/widgets/widgets.dart';

import '../views/calender/calender.dart';

class Navigation {
  static Future navToHome(BuildContext context) async {
    bool handled = await LocalNotification().handleInitialMessage(context);
    if (handled) return;

    await Navigator.of(context).pushAndRemoveUntil(
      new MaterialPageRoute(
        settings: RouteSettings(name: AppRoute.home),
        builder: (context) => HomePage(),
      ),
      (route) => false,
    );
  }

  static Future navToLogin(BuildContext context) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  static Future navToLoginAndRemoveUntil(BuildContext context) async {
    await Navigator.of(context).pushAndRemoveUntil(
      new MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
      (route) => false,
    );
  }

  static Future navToFirstTimeLoginAndRemoveUntil(BuildContext context) async {
    await Navigator.of(context).pushAndRemoveUntil(
      new MaterialPageRoute(
        builder: (context) => LoginFirstTimePage(),
      ),
      (route) => false,
    );
  }

  static Future navToWalkthrough(BuildContext context) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => WalkThroughPage(),
      ),
    );
  }

  static Future navToForgetPassword(BuildContext context) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => ForgetPasswordPage(),
      ),
    );
  }

  static Future navToResetPassword(BuildContext context) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => ResetPasswordPage(),
      ),
    );
  }

  static Future navToChangePassword(BuildContext context) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => ChangePasswordPage(),
      ),
    );
  }

  static Future navToDataConsent(BuildContext context) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => DataConsentPage(),
      ),
    );
  }

  static Future navToVerificationOTP(BuildContext context, String emailOrPhone) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => VerificationOTPPage(emailOrPhone),
      ),
    );
  }

  static Future navToVerificationOTPReplacment(BuildContext context, String? emailOrPhone) async {
    await Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (context) => VerificationOTPPage(emailOrPhone),
      ),
    );
  }

  static Future navToSendVerificationOTP(
    BuildContext context,
    String? email,
  ) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => SendVerificationOTPPage(email),
      ),
    );
  }

  static Future navToCheckMail(BuildContext context, String? email, String desc, bool forgetPassOrVerficition) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => CheckMail(email, desc, forgetPassOrVerficition),
      ),
    );
  }

  static Future navTocalenderPage(BuildContext context, Employee? employeeInfo) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => CalenderPage(employeeInfo: employeeInfo!),
      ),
    );
  }

  static Future navToChangeLanguage(BuildContext context) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => ChangeLanguagePage(),
      ),
    );
  }

  static Future navToViewCertificate(BuildContext context, Attachment? certificateFile) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => ViewCertificate(
          certificateFile: certificateFile,
        ),
      ),
    );
  }

  static Future navToViewDocument(BuildContext context, Attachment documentFile) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => ViewDecoument(documentFile: documentFile),
      ),
    );
  }

  static Future navToViewEmailAttach(BuildContext context, Attachment? attachment) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => ViewEmailAttachmentPage(attachment: attachment),
      ),
    );
  }

  static Future navToFeedback(BuildContext context) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => FeedbackPage(),
      ),
    );
  }

  static Future navToLeaveManagement(BuildContext context, Employee? employee) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        settings: RouteSettings(name: AppRoute.leaveManagement),
        builder: (context) => LeaveManagementPage(employee: employee),
      ),
    );
  }

  static Future<bool?> navToAttendance(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        settings: RouteSettings(name: AppRoute.attendance),
        builder: (context) => AttendancePage(),
      ),
    );
  }

  static Future<bool?> navToAttendanceAppealRequest(BuildContext context, CalendarAttendance attendance) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => AttendanceAppealRequestPage(dayAttendance: attendance),
      ),
    );
  }

  static Future<bool?> navToRequestDetails(BuildContext context, MyRequestsResponseDTO? requestInfo) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => RequestDetailsPage(requestInfo: requestInfo),
      ),
    );
  }

  static Future<bool?> navToResubmitAttendanceAppealRequest(
    BuildContext context,
    MyRequestsResponseDTO? attendance,
    GlobalKey<RefreshableState>? appealRequestsRefreshableKey,
  ) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => AttendanceAppealResubmitPage(
          attendanceInfo: attendance,
          refreshableKey: appealRequestsRefreshableKey,
        ),
      ),
    );
  }

  static Future<bool?> navToAppealRequest(BuildContext context, String? id, String? category) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => AppealRequestPage(
          id: id,
          category: category,
        ),
      ),
    );
  }

  static Future<bool?> navToAppealRequestDetails(
    BuildContext context,
    String? id, {
    EmployeeInfo? employee,
    Lock? lock,
    HashMap<String?, EmployeeWithImage>? employeeCache,
  }) async {
    lock ??= Lock();
    employeeCache ??= HashMap<String, EmployeeWithImage>();
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => AppealRequestDetailsPage(
          lock: lock,
          employeeCache: employeeCache,
          id: id,
          employee: employee,
        ),
      ),
    );
  }

  static Future<bool?> navToSubmetRequest(BuildContext context, String requestKind, String title) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => SubmitRequestPage(
          requestKind: requestKind,
          title: title,
        ),
      ),
    );
  }

  static Future<bool?> navToReSubmitRequest(
    BuildContext context,
    String requestKind,
    String title,
    String? requestStateId,
  ) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => SubmitRequestPage.resubmit(
          requestKind: requestKind,
          title: title,
          requestStateId: requestStateId,
        ),
      ),
    );
  }

  static Future<bool?> navToSubmitRequestSummary(
    BuildContext context,
    String? requestKind,
    String title,
    List<RequestStateAttributesDTO> fields,
    Employee? employee,
    String? requestStateId, {
    bool resubmit = false,
  }) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => SummaryRequestPage(
          requestKind: requestKind,
          title: title,
          allFields: fields,
          employee: employee,
          requestStateId: requestStateId,
          resubmit: resubmit,
        ),
      ),
    );
  }

  static Future<bool?> navToSearchRequestsPage(BuildContext context, bool team) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => SearchRequestsPage(team: team),
      ),
    );
  }

  static Future<bool?> navToFilterRequestsPage(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => FilterRequestsPage(),
      ),
    );
  }

  static Future<bool?> navToFilterTeamRequestsPage(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => FilterTeamRequestsPage(),
      ),
    );
  }

  static Future<bool?> navToProfileRequestsPage(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => ProfileRequestsPage(),
      ),
    );
  }

  static Future<bool?> navToDocumentRequestsPage(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        settings: RouteSettings(name: AppRoute.documentRequests),
        builder: (context) => DocumentRequestsPage(),
      ),
    );
  }

  static Future<bool?> navToViewProfilePage(BuildContext context, Employee? employee, bool approverOrManager,
      {Department? departments}) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => ViewProfilePage(
          employee: employee,
          approverOrManager: approverOrManager,
          departments: departments,
        ),
      ),
    );
  }

  static Future<bool?> navToPayslips(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        settings: RouteSettings(name: AppRoute.payslips),
        builder: (context) => PayslipsPage(),
      ),
    );
  }

  static Future<bool?> navToDepartment(
    BuildContext context,
    List<Department>? departmentsAttendanceAccessible,
    String? employeeId,
    String? employeesGroupId,
  ) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        settings: RouteSettings(name: AppRoute.payslips),
        builder: (context) => DepartmentPage(
          departmentsAttendanceAccessible: departmentsAttendanceAccessible,
          employeeId: employeeId,
          employeesGroupId: employeesGroupId,
        ),
      ),
    );
  }

  static Future<bool?> navToPayslipDetails(BuildContext context, Payslip? payslip) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => PayslipDetailsPage(payslip: payslip),
      ),
    );
  }

  static Future<bool?> navToExpenseClaimDetails(BuildContext context, Employee? employee) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        settings: RouteSettings(name: AppRoute.expenseClaim),
        builder: (context) => ExpenseClaimPage(employee: employee),
      ),
    );
  }

  static Future<bool?> navToDashboardWidgets(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => DashboardWidgetsPage(),
      ),
    );
  }

  static Future<bool?> navToAnnouncements(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => AnnouncementsPage(),
      ),
    );
  }

  static Future<bool?> navToAnnouncementDetails(BuildContext context, String? announcementId) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => AnnouncementDetailsPage(announcementId: announcementId),
      ),
    );
  }

  static Future<bool?> navToNotification(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => NotificationsPage(),
      ),
    );
  }

  static Future<bool?> navToNotificationDetails(BuildContext context, NotificationModel notification) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => NotificationDetailsPage(notification: notification),
      ),
    );
  }

  static Future<bool?> navToContactHR(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        settings: RouteSettings(name: AppRoute.contactHR),
        builder: (context) => ContactHRPage(),
      ),
    );
  }

  static Future<bool?> navToAboutCompany(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => AboutCompanyPage(),
      ),
    );
  }

  static Future<bool?> navToAboutCompanyDesc(BuildContext context, Company? companyInfo) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => AboutCompanyDescPage(companyInfo: companyInfo),
      ),
    );
  }

  static Future<bool?> navToDepartmentEmployees(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => DepartmentEmployeesPage(),
      ),
    );
  }

  static Future<bool?> navToDepartmentEmployess(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => DepartmentManagerEmployeesPage(),
      ),
    );
  }

  static Future<bool?> navToDucoments(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        settings: RouteSettings(name: AppRoute.document),
        builder: (context) => DucomentsPage(),
      ),
    );
  }

  static Future<bool?> navToOrganizationChart(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => OrganizationChartPage(),
      ),
    );
  }

  static Future<bool?> navToHistory(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => HistoryPage(),
      ),
    );
  }

  static Future<bool?> navToEmailDetails(BuildContext context, EmailDTO emailInfo) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => EmailDetailsPage(emailInfo: emailInfo),
      ),
    );
  }

  static Future<bool?> navToSupport(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => SupportPage(),
      ),
    );
  }

  static Future<bool?> navToPrivacyPolicy(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => PrivacyPolicyPage(),
      ),
    );
  }

  static Future<bool?> navToTerms(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => TermsAndConditionsPage(),
      ),
    );
  }

  static Future<bool?> navToDecidableRequests(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        settings: RouteSettings(name: AppRoute.decidableRequests),
        builder: (context) => DecidableRequests(),
      ),
    );
  }

  static Future<bool?> navToAnalytics(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => AnalyticsPage(),
      ),
    );
  }

  static Future<bool?> navToHelpDocument(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => HelpDucomentsPage(),
      ),
    );
  }

  static Future<bool?> navToAppealManagerChat(BuildContext context) async {
    return await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => AppealManagerPage(),
      ),
    );
  }
}
