// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_gender.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PositionGender _$PositionGenderFromJson(Map<String, dynamic> json) =>
    PositionGender(
      position: json['position'] as String?,
      employeesPerGender: (json['employeesPerGender'] as List<dynamic>?)
          ?.map((e) => GenderEmployees.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PositionGenderToJson(PositionGender instance) =>
    <String, dynamic>{
      'position': instance.position,
      'employeesPerGender':
          instance.employeesPerGender?.map((e) => e.toJson()).toList(),
    };
