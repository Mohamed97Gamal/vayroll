// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appeal_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppealRequest _$AppealRequestFromJson(Map<String, dynamic> json) =>
    AppealRequest(
      id: json['id'] as String?,
      category: json['category'] as String?,
      entityReferenceNumber: json['entityReferenceNumber'] as String?,
      payrollId: json['payrollId'] as String?,
      requestId: json['requestId'] as String?,
      submissionDate: json['submissionDate'] as String?,
      submittedToHrManager: json['submittedToHrManager'] as bool?,
      submittedToLineManager: json['submittedToLineManager'] as bool?,
      submitterId: json['submitterId'] as String?,
      submitterName: json['submitterName'] as String?,
      submitterNote: json['submitterNote'] as String?,
      token: json['token'] as String?,
      attachment: json['attachment'] == null
          ? null
          : Attachment.fromJson(json['attachment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppealRequestToJson(AppealRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'entityReferenceNumber': instance.entityReferenceNumber,
      'payrollId': instance.payrollId,
      'requestId': instance.requestId,
      'submissionDate': instance.submissionDate,
      'submittedToHrManager': instance.submittedToHrManager,
      'submittedToLineManager': instance.submittedToLineManager,
      'submitterId': instance.submitterId,
      'submitterName': instance.submitterName,
      'submitterNote': instance.submitterNote,
      'token': instance.token,
      'attachment': instance.attachment?.toJson(),
    };
