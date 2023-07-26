// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gender_employees.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenderEmployees _$GenderEmployeesFromJson(Map<String, dynamic> json) =>
    GenderEmployees(
      gender: json['gender'] as String?,
      numberOfEmployees: json['numberOfEmployees'] as int?,
    );

Map<String, dynamic> _$GenderEmployeesToJson(GenderEmployees instance) =>
    <String, dynamic>{
      'gender': instance.gender,
      'numberOfEmployees': instance.numberOfEmployees,
    };
