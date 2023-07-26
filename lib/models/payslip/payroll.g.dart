// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payroll _$PayrollFromJson(Map<String, dynamic> json) => Payroll(
      id: json['id'] as String?,
      payrollShortName: json['payrollShortName'] as String?,
      customPayrollType: json['customPayrollType'] as String?,
      payrollCalendar: json['payrollCalendar'] == null
          ? null
          : PayrollCalendar.fromJson(
              json['payrollCalendar'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PayrollToJson(Payroll instance) => <String, dynamic>{
      'id': instance.id,
      'payrollShortName': instance.payrollShortName,
      'customPayrollType': instance.customPayrollType,
      'payrollCalendar': instance.payrollCalendar?.toJson(),
    };
