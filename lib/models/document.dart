import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'document.g.dart';

@JsonSerializable(explicitToJson: true)
class Document {
  String? id;
  String? name;
  BaseModel? department;
  Group? employeesGroup;
  Attachment? attachment;

  Document({
    this.id,
    this.name,
    this.employeesGroup,
    this.attachment,
    this.department,
  });

  factory Document.fromJson(Map<String, dynamic> json) => _$DocumentFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentToJson(this);
}
