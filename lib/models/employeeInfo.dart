import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'attachment.dart';

part 'employeeInfo.g.dart';

@JsonSerializable(explicitToJson: true)
class EmployeeInfo extends Equatable {
  final String? id;
  final String? employeeNumber;
  final String? firstName;
  final String? familyName;
  final String? fullName;
  final DateTime? hireDate;
  final String? email;
  final String? contactNumber;
  final String? address;
  final String? title;
  final String? gender;
  final DateTime? birthDate;
  final Attachment? photo;

  EmployeeInfo({
    this.id,
    this.employeeNumber,
    this.firstName,
    this.familyName,
    this.fullName,
    this.hireDate,
    this.email,
    this.contactNumber,
    this.address,
    this.title,
    this.gender,
    this.birthDate,
    this.photo,
  });

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) =>
      _$EmployeeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeInfoToJson(this);

  @override
  List<Object?> get props => [
        id,
        employeeNumber,
        firstName,
        familyName,
        fullName,
        hireDate,
        email,
        contactNumber,
        address,
        title,
        gender,
        birthDate,
      ];

  EmployeeInfo copyWith({
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
    Attachment? photo,
  }) =>
      EmployeeInfo(
        id: id ?? this.id,
        employeeNumber: employeeNumber ?? this.employeeNumber,
        firstName: firstName ?? this.firstName,
        familyName: familyName ?? this.familyName,
        fullName: fullName ?? this.fullName,
        hireDate: hireDate ?? this.hireDate,
        email: email ?? this.email,
        contactNumber: contactNumber ?? this.contactNumber,
        address: address ?? this.address,
        title: title ?? this.title,
        gender: gender ?? this.gender,
        birthDate: birthDate ?? this.birthDate,
        photo: photo ?? this.photo,
      );
}
