// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayrollCalendar _$PayrollCalendarFromJson(Map<String, dynamic> json) =>
    PayrollCalendar(
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$PayrollCalendarToJson(PayrollCalendar instance) =>
    <String, dynamic>{
      'endDate': instance.endDate?.toIso8601String(),
    };
