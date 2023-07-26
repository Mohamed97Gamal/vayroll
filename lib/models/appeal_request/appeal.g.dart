// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appeal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appeal _$AppealFromJson(Map<String, dynamic> json) => Appeal(
      id: json['id'] as String?,
      requestId: json['requestId'] as String?,
      submittedToHrManager: json['submittedToHrManager'] as bool?,
      submittedToLineManager: json['submittedToLineManager'] as bool?,
      submitterId: json['submitterId'] as String?,
      category: json['category'] as String?,
      entityReferenceNumber: json['entityReferenceNumber'] as String?,
      submissionDate: json['submissionDate'] == null
          ? null
          : DateTime.parse(json['submissionDate'] as String),
      notes: (json['notes'] as List<dynamic>?)
          ?.map((e) => AppealNote.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..categoryDisplayName = json['categoryDisplayName'] as String?;

Map<String, dynamic> _$AppealToJson(Appeal instance) => <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'submittedToHrManager': instance.submittedToHrManager,
      'submittedToLineManager': instance.submittedToLineManager,
      'submitterId': instance.submitterId,
      'category': instance.category,
      'categoryDisplayName': instance.categoryDisplayName,
      'entityReferenceNumber': instance.entityReferenceNumber,
      'submissionDate': instance.submissionDate?.toIso8601String(),
      'notes': instance.notes?.map((e) => e.toJson()).toList(),
    };
