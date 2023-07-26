// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_DTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDTO _$UserDTOFromJson(Map<String, dynamic> json) => UserDTO()
  ..id = json['id'] as String?
  ..name = json['name'] as String?
  ..position = json['position'] as String?
  ..email = json['email'] as String?
  ..colors = (json['colors'] as List<dynamic>?)
      ?.map((e) => ColorDTO.fromJson(e as Map<String, dynamic>))
      .toList()
  ..changePasswordAtNextLogon = json['changePasswordAtNextLogon'] as bool?
  ..acceptedDataConsent = json['acceptedDataConsent'] as bool?
  ..isFirstLogin = json['isFirstLogin'] as bool?;

Map<String, dynamic> _$UserDTOToJson(UserDTO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': instance.position,
      'email': instance.email,
      'colors': instance.colors,
      'changePasswordAtNextLogon': instance.changePasswordAtNextLogon,
      'acceptedDataConsent': instance.acceptedDataConsent,
      'isFirstLogin': instance.isFirstLogin,
    };
