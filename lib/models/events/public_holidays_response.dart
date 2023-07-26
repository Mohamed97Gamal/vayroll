import 'package:json_annotation/json_annotation.dart';

part 'public_holidays_response.g.dart';

@JsonSerializable()
class PublicHolidaysResponse {
  String? code;
  String? name;
  String? date;

  factory PublicHolidaysResponse.fromJson(Map<String, dynamic> json) => _$PublicHolidaysResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PublicHolidaysResponseToJson(this);

  PublicHolidaysResponse();
}
