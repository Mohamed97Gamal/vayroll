// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'birthdays_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BirthdaysResponse _$BirthdaysResponseFromJson(Map<String, dynamic> json) =>
    BirthdaysResponse()
      ..fullName = json['fullName'] as String?
      ..birthDate = json['birthDate'] as String?
      ..photo = json['photo'] == null
          ? null
          : Attachment.fromJson(json['photo'] as Map<String, dynamic>)
      ..id = json['id'] as String?;

Map<String, dynamic> _$BirthdaysResponseToJson(BirthdaysResponse instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'birthDate': instance.birthDate,
      'photo': instance.photo,
      'id': instance.id,
    };
