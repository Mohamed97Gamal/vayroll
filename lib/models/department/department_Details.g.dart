// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_Details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeaprtmentDetailsResponse _$DeaprtmentDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    DeaprtmentDetailsResponse(
      records: (json['records'] as List<dynamic>?)
          ?.map((e) => Employee.fromJson(e as Map<String, dynamic>))
          .toList(),
      recordsTotalCount: json['recordsTotalCount'] as int?,
      pagesTotalCount: json['pagesTotalCount'] as int?,
      pageIndex: json['pageIndex'] as int?,
      pageSize: json['pageSize'] as int?,
      hasNext: json['hasNext'] as bool?,
      hasPrevious: json['hasPrevious'] as bool?,
    )
      ..present = json['present'] as int?
      ..leave = json['leave'] as int?
      ..total = json['total'] as int?;

Map<String, dynamic> _$DeaprtmentDetailsResponseToJson(
        DeaprtmentDetailsResponse instance) =>
    <String, dynamic>{
      'records': instance.records,
      'recordsTotalCount': instance.recordsTotalCount,
      'pagesTotalCount': instance.pagesTotalCount,
      'pageIndex': instance.pageIndex,
      'pageSize': instance.pageSize,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
      'present': instance.present,
      'leave': instance.leave,
      'total': instance.total,
    };
