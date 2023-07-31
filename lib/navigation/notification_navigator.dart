import 'dart:collection';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:vayroll/main.dart';
import 'package:vayroll/models/announcement/notificationModel.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/approved_requests_tab_index_provider.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/views/announcement/announcement_details.dart';
import 'package:vayroll/views/announcement/announcements.dart';
import 'package:vayroll/views/appeal_request/appeal_request_details.dart';
import 'package:vayroll/views/attendance/attendance.dart';
import 'package:vayroll/views/decidable_requests/decidable_requests.dart';
import 'package:vayroll/views/dynamic_pages/request_details_page.dart';
import 'package:vayroll/views/expense_claim/expense.dart';
import 'package:vayroll/views/home/home.dart';
import 'package:vayroll/views/leave/leave.dart';
import 'package:vayroll/views/more/appeal_manager/appeal_manager.dart';
import 'package:vayroll/views/more/document_requests.dart';
import 'package:vayroll/views/more/documents.dart';
import 'package:vayroll/views/notification/notification.dart';
import 'package:vayroll/views/notification/notification_details.dart';
import 'package:vayroll/views/payslip/payslips.dart';
import 'package:vayroll/views/profile/profile_requests.dart';

Future deepLink(BuildContext context, RemoteMessage? message) async {
  if (message == null || message.data.isEmpty) {
    return;
  }

  String? title = "";
  String? body = "";
  String? image = "";
  try {
    final notification = message.data['display_notification'] as String;
    final notificationMap = json.decode(notification);
    title = notificationMap["title"];
    body = notificationMap["body"];
    image = notificationMap["image"];
  } catch (ex) {}

  String? type = message.data['type'];
  var provider = context.read<EmployeeProvider>();
  await provider.get();

  String? employeeId = provider.employee!.id;
  String? employeesGroupId = provider.employee!.employeesGroup!.id;
  switch (type) {
    case "Notification":
      String? notificationId = message.data['notificationId'];
      //ApiRepo().markNotificationAsRead(notificationId);
      NotificationModel notificationModel = NotificationModel(
          id: notificationId,
          title: title ?? "",
          body: body ?? "",
          data: json.encode(message.data),
          image: null,
          imageUrl: image ?? "",
          isRead: false);
      if (message.data['redirectTo'] == "EMPLOYEE_CERTIFICATE") {
        _navToHome();
        context.read<HomeTabIndexProvider>().index = 0;
        context.read<ProfileTabIndexProvider>().index = 3;
      } //null case
      else if (message.data['redirectTo'] == null || message.data['redirectTo'] == "EMPLOYEE_DOCUMENT") {
        _navToHome();
        _navToNotifications();
        _navToNotificationDetails(notificationModel);
      }
      //3 manual Logins
      else if (message.data['redirectTo'] == "EMPLOYEE_ATTENDANCE") {
        _navToHome();
        context.read<HomeTabIndexProvider>().index = 2;
        _navToAttendance(1);
      } //Automatically checkOut
      else if (message.data['redirectTo'] == "MY_ATTENDANCE") {
        _navToHome();
        context.read<HomeTabIndexProvider>().index = 2;
        _navToAttendance(0);
      } else if (message.data['redirectTo'] == "APPEAL") {
        bool isNotifier = message.data['notifiers'].toString().contains(employeeId!);
        var appealRequestId = message.data['appealRequestId'];
        var category = message.data['category'];
        final response = await ApiRepo().getEmployeeReportees(employeeId, employeesGroupId);
        bool hasReporters = response.result != null && response.result!.isNotEmpty;
        _navToHome();
        switch (category) {
          case AppealCategory.leave:
            if (isNotifier) {
              _notifierCase(context, notificationModel);
            } else if (message.data['subjectId'] == employeeId ||
                message.data['appealIssuerEmployeeId'] == employeeId) {
              context.read<HomeTabIndexProvider>().index = 2;
              if (hasReporters)
                _navToLeaveManagement(3);
              else
                _navToLeaveManagement(1);
              _navToAppealRequestDetails(appealRequestId);
            } else {
              _managerOrHRAppealCase(context, appealRequestId, AppealCategory.leave);
              context.read<HomeTabIndexProvider>().appealManagerIcon = true;
            }
            break;
          case AppealCategory.payroll:
            if (isNotifier) {
              _notifierCase(context, notificationModel);
            } else if (message.data['subjectId'] == employeeId ||
                message.data['appealIssuerEmployeeId'] == employeeId) {
              context.read<HomeTabIndexProvider>().index = 2;
              _navToPayslips(1);
              _navToAppealRequestDetails(appealRequestId);
            } else {
              _managerOrHRAppealCase(context, appealRequestId, AppealCategory.payroll);
              context.read<HomeTabIndexProvider>().appealManagerIcon = true;
            }
            break;
          case AppealCategory.expenseClaim:
            if (isNotifier) {
              _notifierCase(context, notificationModel);
            } else if (message.data['subjectId'] == employeeId ||
                message.data['appealIssuerEmployeeId'] == employeeId) {
              context.read<HomeTabIndexProvider>().index = 2;
              if (hasReporters)
                _navToExpenseClaims(3);
              else
                _navToExpenseClaims(1);
              _navToAppealRequestDetails(appealRequestId);
            } else {
              _managerOrHRAppealCase(context, appealRequestId, AppealCategory.expenseClaim);
              context.read<HomeTabIndexProvider>().appealManagerIcon = true;
            }
            break;
        }
      } else if (message.data['redirectTo'] == "REQUEST") {
        MyRequestsResponseDTO requestInfo = new MyRequestsResponseDTO(
          id: message.data['requestId'],
          requestNumber: message.data['requestNumber'],
          requestKind: message.data['requestKind'],
          subjectId: message.data['subjectId'],
          status: message.data['status'],
        );
        bool isApprover = message.data['approvers'].toString().contains(employeeId!);
        bool isNotifier = message.data['notifiers'].toString().contains(employeeId);
        switch (requestInfo.status) {
          case RequestStatus.statusSubmitted:
            switch (requestInfo.requestKind) {
              case RequestKind.leave:
                _submittedRequestCase(
                  context,
                  RequestKind.leave,
                  isNotifier,
                  isApprover,
                  notificationModel,
                  requestInfo,
                  1,
                );
                break;
              case RequestKind.profileUpdate:
                _submittedRequestCase(
                  context,
                  RequestKind.profileUpdate,
                  isNotifier,
                  isApprover,
                  notificationModel,
                  requestInfo,
                  0,
                );
                break;
              case RequestKind.attendanceAppealRequest:
                _submittedRequestCase(
                  context,
                  RequestKind.attendanceAppealRequest,
                  isNotifier,
                  isApprover,
                  notificationModel,
                  requestInfo,
                  2,
                );
                break;
              case RequestKind.expenseClaim:
                _submittedRequestCase(
                  context,
                  RequestKind.expenseClaim,
                  isNotifier,
                  isApprover,
                  notificationModel,
                  requestInfo,
                  3,
                );
                break;
              case RequestKind.ducoment:
                _submittedRequestCase(
                  context,
                  RequestKind.ducoment,
                  isNotifier,
                  isApprover,
                  notificationModel,
                  requestInfo,
                  4,
                );
                break;
              default:
                _navToHome();
                context.read<HomeTabIndexProvider>().index = 2;
                break;
            }
            break;
          case RequestStatus.statusNew: //Reject OR Revoke
            switch (requestInfo.requestKind) {
              case RequestKind.profileUpdate:
                if (message.data['subjectId'] == employeeId) {
                  _navToHome();
                  context.read<HomeTabIndexProvider>().index = 0;
                  _navToProfileRequestsPage();
                  _navToRequestDetails(requestInfo);
                } else {
                  _navToNotificationDetailsBody(context, notificationModel);
                }
                break;
              case RequestKind.leave:
                if (message.data['subjectId'] == employeeId) {
                  _navToHome();
                  context.read<HomeTabIndexProvider>().index = 2;
                  _navToLeaveManagement(0);
                  _navToRequestDetails(requestInfo);
                } else {
                  _navToNotificationDetailsBody(context, notificationModel);
                }
                break;
              case RequestKind.expenseClaim:
                if (message.data['subjectId'] == employeeId) {
                  _navToHome();
                  context.read<HomeTabIndexProvider>().index = 2;
                  _navToExpenseClaims(0);
                  _navToRequestDetails(requestInfo);
                } else {
                  _navToNotificationDetailsBody(context, notificationModel);
                }
                break;
              case RequestKind.attendanceAppealRequest:
                if (message.data['subjectId'] == employeeId) {
                  _navToHome();
                  context.read<HomeTabIndexProvider>().index = 2;
                  _navToAttendance(2);
                  _navToRequestDetails(requestInfo);
                } else {
                  _navToNotificationDetailsBody(context, notificationModel);
                }
                break;
              case RequestKind.ducoment:
                if (message.data['subjectId'] == employeeId) {
                  _navToHome();
                  context.read<HomeTabIndexProvider>().index = 1;
                  _navToDocuments();
                  _navToDocumentRequestsPage();
                  _navToRequestDetails(requestInfo);
                } else {
                  _navToNotificationDetailsBody(context, notificationModel);
                }
                break;
              default:
                context.read<HomeTabIndexProvider>().index = 2;
                break;
            }
            break;
          case RequestStatus.statusClosed:
            if (message.data['subjectId'] == employeeId) {
              _navToHome();
              context.read<HomeTabIndexProvider>().index = 1;
              context.read<ApprovedRequestsTabIndexProvider>().index = 0;
              _navToRequestDetails(requestInfo);
            } else if (message.data['submitterId'] == employeeId) {
              _navToHome();
              context.read<HomeTabIndexProvider>().index = 1;
              context.read<ApprovedRequestsTabIndexProvider>().index = 1;
              _navToRequestDetails(requestInfo);
            } else {
              _navToHome();
              _navToNotificationDetailsBody(
                context,
                notificationModel,
              );
            }
            break;
          case RequestStatus.statusDeleted:
            _navToNotificationDetailsBody(
              context,
              notificationModel,
            );
            break;
          default:
            _navToHome();
            context.read<HomeTabIndexProvider>().index = 2;
        }
      } else {
        _navToHome();
        context.read<HomeTabIndexProvider>().index = 2;
      }
      break;
    case "Announcement":
      String? announcementId = message.data['announcementId'];
      _navToHome();
      context.read<HomeTabIndexProvider>().index = 2;
      _navToAnnouncements();
      _navToAnnouncementDetails(announcementId);
      break;
    default:
      _navToHome();
      context.read<HomeTabIndexProvider>().index = 2;
  }
}

