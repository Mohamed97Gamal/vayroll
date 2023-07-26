import 'package:json_annotation/json_annotation.dart';

part 'skills_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SkillsResponse {
  final bool? status;
  final String? message;
  final int? code;
  final List<String>? errors;
  final List<SkillsResponseDTO>? result;

  SkillsResponse({this.status, this.message, this.code, this.errors, this.result});

  factory SkillsResponse.fromJson(Map<String, dynamic> json) => _$SkillsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SkillsResponseToJson(this);
}

@JsonSerializable()
class SkillsResponseDTO {
  String? id;
  String? action;
  String? skillName;
  String? proficiency;
  bool? hasDeleteRequest;

  factory SkillsResponseDTO.fromJson(Map<String, dynamic> json) => _$SkillsResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SkillsResponseDTOToJson(this);

  SkillsResponseDTO();
}
