// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hr_email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HREmail _$HREmailFromJson(Map<String, dynamic> json) => HREmail(
      token: json['token'] as String?,
      toRecipients: (json['toRecipients'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      ccRecipients: (json['ccRecipients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      bccRecipients: (json['bccRecipients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      subject: json['subject'] as String?,
      param: json['param'] == null
          ? null
          : EmailParameter.fromJson(json['param'] as Map<String, dynamic>),
      attachment: json['attachment'] == null
          ? null
          : Attachment.fromJson(json['attachment'] as Map<String, dynamic>),
      employeeId: json['employeeId'] as String?,
      employeesGroupId: json['employeesGroupId'] as String?,
    );

Map<String, dynamic> _$HREmailToJson(HREmail instance) => <String, dynamic>{
      'token': instance.token,
      'toRecipients': instance.toRecipients,
      'ccRecipients': instance.ccRecipients,
      'bccRecipients': instance.bccRecipients,
      'subject': instance.subject,
      'param': instance.param?.toJson(),
      'attachment': instance.attachment?.toJson(),
      'employeeId': instance.employeeId,
      'employeesGroupId': instance.employeesGroupId,
    };
