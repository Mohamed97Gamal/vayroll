// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      id: json['id'] as String?,
      employeeNumber: json['employeeNumber'] as String?,
      name: json['name'] as String?,
      firstName: json['firstName'] as String?,
      middleName: json['middleName'] as String?,
      familyName: json['familyName'] as String?,
      fullName: json['fullName'] as String?,
      religion: json['religion'] as String?,
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
      manager: json['manager'] == null
          ? null
          : Employee.fromJson(json['manager'] as Map<String, dynamic>),
      nationality: json['nationality'] == null
          ? null
          : Country.fromJson(json['nationality'] as Map<String, dynamic>),
      residencyCountry: json['residencyCountry'] == null
          ? null
          : Country.fromJson(json['residencyCountry'] as Map<String, dynamic>),
      currency: json['currency'] == null
          ? null
          : Currency.fromJson(json['currency'] as Map<String, dynamic>),
      position: json['position'] == null
          ? null
          : BaseModel.fromJson(json['position'] as Map<String, dynamic>),
      department: json['department'] == null
          ? null
          : Department.fromJson(json['department'] as Map<String, dynamic>),
      employeesGroup: json['employeesGroup'] == null
          ? null
          : Group.fromJson(json['employeesGroup'] as Map<String, dynamic>),
      confirmed: json['confirmed'] as bool?,
      photo: json['photo'] == null
          ? null
          : Attachment.fromJson(json['photo'] as Map<String, dynamic>),
      photoBase64: json['photoBase64'] as String?,
      action: json['action'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      parent: json['parent'] == null
          ? null
          : Employee.fromJson(json['parent'] as Map<String, dynamic>),
      hasPhotoChanged: json['hasPhotoChanged'] as bool?,
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'id': instance.id,
      'employeeNumber': instance.employeeNumber,
      'name': instance.name,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'familyName': instance.familyName,
      'fullName': instance.fullName,
      'religion': instance.religion,
      'hireDate': instance.hireDate?.toIso8601String(),
      'email': instance.email,
      'contactNumber': instance.contactNumber,
      'address': instance.address,
      'title': instance.title,
      'gender': instance.gender,
      'birthDate': instance.birthDate?.toIso8601String(),
      'manager': instance.manager?.toJson(),
      'nationality': instance.nationality?.toJson(),
      'residencyCountry': instance.residencyCountry?.toJson(),
      'currency': instance.currency?.toJson(),
      'position': instance.position?.toJson(),
      'department': instance.department?.toJson(),
      'employeesGroup': instance.employeesGroup?.toJson(),
      'confirmed': instance.confirmed,
      'photo': instance.photo?.toJson(),
      'photoBase64': instance.photoBase64,
      'action': instance.action,
      'roles': instance.roles,
      'parent': instance.parent?.toJson(),
      'hasPhotoChanged': instance.hasPhotoChanged,
    };
