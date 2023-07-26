// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_accessible.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentAccessible _$DepartmentAccessibleFromJson(
        Map<String, dynamic> json) =>
    DepartmentAccessible(
      employees: (json['employees'] as List<dynamic>?)
          ?.map((e) => Employee.fromJson(e as Map<String, dynamic>))
          .toList(),
      department: json['department'] == null
          ? null
          : Department.fromJson(json['department'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DepartmentAccessibleToJson(
        DepartmentAccessible instance) =>
    <String, dynamic>{
      'employees': instance.employees,
      'department': instance.department,
    };
