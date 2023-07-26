import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'payroll.g.dart';

@JsonSerializable(explicitToJson: true)
class Payroll {
  String? id;
  String? payrollShortName;
  String? customPayrollType;
  PayrollCalendar? payrollCalendar;

  Payroll({
    this.id,
    this.payrollShortName,
    this.customPayrollType,
    this.payrollCalendar,
  });

  factory Payroll.fromJson(Map<String, dynamic> json) => _$PayrollFromJson(json);

  Map<String, dynamic> toJson() => _$PayrollToJson(this);
}
