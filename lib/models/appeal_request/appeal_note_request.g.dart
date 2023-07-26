// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appeal_note_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppealNoteRequest _$AppealNoteRequestFromJson(Map<String, dynamic> json) =>
    AppealNoteRequest(
      appealRequestId: json['appealRequestId'] as String?,
      submitterId: json['submitterId'] as String?,
      employeeId: json['employeeId'] as String?,
      noteId: json['noteId'] as String?,
      note: json['note'] as String?,
      token: json['token'] as String?,
      attachment: json['attachment'] == null
          ? null
          : Attachment.fromJson(json['attachment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppealNoteRequestToJson(AppealNoteRequest instance) =>
    <String, dynamic>{
      'appealRequestId': instance.appealRequestId,
      'submitterId': instance.submitterId,
      'employeeId': instance.employeeId,
      'noteId': instance.noteId,
      'note': instance.note,
      'token': instance.token,
      'attachment': instance.attachment?.toJson(),
    };
