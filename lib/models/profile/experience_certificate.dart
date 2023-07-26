import 'package:json_annotation/json_annotation.dart';

part 'experience_certificate.g.dart';

@JsonSerializable()
class ExperienceCertificate {
  String? id;
  String? name;
  String? extension;
  int? size;

  factory ExperienceCertificate.fromJson(Map<String, dynamic> json) => _$ExperienceCertificateFromJson(json);

  Map<String, dynamic> toJson() => _$ExperienceCertificateToJson(this);

  ExperienceCertificate();
}
