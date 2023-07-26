import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'appeal_request.g.dart';

@JsonSerializable(explicitToJson: true)
class AppealRequest {
  String? id;
  String? category;
  String? entityReferenceNumber;
  String? payrollId;
  String? requestId;
  String? submissionDate;
  bool? submittedToHrManager;
  bool? submittedToLineManager;
  String? submitterId;
  String? submitterName;
  String? submitterNote;
  String? token;
  Attachment? attachment;

  AppealRequest({
    this.id,
    this.category,
    this.entityReferenceNumber,
    this.payrollId,
    this.requestId,
    this.submissionDate,
    this.submittedToHrManager,
    this.submittedToLineManager,
    this.submitterId,
    this.submitterName,
    this.submitterNote,
    this.token,
    this.attachment,
  });

  factory AppealRequest.fromJson(Map<String, dynamic> json) => _$AppealRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AppealRequestToJson(this);
}
