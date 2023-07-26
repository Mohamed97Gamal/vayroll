// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_calculation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayrollCalculation _$PayrollCalculationFromJson(Map<String, dynamic> json) =>
    PayrollCalculation(
      payroll: json['payroll'] == null
          ? null
          : Payroll.fromJson(json['payroll'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PayrollCalculationToJson(PayrollCalculation instance) =>
    <String, dynamic>{
      'payroll': instance.payroll?.toJson(),
    };
