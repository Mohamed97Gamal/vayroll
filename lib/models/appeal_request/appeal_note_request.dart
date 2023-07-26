import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'appeal_note_request.g.dart';

@JsonSerializable(explicitToJson: true)
class AppealNoteRequest {
  String? appealRequestId;
  String? submitterId;
  String? employeeId;
  String? noteId;
  String? note;
  String? token;
  Attachment? attachment;

  AppealNoteRequest({
    this.appealRequestId,
    this.submitterId,
    this.employeeId,
    this.noteId,
    this.note,
    this.token,
    this.attachment,
  });

  factory AppealNoteRequest.fromJson(Map<String, dynamic> json) => _$AppealNoteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AppealNoteRequestToJson(this);
}