void _navToHome() async {
  MyApp.navigatorKey.currentState!.pushAndRemoveUntil(
    MaterialPageRoute(
      settings: RouteSettings(name: AppRoute.home),
      builder: (_) => HomePage(),
    ),
    (route) => false,
  );
}

void _navToAttendance(int tabIndex) async {
  MyApp.navigatorKey.currentState!.push(
    MaterialPageRoute(
      settings: RouteSettings(name: AppRoute.attendance),
      builder: (_) => AttendancePage(tabIndex: tabIndex),
    ),
  );
}

void _navToProfileRequestsPage() async {
  MyApp.navigatorKey.currentState!.push(
    MaterialPageRoute(builder: (_) => ProfileRequestsPage()),
  );
}

void _navToRequestDetails(MyRequestsResponseDTO requestInfo) async {
  MyApp.navigatorKey.currentState!.push(
    MaterialPageRoute(builder: (_) => RequestDetailsPage(requestInfo: requestInfo)),
  );
}

void _navToAppealManagerPage(int tabIndex) async {
  MyApp.navigatorKey.currentState!.push(
    MaterialPageRoute(
        builder: (_) => AppealManagerPage(
              tabIndex: tabIndex,
            )),
  );
}

void _navToDocuments() async {
  MyApp.navigatorKey.currentState!.push(
    MaterialPageRoute(builder: (_) => DucomentsPage()),
  );
}

