import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'all_document.g.dart';

@JsonSerializable()
class AllDocument {
  String? department;
  List<Document>? documents;

  AllDocument({this.department, this.documents});

  factory AllDocument.fromJson(Map<String, dynamic> json) => _$AllDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$AllDocumentToJson(this);
}
