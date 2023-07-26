// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EducationResponse _$EducationResponseFromJson(Map<String, dynamic> json) =>
    EducationResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      code: json['code'] as int?,
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => EducationResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EducationResponseToJson(EducationResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'code': instance.code,
      'errors': instance.errors,
      'result': instance.result?.map((e) => e.toJson()).toList(),
    };

EducationResponseDTO _$EducationResponseDTOFromJson(
        Map<String, dynamic> json) =>
    EducationResponseDTO()
      ..id = json['id'] as String?
      ..college = json['college'] as String?
      ..fromDate = json['fromDate'] as String?
      ..toDate = json['toDate'] as String?
      ..grade = json['grade'] as String?
      ..certificateFile = json['certificateFile'] == null
          ? null
          : Attachment.fromJson(json['certificateFile'] as Map<String, dynamic>)
      ..degree = json['degree'] as String?
      ..hasDeleteRequest = json['hasDeleteRequest'] as bool?
      ..action = json['action'] as String?;

Map<String, dynamic> _$EducationResponseDTOToJson(
        EducationResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'college': instance.college,
      'fromDate': instance.fromDate,
      'toDate': instance.toDate,
      'grade': instance.grade,
      'certificateFile': instance.certificateFile?.toJson(),
      'degree': instance.degree,
      'hasDeleteRequest': instance.hasDeleteRequest,
      'action': instance.action,
    };
