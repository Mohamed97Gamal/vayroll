// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeAttendance _$EmployeeAttendanceFromJson(Map<String, dynamic> json) =>
    EmployeeAttendance(
      employee: json['employee'] == null
          ? null
          : Employee.fromJson(json['employee'] as Map<String, dynamic>),
      attendance: json['attendance'] == null
          ? null
          : CalendarAttendance.fromJson(
              json['attendance'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EmployeeAttendanceToJson(EmployeeAttendance instance) =>
    <String, dynamic>{
      'employee': instance.employee,
      'attendance': instance.attendance,
    };
