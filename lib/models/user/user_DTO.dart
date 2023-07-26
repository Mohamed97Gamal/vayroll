import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/user/color_DTO.dart';

part 'user_DTO.g.dart';

@JsonSerializable()
class UserDTO {
  String? id;
  String? name;
  String? position;
  String? email;
  List<ColorDTO>? colors;
  bool? changePasswordAtNextLogon;
  bool? acceptedDataConsent;
  bool? isFirstLogin;

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UserDTOToJson(this);

  UserDTO();
}
