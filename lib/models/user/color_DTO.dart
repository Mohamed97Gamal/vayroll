import 'package:json_annotation/json_annotation.dart';

part 'color_DTO.g.dart';

@JsonSerializable()
class ColorDTO {
  String? rgb;
  String? name;
  String? key;

  factory ColorDTO.fromJson(Map<String, dynamic> json) => _$ColorDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ColorDTOToJson(this);

  ColorDTO();
}
