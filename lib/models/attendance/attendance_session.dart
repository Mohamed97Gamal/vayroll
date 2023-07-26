import 'package:json_annotation/json_annotation.dart';

part 'attendance_session.g.dart';

@JsonSerializable()
class AttendanceSession {
  final String? id;
  final String? employeeId;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final double? checkInLongitude;
  final double? checkInLatitude;
  final double? checkOutLongitude;
  final double? checkOutLatitude;
  final bool? isManualCheckIn;
  final bool? isManualCheckOut;
  final double? totalWorkingHours;

  AttendanceSession({
    this.id,
    this.employeeId,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLongitude,
    this.checkInLatitude,
    this.checkOutLongitude,
    this.checkOutLatitude,
    this.isManualCheckIn,
    this.isManualCheckOut,
    this.totalWorkingHours,
  });

  factory AttendanceSession.fromJson(Map<String, dynamic> json) => _$AttendanceSessionFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceSessionToJson(this);
}
