import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'certificate_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CertificateResponse {
  final bool? status;
  final String? message;
  final int? code;
  final List<String>? errors;
  final List<CertificateResponseDTO>? result;

  CertificateResponse({this.status, this.message, this.code, this.errors, this.result});

  factory CertificateResponse.fromJson(Map<String, dynamic> json) => _$CertificateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CertificateResponseToJson(this);
}

@JsonSerializable()
class CertificateResponseDTO {
  String? id;
  String? action;
  String? name;
  String? issuingOrganization;
  bool? hasExpiry;
  String? issueDate;
  String? expiryDate;
  String? credentialId;
  String? credentialUrl;
  bool? hasDeleteRequest;
  Attachment? attachment;

  factory CertificateResponseDTO.fromJson(Map<String, dynamic> json) => _$CertificateResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CertificateResponseDTOToJson(this);

  CertificateResponseDTO();
}
