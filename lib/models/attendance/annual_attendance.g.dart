// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annual_attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnualAttendance _$AnnualAttendanceFromJson(Map<String, dynamic> json) =>
    AnnualAttendance(
      numberOfCompanyWorkingDays:
          (json['numberOfCompanyWorkingDays'] as num?)?.toDouble(),
      numberOfEmployeeWorkingDays:
          (json['numberOfEmployeeWorkingDays'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AnnualAttendanceToJson(AnnualAttendance instance) =>
    <String, dynamic>{
      'numberOfCompanyWorkingDays': instance.numberOfCompanyWorkingDays,
      'numberOfEmployeeWorkingDays': instance.numberOfEmployeeWorkingDays,
    };
