import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'education_response.g.dart';

@JsonSerializable(explicitToJson: true)
class EducationResponse {
  final bool? status;
  final String? message;
  final int? code;
  final List<String>? errors;
  final List<EducationResponseDTO>? result;

  EducationResponse({this.status, this.message, this.code, this.errors, this.result});

  factory EducationResponse.fromJson(Map<String, dynamic> json) => _$EducationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EducationResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EducationResponseDTO {
  String? id;
  String? college;
  String? fromDate;
  String? toDate;
  String? grade;
  Attachment? certificateFile;
  String? degree;
  bool? hasDeleteRequest;

  String? action;

  factory EducationResponseDTO.fromJson(Map<String, dynamic> json) => _$EducationResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$EducationResponseDTOToJson(this);

  EducationResponseDTO();
}
