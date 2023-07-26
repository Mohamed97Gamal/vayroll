// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardWidget _$DashboardWidgetFromJson(Map<String, dynamic> json) =>
    DashboardWidget(
      name: $enumDecodeNullable(_$WidgetNameEnumMap, json['name']),
      title: json['title'] as String?,
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$DashboardWidgetToJson(DashboardWidget instance) =>
    <String, dynamic>{
      'name': _$WidgetNameEnumMap[instance.name],
      'title': instance.title,
      'active': instance.active,
    };

const _$WidgetNameEnumMap = {
  WidgetName.calendar: 'calendar',
  WidgetName.weeklyAttendance: 'weeklyAttendance',
  WidgetName.birthdays: 'birthdays',
  WidgetName.leaves: 'leaves',
  WidgetName.annualAttendance: 'annualAttendance',
  WidgetName.department: 'department',
  WidgetName.payslips: 'payslips',
  WidgetName.expenseClaims: 'expenseClaims',
};
