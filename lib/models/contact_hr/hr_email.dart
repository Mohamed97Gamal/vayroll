import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'hr_email.g.dart';

@JsonSerializable(explicitToJson: true)
class HREmail {
  String? token;
  List<String?>? toRecipients;
  List<String>? ccRecipients;
  List<String>? bccRecipients;
  String? subject;
  EmailParameter? param;
  Attachment? attachment;
  String? employeeId;
  String? employeesGroupId;

  HREmail({
    this.token,
    this.toRecipients,
    this.ccRecipients,
    this.bccRecipients,
    this.subject,
    this.param,
    this.attachment,
    this.employeeId,
    this.employeesGroupId,
  });

  factory HREmail.fromJson(Map<String, dynamic> json) => _$HREmailFromJson(json);

  Map<String, dynamic> toJson() => _$HREmailToJson(this);
}
