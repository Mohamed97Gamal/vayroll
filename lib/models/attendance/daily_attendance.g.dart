// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllDailyAttendanceResponse _$AllDailyAttendanceResponseFromJson(
        Map<String, dynamic> json) =>
    AllDailyAttendanceResponse(
      records: (json['records'] as List<dynamic>?)
          ?.map((e) => AttendanceSession.fromJson(e as Map<String, dynamic>))
          .toList(),
      recordsTotalCount: json['recordsTotalCount'] as int?,
      pagesTotalCount: json['pagesTotalCount'] as int?,
      pageIndex: json['pageIndex'] as int?,
      pageSize: json['pageSize'] as int?,
      hasNext: json['hasNext'] as bool?,
      hasPrevious: json['hasPrevious'] as bool?,
      totalHours: (json['totalHours'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AllDailyAttendanceResponseToJson(
        AllDailyAttendanceResponse instance) =>
    <String, dynamic>{
      'records': instance.records,
      'recordsTotalCount': instance.recordsTotalCount,
      'pagesTotalCount': instance.pagesTotalCount,
      'pageIndex': instance.pageIndex,
      'pageSize': instance.pageSize,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
      'totalHours': instance.totalHours,
    };
