import 'package:json_annotation/json_annotation.dart';

part 'calendar_attendance.g.dart';

@JsonSerializable()
class CalendarAttendance {
  final DateTime? date;
  final double? scheduleWorkingHours;
  final double? totalWorkingHours;
  final double? differenceWorkingHours;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final bool? isAppealed;

  CalendarAttendance({
    this.date,
    this.scheduleWorkingHours,
    this.totalWorkingHours,
    this.differenceWorkingHours,
    this.checkInTime,
    this.checkOutTime,
    this.isAppealed,
  });

  factory CalendarAttendance.fromJson(Map<String, dynamic> json) => _$CalendarAttendanceFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarAttendanceToJson(this);
}
