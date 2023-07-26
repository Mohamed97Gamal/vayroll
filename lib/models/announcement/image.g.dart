// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Image _$ImageFromJson(Map<String, dynamic> json) => Image(
      id: json['id'] as String?,
      attachmentId: json['attachmentId'] as String?,
      extension: json['extension'] as String?,
      content:
          (json['content'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'id': instance.id,
      'attachmentId': instance.attachmentId,
      'extension': instance.extension,
      'content': instance.content,
    };
