// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
      id: json['id'] as String?,
      title: json['title'] as String?,
      text: json['text'] as String?,
      attachment: json['attachment'] == null
          ? null
          : Image.fromJson(json['attachment'] as Map<String, dynamic>),
      isRead: json['isRead'] as bool?,
      body: json['body'] as String?,
    );

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'text': instance.text,
      'attachment': instance.attachment,
      'body': instance.body,
      'isRead': instance.isRead,
    };
