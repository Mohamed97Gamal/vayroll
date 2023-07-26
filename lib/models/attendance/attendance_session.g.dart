// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceSession _$AttendanceSessionFromJson(Map<String, dynamic> json) =>
    AttendanceSession(
      id: json['id'] as String?,
      employeeId: json['employeeId'] as String?,
      checkInTime: json['checkInTime'] == null
          ? null
          : DateTime.parse(json['checkInTime'] as String),
      checkOutTime: json['checkOutTime'] == null
          ? null
          : DateTime.parse(json['checkOutTime'] as String),
      checkInLongitude: (json['checkInLongitude'] as num?)?.toDouble(),
      checkInLatitude: (json['checkInLatitude'] as num?)?.toDouble(),
      checkOutLongitude: (json['checkOutLongitude'] as num?)?.toDouble(),
      checkOutLatitude: (json['checkOutLatitude'] as num?)?.toDouble(),
      isManualCheckIn: json['isManualCheckIn'] as bool?,
      isManualCheckOut: json['isManualCheckOut'] as bool?,
      totalWorkingHours: (json['totalWorkingHours'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AttendanceSessionToJson(AttendanceSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'checkInTime': instance.checkInTime?.toIso8601String(),
      'checkOutTime': instance.checkOutTime?.toIso8601String(),
      'checkInLongitude': instance.checkInLongitude,
      'checkInLatitude': instance.checkInLatitude,
      'checkOutLongitude': instance.checkOutLongitude,
      'checkOutLatitude': instance.checkOutLatitude,
      'isManualCheckIn': instance.isManualCheckIn,
      'isManualCheckOut': instance.isManualCheckOut,
      'totalWorkingHours': instance.totalWorkingHours,
    };
