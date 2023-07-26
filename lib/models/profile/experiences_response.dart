import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'experiences_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ExperiencesResponse {
  final bool? status;
  final String? message;
  final int? code;
  final List<String>? errors;
  final List<ExperiencesResponseDTO>? result;

  ExperiencesResponse({this.status, this.message, this.code, this.errors, this.result});

  factory ExperiencesResponse.fromJson(Map<String, dynamic> json) => _$ExperiencesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExperiencesResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ExperiencesResponseDTO {
  String? id;
  String? action;
  String? companyName;
  String? title;
  bool? isCurrent;
  String? fromDate;
  String? toDate;
  String? description;
  bool? hasDeleteRequest;
  Attachment? experienceCertificate;

  factory ExperiencesResponseDTO.fromJson(Map<String, dynamic> json) => _$ExperiencesResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ExperiencesResponseDTOToJson(this);

  ExperiencesResponseDTO();
}
