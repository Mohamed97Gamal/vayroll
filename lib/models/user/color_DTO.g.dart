// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_DTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColorDTO _$ColorDTOFromJson(Map<String, dynamic> json) => ColorDTO()
  ..rgb = json['rgb'] as String?
  ..name = json['name'] as String?
  ..key = json['key'] as String?;

Map<String, dynamic> _$ColorDTOToJson(ColorDTO instance) => <String, dynamic>{
      'rgb': instance.rgb,
      'name': instance.name,
      'key': instance.key,
    };
