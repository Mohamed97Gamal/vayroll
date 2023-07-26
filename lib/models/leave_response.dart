import 'package:json_annotation/json_annotation.dart';

part 'leave_response.g.dart';

@JsonSerializable()
class LeaveResponse {
  String? type;
  List<String>? dates;

  factory LeaveResponse.fromJson(Map<String, dynamic> json) => _$LeaveResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveResponseToJson(this);

  LeaveResponse();
}
