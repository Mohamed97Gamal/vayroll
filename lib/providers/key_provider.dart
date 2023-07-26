import 'package:flutter/material.dart';
import 'package:vayroll/widgets/widgets.dart';

class KeyProvider {
  final RefreshNotifier homeAttendanceNotifier = RefreshNotifier();
  final RefreshNotifier homeLeaveNotifier = RefreshNotifier();
  final RefreshNotifier homeDecidableNotifier = RefreshNotifier();
  final RefreshNotifier homeCalendarNotifier = RefreshNotifier();
  final RefreshNotifier homeCheckInOutNotifier = RefreshNotifier();
  final RefreshNotifier homeAnnouncementsNotifier = RefreshNotifier();
  final RefreshNotifier homeNotificationsNotifier = RefreshNotifier();
  final RefreshNotifier homeAppealManagerNotifier = RefreshNotifier();
  GlobalKey<RefreshableState>? _payslipsKey,
      _announcementsListKey,
      _expensePageKey,
      _expensesKeyAll,
      _expensesKeyMine,
      _expensesKeyTeam,
      _leavePageKey,
      _leaveKeyAll,
      _leaveKeyMine,
      _departmentKey,
      _leaveKeyTeam,
      _decidableHomeFABKey,
      _decidableDocumentKey,
      _decidableExpenseKey,
      _decidableLeaveKey,
      _decidableProfileKey,
      _decidableAppealKey,
      _contactsCharts,
      _posisionCharts,
      _notificationListKey,
      _experneceCharts,
      _documentRequestrefreshableKey;

  KeyProvider() {
    _payslipsKey = GlobalKey<RefreshableState>();
    _announcementsListKey = GlobalKey<RefreshableState>();
    _expensePageKey = GlobalKey<RefreshableState>();
    _expensesKeyAll = GlobalKey<RefreshableState>();
    _expensesKeyMine = GlobalKey<RefreshableState>();
    _expensesKeyTeam = GlobalKey<RefreshableState>();
    _leavePageKey = GlobalKey<RefreshableState>();
    _leaveKeyAll = GlobalKey<RefreshableState>();
    _leaveKeyMine = GlobalKey<RefreshableState>();
    _leaveKeyTeam = GlobalKey<RefreshableState>();
    _departmentKey = GlobalKey<RefreshableState>();
    _decidableAppealKey = GlobalKey<RefreshableState>();
    _decidableHomeFABKey = GlobalKey<RefreshableState>();
    _decidableDocumentKey = GlobalKey<RefreshableState>();
    _decidableExpenseKey = GlobalKey<RefreshableState>();
    _decidableLeaveKey = GlobalKey<RefreshableState>();
    _decidableProfileKey = GlobalKey<RefreshableState>();
    _contactsCharts = GlobalKey<RefreshableState>();
    _posisionCharts = GlobalKey<RefreshableState>();
    _notificationListKey = GlobalKey<RefreshableState>();
    _experneceCharts = GlobalKey<RefreshableState>();
    _documentRequestrefreshableKey = GlobalKey<RefreshableState>();
  }

  GlobalKey<RefreshableState>? get payslipsKey => _payslipsKey;
  GlobalKey<RefreshableState>? get expensePageKey => _expensePageKey;
  GlobalKey<RefreshableState>? get announcementsListKey => _announcementsListKey;
  GlobalKey<RefreshableState>? get notificationListKey => _notificationListKey;
  GlobalKey<RefreshableState>? get expenseKeyAll => _expensesKeyAll;
  GlobalKey<RefreshableState>? get expenseKeyMine => _expensesKeyMine;
  GlobalKey<RefreshableState>? get expenseKeyTeam => _expensesKeyTeam;
  GlobalKey<RefreshableState>? get leavePageKey => _leavePageKey;
  GlobalKey<RefreshableState>? get leaveKeyAll => _leaveKeyAll;
  GlobalKey<RefreshableState>? get leaveKeyMine => _leaveKeyMine;
  GlobalKey<RefreshableState>? get leaveKeyTeam => _leaveKeyTeam;
  GlobalKey<RefreshableState>? get departmentKey => _departmentKey;
  GlobalKey<RefreshableState>? get decidableHomeFABKey => _decidableHomeFABKey;
  GlobalKey<RefreshableState>? get decidableAppealKey => _decidableAppealKey;
  GlobalKey<RefreshableState>? get decidableDocumentKey => _decidableDocumentKey;
  GlobalKey<RefreshableState>? get decidableExpenseKey => _decidableExpenseKey;
  GlobalKey<RefreshableState>? get decidableLeaveKey => _decidableLeaveKey;
  GlobalKey<RefreshableState>? get decidableProfileKey => _decidableProfileKey;
  GlobalKey<RefreshableState>? get contactsCharts => _contactsCharts;
  GlobalKey<RefreshableState>? get posisionCharts => _posisionCharts;
  GlobalKey<RefreshableState>? get experneceCharts => _experneceCharts;
  GlobalKey<RefreshableState>? get documentRequestrefreshableKey =>
      _documentRequestrefreshableKey;
}
