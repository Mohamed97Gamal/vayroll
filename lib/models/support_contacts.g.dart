// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_contacts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportContacts _$SupportContactsFromJson(Map<String, dynamic> json) =>
    SupportContacts(
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      workingHours: json['workingHours'] as String?,
    );

Map<String, dynamic> _$SupportContactsToJson(SupportContacts instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'workingHours': instance.workingHours,
    };
