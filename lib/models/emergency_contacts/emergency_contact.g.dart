// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmergencyContact _$EmergencyContactFromJson(Map<String, dynamic> json) =>
    EmergencyContact(
      id: json['id'] as String?,
      personName: json['personName'] as String?,
      country: json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      action: json['action'] as String?,
    );

Map<String, dynamic> _$EmergencyContactToJson(EmergencyContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'personName': instance.personName,
      'country': instance.country?.toJson(),
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'action': instance.action,
    };
