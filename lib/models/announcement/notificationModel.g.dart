// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      data: json['data'] as String?,
      image: json['image'] == null
          ? null
          : Image.fromJson(json['image'] as Map<String, dynamic>),
      isRead: json['isRead'] as bool?,
      body: json['body'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'data': instance.data,
      'image': instance.image,
      'body': instance.body,
      'isRead': instance.isRead,
      'imageUrl': instance.imageUrl,
    };
