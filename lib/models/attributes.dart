import 'package:json_annotation/json_annotation.dart';

part 'attributes.g.dart';

@JsonSerializable()
class AttributesResponseDTO {
  String? displayName;
  String? type;
  dynamic value;
  String? code;

  factory AttributesResponseDTO.fromJson(Map<String, dynamic> json) => _$AttributesResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AttributesResponseDTOToJson(this);

  AttributesResponseDTO({this.displayName, this.type, this.code, this.value});
}
