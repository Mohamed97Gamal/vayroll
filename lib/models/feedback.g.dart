// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeFeedback _$EmployeeFeedbackFromJson(Map<String, dynamic> json) =>
    EmployeeFeedback(
      employeeId: json['employeeId'] as String?,
      employeeNumber: json['employeeNumber'] as String?,
      employeeName: json['employeeName'] as String?,
      employeeEmail: json['employeeEmail'] as String?,
      legalEntityId: json['legalEntityId'] as String?,
      legalEntityName: json['legalEntityName'] as String?,
      organizationId: json['organizationId'] as String?,
      organizationName: json['organizationName'] as String?,
      feedbackContent: json['feedbackContent'] as String?,
    );

Map<String, dynamic> _$EmployeeFeedbackToJson(EmployeeFeedback instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'employeeNumber': instance.employeeNumber,
      'employeeName': instance.employeeName,
      'employeeEmail': instance.employeeEmail,
      'legalEntityId': instance.legalEntityId,
      'legalEntityName': instance.legalEntityName,
      'organizationId': instance.organizationId,
      'organizationName': instance.organizationName,
      'feedbackContent': instance.feedbackContent,
    };
