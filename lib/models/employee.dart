// ignore: implementation_imports
import 'dart:convert';
import 'dart:typed_data';

import 'package:characters/src/extensions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:synchronized/synchronized.dart';
import 'package:vayroll/models/base_model.dart';
import 'package:vayroll/models/models.dart';

part 'employee.g.dart';

@JsonSerializable(explicitToJson: true)
class Employee extends Equatable {
  final String? id;
  final String? employeeNumber;
  final String? name;
  final String? firstName;

  String get familyAcronym {
    var familyAc = familyName?.characters.elementAt(0);
    if (familyAc != null) {
      return "$familyAc.";
    }
    return "";
  }

  final String? middleName;
  final String? familyName;
  final String? fullName;
  final String? religion;
  final DateTime? hireDate;
  final String? email;
  final String? contactNumber;
  final String? address;
  final String? title;
  final String? gender;
  final DateTime? birthDate;
  final Employee? manager;
  final Country? nationality;
  final Country? residencyCountry;
  final Currency? currency;
  final BaseModel? position;
  final Department? department;
  final Group? employeesGroup;
  final bool? confirmed;
  final Attachment? photo;
  final String? photoBase64;

  @JsonKey(ignore: true)
  var lock = new Lock();
  Uint8List? _photoBytes;

  Uint8List? get photoBytes {
    lock.synchronized(() {
      if (photoBase64 == null) {
        return null;
      }
      if (_photoBytes != null) {
        return _photoBytes;
      }
      _photoBytes = base64Decode(photoBase64!);
    });
    return _photoBytes;
  }

  final String? action;
  final List<String>? roles;
  final Employee? parent;
  final bool? hasPhotoChanged;

  Employee({
    this.id,
    this.employeeNumber,
    this.name,
    this.firstName,
    this.middleName,
    this.familyName,
    this.fullName,
    this.religion,
    this.hireDate,
    this.email,
    this.contactNumber,
    this.address,
    this.title,
    this.gender,
    this.birthDate,
    this.manager,
    this.nationality,
    this.residencyCountry,
    this.currency,
    this.position,
    this.department,
    this.employeesGroup,
    this.confirmed,
    this.photo,
    this.photoBase64,
    this.action,
    this.roles,
    this.parent,
    this.hasPhotoChanged,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);

  @override
  List<Object?> get props => [
        id,
        employeeNumber,
        name,
        middleName,
        familyName,
        fullName,
        religion,
        hireDate,
        email,
        contactNumber,
        address,
        title,
        gender,
        birthDate,
        manager,
        nationality,
        residencyCountry,
        currency,
        // position,
        department,
        employeesGroup,
        confirmed,
        // photo,
        photoBase64,
        action,
        roles,
      ];

  bool hasRole(Role role) {
    return this.roles!.contains(describeEnum(role));
  }

  Employee copyWith({
    String? id,
    String? employeeNumber,
    String? name,
    String? firstName,
    String? middleName,
    String? familyName,
    String? fullName,
    String? religion,
    DateTime? hireDate,
    String? email,
    String? contactNumber,
    String? address,
    String? title,
    String? gender,
    DateTime? birthDate,
    Employee? manager,
    Country? nationality,
    Country? residencyCountry,
    Currency? currency,
    BaseModel? position,
    Department? department,
    Group? employeesGroup,
    bool? confirmed,
    Attachment? photo,
    String? photoBase64,
    String? action,
    List<String>? roles,
  }) =>
      Employee(
        id: id ?? this.id,
        employeeNumber: employeeNumber ?? this.employeeNumber,
        name: name ?? this.name,
        firstName: firstName ?? this.firstName,
        middleName: middleName ?? this.middleName,
        familyName: familyName ?? this.familyName,
        fullName: fullName ?? this.fullName,
        religion: religion ?? this.religion,
        hireDate: hireDate ?? this.hireDate,
        email: email ?? this.email,
        contactNumber: contactNumber ?? this.contactNumber,
        address: address ?? this.address,
        title: title ?? this.title,
        gender: gender ?? this.gender,
        birthDate: birthDate ?? this.birthDate,
        manager: manager ?? this.manager,
        nationality: nationality ?? this.nationality,
        residencyCountry: residencyCountry ?? this.residencyCountry,
        currency: currency ?? this.currency,
        position: position ?? this.position,
        department: department ?? this.department,
        employeesGroup: employeesGroup ?? this.employeesGroup,
        confirmed: confirmed ?? this.confirmed,
        photo: photo ?? this.photo,
        photoBase64: photoBase64 ?? this.photoBase64,
        action: action ?? this.action,
        roles: roles ?? this.roles,
      );
}
