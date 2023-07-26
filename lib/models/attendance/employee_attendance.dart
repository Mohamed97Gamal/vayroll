import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'employee_attendance.g.dart';

@JsonSerializable()
class EmployeeAttendance {
  final Employee? employee;
  final CalendarAttendance? attendance;

  EmployeeAttendance({
    this.employee,
    this.attendance,
  });

  factory EmployeeAttendance.fromJson(Map<String, dynamic> json) => _$EmployeeAttendanceFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeAttendanceToJson(this);
}
