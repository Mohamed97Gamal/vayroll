// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInOut _$CheckInOutFromJson(Map<String, dynamic> json) => CheckInOut(
      id: json['id'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      isManual: json['isManual'] as bool?,
      workingHours: (json['workingHours'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CheckInOutToJson(CheckInOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'time': instance.time?.toIso8601String(),
      'isManual': instance.isManual,
      'workingHours': instance.workingHours,
    };
