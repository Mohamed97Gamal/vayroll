// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveResponse _$LeaveResponseFromJson(Map<String, dynamic> json) =>
    LeaveResponse()
      ..type = json['type'] as String?
      ..dates =
          (json['dates'] as List<dynamic>?)?.map((e) => e as String).toList();

Map<String, dynamic> _$LeaveResponseToJson(LeaveResponse instance) =>
    <String, dynamic>{
      'type': instance.type,
      'dates': instance.dates,
    };
