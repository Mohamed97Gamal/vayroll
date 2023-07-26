// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appeal_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppealNote _$AppealNoteFromJson(Map<String, dynamic> json) => AppealNote(
      id: json['id'] as String?,
      submitterId: json['submitterId'] as String?,
      submitterName: json['submitterName'] as String?,
      submitterPhotoId: json['submitterPhotoId'] as String?,
      note: json['note'] as String?,
      createDate: json['createDate'] == null
          ? null
          : DateTime.parse(json['createDate'] as String),
      attachment: json['attachment'] == null
          ? null
          : Attachment.fromJson(json['attachment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppealNoteToJson(AppealNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'submitterId': instance.submitterId,
      'submitterName': instance.submitterName,
      'submitterPhotoId': instance.submitterPhotoId,
      'note': instance.note,
      'createDate': instance.createDate?.toIso8601String(),
      'attachment': instance.attachment?.toJson(),
    };
