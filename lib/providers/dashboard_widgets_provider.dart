import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/disk/disk_repo.dart';

class DashboardWidgetsProvider extends ChangeNotifier {
  List<DashboardWidget>? _widgets;

  List<DashboardWidget> get widgets => _widgets??[];

  set widgets(List<DashboardWidget> value) {
    _widgets = List.from(value);
    DiskRepo().saveWidgets(value);
    notifyListeners();
  }

  List<DashboardWidget>? getCopy() {
    var jsonWidgets = jsonEncode(_widgets);
    return (jsonDecode(jsonWidgets) as List?)
        ?.map((e) => DashboardWidget.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  DashboardWidgetsProvider() {
    init();
  }

  void init() async {
    var result = await DiskRepo().getWidgets();
    _widgets = (result != null) ? result : _initWidgets();
    notifyListeners();
  }

  List<DashboardWidget> _initWidgets() {
    var widgets = <DashboardWidget>[
      DashboardWidget(name: WidgetName.calendar, title: 'Calender', active: true),
      DashboardWidget(name: WidgetName.weeklyAttendance, title: 'Last week attendance', active: true),
      DashboardWidget(name: WidgetName.birthdays, title: 'Birthdays', active: true),
      DashboardWidget(name: WidgetName.leaves, title: 'Leave Management', active: true),
      DashboardWidget(name: WidgetName.annualAttendance, title: 'Attendance', active: true),
      DashboardWidget(name: WidgetName.department, title: 'Department Attendance', active: true),
      DashboardWidget(name: WidgetName.payslips, title: 'Pay Slips', active: true),
      DashboardWidget(name: WidgetName.expenseClaims, title: 'Expense Claim', active: true),
    ];
    DiskRepo().saveWidgets(widgets);
    return widgets;
  }
}
