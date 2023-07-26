// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_holidays_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicHolidaysResponse _$PublicHolidaysResponseFromJson(
        Map<String, dynamic> json) =>
    PublicHolidaysResponse()
      ..code = json['code'] as String?
      ..name = json['name'] as String?
      ..date = json['date'] as String?;

Map<String, dynamic> _$PublicHolidaysResponseToJson(
        PublicHolidaysResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'date': instance.date,
    };
