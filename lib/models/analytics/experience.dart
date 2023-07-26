import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

@JsonSerializable()
class Experience {
  String? name;
  int? count;

  Experience({this.name, this.count});

  factory Experience.fromJson(Map<String, dynamic> json) => _$ExperienceFromJson(json);

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
