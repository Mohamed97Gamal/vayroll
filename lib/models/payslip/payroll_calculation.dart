import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'payroll_calculation.g.dart';

@JsonSerializable(explicitToJson: true)
class PayrollCalculation {
  Payroll? payroll;

  PayrollCalculation({this.payroll});

  factory PayrollCalculation.fromJson(Map<String, dynamic> json) => _$PayrollCalculationFromJson(json);

  Map<String, dynamic> toJson() => _$PayrollCalculationToJson(this);
}
