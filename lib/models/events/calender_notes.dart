import 'package:json_annotation/json_annotation.dart';

part 'calender_notes.g.dart';

@JsonSerializable()
class CalenderNotes {
  String? id;
  String? noteDate;
  String? title;
  String? description;

  factory CalenderNotes.fromJson(Map<String, dynamic> json) => _$CalenderNotesFromJson(json);

  Map<String, dynamic> toJson() => _$CalenderNotesToJson(this);

  CalenderNotes();
}
