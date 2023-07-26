// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skills_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkillsResponse _$SkillsResponseFromJson(Map<String, dynamic> json) =>
    SkillsResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      code: json['code'] as int?,
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => SkillsResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SkillsResponseToJson(SkillsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'code': instance.code,
      'errors': instance.errors,
      'result': instance.result?.map((e) => e.toJson()).toList(),
    };

SkillsResponseDTO _$SkillsResponseDTOFromJson(Map<String, dynamic> json) =>
    SkillsResponseDTO()
      ..id = json['id'] as String?
      ..action = json['action'] as String?
      ..skillName = json['skillName'] as String?
      ..proficiency = json['proficiency'] as String?
      ..hasDeleteRequest = json['hasDeleteRequest'] as bool?;

Map<String, dynamic> _$SkillsResponseDTOToJson(SkillsResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'skillName': instance.skillName,
      'proficiency': instance.proficiency,
      'hasDeleteRequest': instance.hasDeleteRequest,
    };
