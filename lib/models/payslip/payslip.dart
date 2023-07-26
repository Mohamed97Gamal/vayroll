import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'payslip.g.dart';

@JsonSerializable(explicitToJson: true)
class Payslip {
  PayrollCalculation? payrollEmployeeCalculation;
  String? reportName;
  String? fileName;
  String? generalStatus;
  bool? isAppealed;
  Attachment? defaultPDFReport;
  List<Salary>? salaries;

  Payslip({
    this.payrollEmployeeCalculation,
    this.reportName,
    this.fileName,
    this.generalStatus,
    this.isAppealed,
    this.defaultPDFReport,
    this.salaries,
  });

  factory Payslip.fromJson(Map<String, dynamic> json) => _$PayslipFromJson(json);

  Map<String, dynamic> toJson() => _$PayslipToJson(this);
}
