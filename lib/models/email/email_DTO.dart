import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'email_DTO.g.dart';

@JsonSerializable(explicitToJson: true)
class EmailDTO {
  String? id;
  String? emailsConfigurationsPool;
  String? subject;
  String? body;
  bool? hasAttachment;
  String? attachmentName;
  String? status;
  DateTime? scheduledSendDate;
  DateTime? sentDate;
  String? remarks;
  List<Emailler>? recipients;
  String? employeesGroupName;
  String? payrollShortName;
  String? employeeFullName;
  String? payrollEmployeeReport;
  String? templateType;
  String? emailContentType;
  Attachment? attachment;
  Emailler? sender;

  EmailDTO({
    this.attachmentName,
    this.body,
    this.emailContentType,
    this.emailsConfigurationsPool,
    this.employeeFullName,
    this.employeesGroupName,
    this.id,
    this.payrollEmployeeReport,
    this.payrollShortName,
    this.remarks,
    this.scheduledSendDate,
    this.sentDate,
    this.status,
    this.subject,
    this.templateType,
    this.attachment,
    this.recipients,
    this.hasAttachment,
  });

  factory EmailDTO.fromJson(Map<String, dynamic> json) => _$EmailDTOFromJson(json);

  Map<String, dynamic> toJson() => _$EmailDTOToJson(this);
}

@JsonSerializable()
class Emailler {
  final String? email;
  final String? name;

  Emailler({this.email, this.name});

  factory Emailler.fromJson(Map<String, dynamic> json) => _$EmaillerFromJson(json);

  Map<String, dynamic> toJson() => _$EmaillerToJson(this);
}
