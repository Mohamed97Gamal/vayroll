// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_certificate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExperienceCertificate _$ExperienceCertificateFromJson(
        Map<String, dynamic> json) =>
    ExperienceCertificate()
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..extension = json['extension'] as String?
      ..size = json['size'] as int?;

Map<String, dynamic> _$ExperienceCertificateToJson(
        ExperienceCertificate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'extension': instance.extension,
      'size': instance.size,
    };
