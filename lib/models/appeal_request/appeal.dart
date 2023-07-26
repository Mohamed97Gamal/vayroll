import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/appeal_request/appeal_note.dart';

part 'appeal.g.dart';

@JsonSerializable(explicitToJson: true)
class Appeal {
  String? id;
  String? requestId;
  bool? submittedToHrManager;
  bool? submittedToLineManager;
  String? submitterId;
  String? category;
  String? categoryDisplayName;
  String? entityReferenceNumber;
  DateTime? submissionDate;
  List<AppealNote>? notes;

  Appeal({
    this.id,
    this.requestId,
    this.submittedToHrManager,
    this.submittedToLineManager,
    this.submitterId,
    this.category,
    this.entityReferenceNumber,
    this.submissionDate,
    this.notes,
  });

  factory Appeal.fromJson(Map<String, dynamic> json) => _$AppealFromJson(json);

  Map<String, dynamic> toJson() => _$AppealToJson(this);
}
