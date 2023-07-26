import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'birthdays_response.g.dart';

@JsonSerializable()
class BirthdaysResponse {
  String? fullName;
  String? birthDate;
  Attachment? photo;
  String? id;

  factory BirthdaysResponse.fromJson(Map<String, dynamic> json) => _$BirthdaysResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BirthdaysResponseToJson(this);

  BirthdaysResponse();
}
