import 'package:json_annotation/json_annotation.dart';

part 'email_parameter.g.dart';

@JsonSerializable()
class EmailParameter {
  String? body;

  EmailParameter({this.body});

  factory EmailParameter.fromJson(Map<String, dynamic> json) => _$EmailParameterFromJson(json);

  Map<String, dynamic> toJson() => _$EmailParameterToJson(this);
}
