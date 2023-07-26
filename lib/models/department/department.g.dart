// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Department _$DepartmentFromJson(Map<String, dynamic> json) => Department(
      name: json['name'] as String?,
      id: json['id'] as String?,
      employeesGroup: json['employeesGroup'] == null
          ? null
          : Group.fromJson(json['employeesGroup'] as Map<String, dynamic>),
      manager: json['manager'] == null
          ? null
          : BaseModel.fromJson(json['manager'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DepartmentToJson(Department instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'employeesGroup': instance.employeesGroup,
      'manager': instance.manager,
    };
