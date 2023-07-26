// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attributes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttributesResponseDTO _$AttributesResponseDTOFromJson(
        Map<String, dynamic> json) =>
    AttributesResponseDTO(
      displayName: json['displayName'] as String?,
      type: json['type'] as String?,
      code: json['code'] as String?,
      value: json['value'],
    );

Map<String, dynamic> _$AttributesResponseDTOToJson(
        AttributesResponseDTO instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'type': instance.type,
      'value': instance.value,
      'code': instance.code,
    };
