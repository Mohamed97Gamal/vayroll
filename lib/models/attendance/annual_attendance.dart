import 'package:json_annotation/json_annotation.dart';

part 'annual_attendance.g.dart';

@JsonSerializable()
class AnnualAttendance {
  final double? numberOfCompanyWorkingDays;
  final double? numberOfEmployeeWorkingDays;

  AnnualAttendance({
    this.numberOfCompanyWorkingDays,
    this.numberOfEmployeeWorkingDays,
  });

  factory AnnualAttendance.fromJson(Map<String, dynamic> json) => _$AnnualAttendanceFromJson(json);

  Map<String, dynamic> toJson() => _$AnnualAttendanceToJson(this);
}
