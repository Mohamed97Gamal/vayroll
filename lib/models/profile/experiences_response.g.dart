// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experiences_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExperiencesResponse _$ExperiencesResponseFromJson(Map<String, dynamic> json) =>
    ExperiencesResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      code: json['code'] as int?,
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      result: (json['result'] as List<dynamic>?)
          ?.map(
              (e) => ExperiencesResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExperiencesResponseToJson(
        ExperiencesResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'code': instance.code,
      'errors': instance.errors,
      'result': instance.result?.map((e) => e.toJson()).toList(),
    };

ExperiencesResponseDTO _$ExperiencesResponseDTOFromJson(
        Map<String, dynamic> json) =>
    ExperiencesResponseDTO()
      ..id = json['id'] as String?
      ..action = json['action'] as String?
      ..companyName = json['companyName'] as String?
      ..title = json['title'] as String?
      ..isCurrent = json['isCurrent'] as bool?
      ..fromDate = json['fromDate'] as String?
      ..toDate = json['toDate'] as String?
      ..description = json['description'] as String?
      ..hasDeleteRequest = json['hasDeleteRequest'] as bool?
      ..experienceCertificate = json['experienceCertificate'] == null
          ? null
          : Attachment.fromJson(
              json['experienceCertificate'] as Map<String, dynamic>);

Map<String, dynamic> _$ExperiencesResponseDTOToJson(
        ExperiencesResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'companyName': instance.companyName,
      'title': instance.title,
      'isCurrent': instance.isCurrent,
      'fromDate': instance.fromDate,
      'toDate': instance.toDate,
      'description': instance.description,
      'hasDeleteRequest': instance.hasDeleteRequest,
      'experienceCertificate': instance.experienceCertificate?.toJson(),
    };