void _navToLeaveManagement(int tabIndex) async {
  MyApp.navigatorKey.currentState!.push(
    MaterialPageRoute(
      settings: RouteSettings(name: AppRoute.leaveManagement),
      builder: (context) => LeaveManagementPage(
        employee: context.read<EmployeeProvider>().employee,
        tabIndex: tabIndex,
      ),
    ),
  );
}

void _navToAppealRequestDetails(String? id) async {
  MyApp.navigatorKey.currentState!.push(
    MaterialPageRoute(
      builder: (context) => AppealRequestDetailsPage(
        id: id,
        lock: Lock(),
        employeeCache: HashMap<String, EmployeeWithImage>(),
      ),
    ),
  );
}

void _navToPayslips(int tabIndex) async {
  MyApp.navigatorKey.currentState!.push(
    MaterialPageRoute(
      settings: RouteSettings(name: AppRoute.payslips),
      builder: (context) => PayslipsPage(tabIndex: tabIndex),
    ),
  );
}

void _navToExpenseClaims(int tabIndex) async {
  MyApp.navigatorKey.currentState!.push(
    MaterialPageRoute(
      settings: RouteSettings(name: AppRoute.expenseClaim),
      builder: (context) => ExpenseClaimPage(
        employee: context.read<EmployeeProvider>().employee,
        tabIndex: tabIndex,
      ),
    ),
  );
}

