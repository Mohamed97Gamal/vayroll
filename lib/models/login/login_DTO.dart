import 'package:json_annotation/json_annotation.dart';

part 'login_DTO.g.dart';

@JsonSerializable()
class LoginDTO {
  @JsonKey(name: "access_token")
  String? accessToken;
  @JsonKey(name: "token_type")
  String? tokenType;
  @JsonKey(name: "refresh_token")
  String? refreshToken;
  @JsonKey(name: "expires_in")
  int? expiresIn;
  String? scope;

  factory LoginDTO.fromJson(Map<String, dynamic> json) => _$LoginDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDTOToJson(this);

  LoginDTO();
}
