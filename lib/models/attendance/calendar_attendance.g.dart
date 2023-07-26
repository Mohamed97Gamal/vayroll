// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarAttendance _$CalendarAttendanceFromJson(Map<String, dynamic> json) =>
    CalendarAttendance(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      scheduleWorkingHours: (json['scheduleWorkingHours'] as num?)?.toDouble(),
      totalWorkingHours: (json['totalWorkingHours'] as num?)?.toDouble(),
      differenceWorkingHours:
          (json['differenceWorkingHours'] as num?)?.toDouble(),
      checkInTime: json['checkInTime'] == null
          ? null
          : DateTime.parse(json['checkInTime'] as String),
      checkOutTime: json['checkOutTime'] == null
          ? null
          : DateTime.parse(json['checkOutTime'] as String),
      isAppealed: json['isAppealed'] as bool?,
    );

Map<String, dynamic> _$CalendarAttendanceToJson(CalendarAttendance instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'scheduleWorkingHours': instance.scheduleWorkingHours,
      'totalWorkingHours': instance.totalWorkingHours,
      'differenceWorkingHours': instance.differenceWorkingHours,
      'checkInTime': instance.checkInTime?.toIso8601String(),
      'checkOutTime': instance.checkOutTime?.toIso8601String(),
      'isAppealed': instance.isAppealed,
    };