void _navToAnnouncements() async {
  MyApp.navigatorKey.currentState!.push(
    new MaterialPageRoute(
      builder: (context) => AnnouncementsPage(),
    ),
  );
}

void _navToNotifications() async {
  MyApp.navigatorKey.currentState!.push(
    new MaterialPageRoute(
      builder: (context) => NotificationsPage(),
    ),
  );
}

void _navToDocumentRequestsPage() async {
  MyApp.navigatorKey.currentState!.push(
    new MaterialPageRoute(
      builder: (context) => DocumentRequestsPage(),
    ),
  );
}

void _navToNotificationDetails(NotificationModel notification) async {
  MyApp.navigatorKey.currentState!.push(
    new MaterialPageRoute(
      builder: (context) => NotificationDetailsPage(notification: notification, isDeepLinking: true),
    ),
  );
}

void _navToAnnouncementDetails(String? announcementId) async {
  MyApp.navigatorKey.currentState!.push(
    new MaterialPageRoute(
      builder: (context) => AnnouncementDetailsPage(announcementId: announcementId, isDeepLinking: true),
    ),
  );
}

void _navToDecidableRequests(int tabIndex) async {
  MyApp.navigatorKey.currentState!.push(
    new MaterialPageRoute(
      builder: (context) => DecidableRequests(tabIndex: tabIndex),
    ),
  );
}

void _navToNotificationDetailsBody(BuildContext context, NotificationModel notificationModel) {
  _navToHome();
  context.read<HomeTabIndexProvider>().index = 2;
  _navToNotifications();
  _navToNotificationDetails(notificationModel);
}

void _submittedRequestCase(
  BuildContext context,
  String requestKind,
  bool isNotifier,
  bool isApprover,
  NotificationModel notificationModel,
  MyRequestsResponseDTO requestInfo,
  int decidableIndex,
) {
  _navToHome();
  context.read<HomeTabIndexProvider>().index = 2;
  if (isNotifier) {
    _notifierCase(context, notificationModel);
  } else if (isApprover) {
    if (decidableIndex == 0) {
      if (context.read<KeyProvider>().decidableProfileKey!.currentState != null)
        context.read<KeyProvider>().decidableProfileKey!.currentState!.refresh();
    } else if (decidableIndex == 1) {
      if (context.read<KeyProvider>().decidableLeaveKey!.currentState != null)
        context.read<KeyProvider>().decidableLeaveKey!.currentState!.refresh();
    } else if (decidableIndex == 2) {
      if (context.read<KeyProvider>().decidableAppealKey!.currentState != null)
        context.read<KeyProvider>().decidableAppealKey!.currentState!.refresh();
    } else if (decidableIndex == 3) {
      if (context.read<KeyProvider>().decidableExpenseKey!.currentState != null)
        context.read<KeyProvider>().decidableExpenseKey!.currentState!.refresh();
    } else if (decidableIndex == 4) {
      if (context.read<KeyProvider>().decidableDocumentKey!.currentState != null)
        context.read<KeyProvider>().decidableDocumentKey!.currentState!.refresh();
    }
    _navToDecidableRequests(decidableIndex);
  } else {
    if (requestKind == "LEAVE") {
      _navToLeaveManagement(0);
    } else if (requestKind == "EXPENSE_CLAIM") {
      _navToExpenseClaims(0);
    } else if (requestKind == "COMPANY_DOCUMENT") {
      _navToDocumentRequestsPage();
    } else if (requestKind == "ATTENDANCE_APPEAL_REQUEST") {
      _navToAttendance(2);
    } else {
      _navToProfileRequestsPage();
    }
    _navToRequestDetails(requestInfo);
  }
}

void _managerOrHRAppealCase(BuildContext context, String? appealRequestId, String appealCategory) {
  context.read<HomeTabIndexProvider>().index = 4;
  if (appealCategory == "LEAVE") {
    _navToAppealManagerPage(0);
  } else if (appealCategory == "EXPENSE_CLAIM") {
    _navToAppealManagerPage(1);
  } else if (appealCategory == "PAYROLL") {
    _navToAppealManagerPage(2);
  }
  _navToAppealRequestDetails(appealRequestId);
}

void _notifierCase(BuildContext context, NotificationModel notificationModel) {
  _navToHome();
  context.read<HomeTabIndexProvider>().index = 2;
  _navToNotifications();
  _navToNotificationDetails(notificationModel);
}
