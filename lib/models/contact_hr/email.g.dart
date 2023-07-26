// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Email _$EmailFromJson(Map<String, dynamic> json) => Email(
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
      countryId: json['countryId'] as String?,
      param: json['param'] == null
          ? null
          : EmailParameter.fromJson(json['param'] as Map<String, dynamic>),
      attachment: json['attachment'] == null
          ? null
          : Attachment.fromJson(json['attachment'] as Map<String, dynamic>),
      employeeId: json['employeeId'] as String?,
      employeesGroupId: json['employeesGroupId'] as String?,
      payrollId: json['payrollId'] as String?,
      sectorId: json['sectorId'] as String?,
      employeeFullName: json['employeeFullName'] as String?,
      body: json['body'] as String?,
    );

Map<String, dynamic> _$EmailToJson(Email instance) => <String, dynamic>{
      'toRecipients': instance.toRecipients,
      'ccRecipients': instance.ccRecipients,
      'bccRecipients': instance.bccRecipients,
      'countryId': instance.countryId,
      'subject': instance.subject,
      'body': instance.body,
      'param': instance.param?.toJson(),
      'attachment': instance.attachment?.toJson(),
      'employeeId': instance.employeeId,
      'employeeFullName': instance.employeeFullName,
      'employeesGroupId': instance.employeesGroupId,
      'payrollId': instance.payrollId,
      'sectorId': instance.sectorId,
    };
