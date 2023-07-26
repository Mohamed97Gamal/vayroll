import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/attachment.dart';

part 'appeal_note.g.dart';

@JsonSerializable(explicitToJson: true)
class AppealNote {
  String? id;
  String? submitterId;
  String? submitterName;
  String? submitterPhotoId;
  String? note;
  DateTime? createDate;
  Attachment? attachment;

  AppealNote({
    this.id,
    this.submitterId,
    this.submitterName,
    this.submitterPhotoId,
    this.note,
    this.createDate,
    this.attachment,
  });

  factory AppealNote.fromJson(Map<String, dynamic> json) => _$AppealNoteFromJson(json);

  Map<String, dynamic> toJson() => _$AppealNoteToJson(this);
}
