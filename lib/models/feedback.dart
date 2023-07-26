import 'package:json_annotation/json_annotation.dart';

part 'feedback.g.dart';

@JsonSerializable(explicitToJson: true)
class EmployeeFeedback {
  final String? employeeId;
  final String? employeeNumber;
  final String? employeeName;
  final String? employeeEmail;
  final String? legalEntityId;
  final String? legalEntityName;
  final String? organizationId;
  final String? organizationName;
  final String? feedbackContent;

  EmployeeFeedback({
    this.employeeId,
    this.employeeNumber,
    this.employeeName,
    this.employeeEmail,
    this.legalEntityId,
    this.legalEntityName,
    this.organizationId,
    this.organizationName,
    this.feedbackContent,
  });

  factory EmployeeFeedback.fromJson(Map<String, dynamic> json) => _$EmployeeFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeFeedbackToJson(this);
}
