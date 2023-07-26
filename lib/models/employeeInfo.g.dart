// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employeeInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeInfo _$EmployeeInfoFromJson(Map<String, dynamic> json) => EmployeeInfo(
      id: json['id'] as String?,
      employeeNumber: json['employeeNumber'] as String?,
      firstName: json['firstName'] as String?,
      familyName: json['familyName'] as String?,
      fullName: json['fullName'] as String?,
      hireDate: json['hireDate'] == null
          ? null
          : DateTime.parse(json['hireDate'] as String),
      email: json['email'] as String?,
      contactNumber: json['contactNumber'] as String?,
      address: json['address'] as String?,
      title: json['title'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      photo: json['photo'] == null
          ? null
          : Attachment.fromJson(json['photo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EmployeeInfoToJson(EmployeeInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeNumber': instance.employeeNumber,
      'firstName': instance.firstName,
      'familyName': instance.familyName,
      'fullName': instance.fullName,
      'hireDate': instance.hireDate?.toIso8601String(),
      'email': instance.email,
      'contactNumber': instance.contactNumber,
      'address': instance.address,
      'title': instance.title,
      'gender': instance.gender,
      'birthDate': instance.birthDate?.toIso8601String(),
      'photo': instance.photo?.toJson(),
    };
