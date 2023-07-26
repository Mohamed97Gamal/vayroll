import 'package:json_annotation/json_annotation.dart';

part 'dashboard_widget.g.dart';

@JsonSerializable()
class DashboardWidget {
  WidgetName? name;
  String? title;
  bool? active;

  DashboardWidget({
    this.name,
    this.title,
    this.active,
  });

  factory DashboardWidget.fromJson(Map<String, dynamic> json) => _$DashboardWidgetFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardWidgetToJson(this);
}

enum WidgetName {
  calendar,
  weeklyAttendance,
  birthdays,
  leaves,
  annualAttendance,
  department,
  payslips,
  expenseClaims,
}
