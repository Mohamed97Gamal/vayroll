// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Salary _$SalaryFromJson(Map<String, dynamic> json) => Salary(
      value: (json['value'] as num?)?.toDouble(),
      status: json['status'] as String?,
      currency: json['currency'] == null
          ? null
          : Currency.fromJson(json['currency'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SalaryToJson(Salary instance) => <String, dynamic>{
      'value': instance.value,
      'status': instance.status,
      'currency': instance.currency?.toJson(),
    };
