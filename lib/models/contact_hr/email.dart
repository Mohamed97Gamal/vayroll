import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'email.g.dart';

@JsonSerializable(explicitToJson: true)
class Email {
  List<String?>? toRecipients;
  List<String>? ccRecipients;
  List<String>? bccRecipients;
  String? countryId;
  String? subject;
  String? body;
  EmailParameter? param;
  Attachment? attachment;
  String? employeeId;
  String? employeeFullName;
  String? employeesGroupId;
  String? payrollId;
  String? sectorId;

  Email({
    this.toRecipients,
    this.ccRecipients,
    this.bccRecipients,
    this.subject,
    this.countryId,
    this.param,
    this.attachment,
    this.employeeId,
    this.employeesGroupId,
    this.payrollId,
    this.sectorId,
    this.employeeFullName,
    this.body,
  });

  factory Email.fromJson(Map<String, dynamic> json) => _$EmailFromJson(json);

  Map<String, dynamic> toJson() => _$EmailToJson(this);
}
