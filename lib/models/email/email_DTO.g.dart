// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_DTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailDTO _$EmailDTOFromJson(Map<String, dynamic> json) => EmailDTO(
      attachmentName: json['attachmentName'] as String?,
      body: json['body'] as String?,
      emailContentType: json['emailContentType'] as String?,
      emailsConfigurationsPool: json['emailsConfigurationsPool'] as String?,
      employeeFullName: json['employeeFullName'] as String?,
      employeesGroupName: json['employeesGroupName'] as String?,
      id: json['id'] as String?,
      payrollEmployeeReport: json['payrollEmployeeReport'] as String?,
      payrollShortName: json['payrollShortName'] as String?,
      remarks: json['remarks'] as String?,
      scheduledSendDate: json['scheduledSendDate'] == null
          ? null
          : DateTime.parse(json['scheduledSendDate'] as String),
      sentDate: json['sentDate'] == null
          ? null
          : DateTime.parse(json['sentDate'] as String),
      status: json['status'] as String?,
      subject: json['subject'] as String?,
      templateType: json['templateType'] as String?,
      attachment: json['attachment'] == null
          ? null
          : Attachment.fromJson(json['attachment'] as Map<String, dynamic>),
      recipients: (json['recipients'] as List<dynamic>?)
          ?.map((e) => Emailler.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasAttachment: json['hasAttachment'] as bool?,
    )..sender = json['sender'] == null
        ? null
        : Emailler.fromJson(json['sender'] as Map<String, dynamic>);

Map<String, dynamic> _$EmailDTOToJson(EmailDTO instance) => <String, dynamic>{
      'id': instance.id,
      'emailsConfigurationsPool': instance.emailsConfigurationsPool,
      'subject': instance.subject,
      'body': instance.body,
      'hasAttachment': instance.hasAttachment,
      'attachmentName': instance.attachmentName,
      'status': instance.status,
      'scheduledSendDate': instance.scheduledSendDate?.toIso8601String(),
      'sentDate': instance.sentDate?.toIso8601String(),
      'remarks': instance.remarks,
      'recipients': instance.recipients?.map((e) => e.toJson()).toList(),
      'employeesGroupName': instance.employeesGroupName,
      'payrollShortName': instance.payrollShortName,
      'employeeFullName': instance.employeeFullName,
      'payrollEmployeeReport': instance.payrollEmployeeReport,
      'templateType': instance.templateType,
      'emailContentType': instance.emailContentType,
      'attachment': instance.attachment?.toJson(),
      'sender': instance.sender?.toJson(),
    };

Emailler _$EmaillerFromJson(Map<String, dynamic> json) => Emailler(
      email: json['email'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$EmaillerToJson(Emailler instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
    };
