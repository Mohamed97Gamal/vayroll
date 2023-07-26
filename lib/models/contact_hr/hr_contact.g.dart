// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hr_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HRContact _$HRContactFromJson(Map<String, dynamic> json) => HRContact(
      position: json['position'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      contactNumber: json['contactNumber'] as String?,
      employeesGroup: json['employeesGroup'] == null
          ? null
          : Group.fromJson(json['employeesGroup'] as Map<String, dynamic>),
      photo: json['photo'] == null
          ? null
          : Attachment.fromJson(json['photo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HRContactToJson(HRContact instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'contactNumber': instance.contactNumber,
      'position': instance.position,
      'employeesGroup': instance.employeesGroup?.toJson(),
      'photo': instance.photo?.toJson(),
    };
