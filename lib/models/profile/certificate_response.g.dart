// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificateResponse _$CertificateResponseFromJson(Map<String, dynamic> json) =>
    CertificateResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      code: json['code'] as int?,
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      result: (json['result'] as List<dynamic>?)
          ?.map(
              (e) => CertificateResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CertificateResponseToJson(
        CertificateResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'code': instance.code,
      'errors': instance.errors,
      'result': instance.result?.map((e) => e.toJson()).toList(),
    };

CertificateResponseDTO _$CertificateResponseDTOFromJson(
        Map<String, dynamic> json) =>
    CertificateResponseDTO()
      ..id = json['id'] as String?
      ..action = json['action'] as String?
      ..name = json['name'] as String?
      ..issuingOrganization = json['issuingOrganization'] as String?
      ..hasExpiry = json['hasExpiry'] as bool?
      ..issueDate = json['issueDate'] as String?
      ..expiryDate = json['expiryDate'] as String?
      ..credentialId = json['credentialId'] as String?
      ..credentialUrl = json['credentialUrl'] as String?
      ..hasDeleteRequest = json['hasDeleteRequest'] as bool?
      ..attachment = json['attachment'] == null
          ? null
          : Attachment.fromJson(json['attachment'] as Map<String, dynamic>);

Map<String, dynamic> _$CertificateResponseDTOToJson(
        CertificateResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'name': instance.name,
      'issuingOrganization': instance.issuingOrganization,
      'hasExpiry': instance.hasExpiry,
      'issueDate': instance.issueDate,
      'expiryDate': instance.expiryDate,
      'credentialId': instance.credentialId,
      'credentialUrl': instance.credentialUrl,
      'hasDeleteRequest': instance.hasDeleteRequest,
      'attachment': instance.attachment,
    };
