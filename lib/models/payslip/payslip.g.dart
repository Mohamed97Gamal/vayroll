// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payslip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payslip _$PayslipFromJson(Map<String, dynamic> json) => Payslip(
      payrollEmployeeCalculation: json['payrollEmployeeCalculation'] == null
          ? null
          : PayrollCalculation.fromJson(
              json['payrollEmployeeCalculation'] as Map<String, dynamic>),
      reportName: json['reportName'] as String?,
      fileName: json['fileName'] as String?,
      generalStatus: json['generalStatus'] as String?,
      isAppealed: json['isAppealed'] as bool?,
      defaultPDFReport: json['defaultPDFReport'] == null
          ? null
          : Attachment.fromJson(
              json['defaultPDFReport'] as Map<String, dynamic>),
      salaries: (json['salaries'] as List<dynamic>?)
          ?.map((e) => Salary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PayslipToJson(Payslip instance) => <String, dynamic>{
      'payrollEmployeeCalculation':
          instance.payrollEmployeeCalculation?.toJson(),
      'reportName': instance.reportName,
      'fileName': instance.fileName,
      'generalStatus': instance.generalStatus,
      'isAppealed': instance.isAppealed,
      'defaultPDFReport': instance.defaultPDFReport?.toJson(),
      'salaries': instance.salaries?.map((e) => e.toJson()).toList(),
    };
