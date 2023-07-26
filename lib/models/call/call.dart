import 'package:json_annotation/json_annotation.dart';

part 'call.g.dart';

@JsonSerializable()
class Call {
  final String? id;
  final String? phoneNumber;
  final Caller? caller;
  final Caller? recipient;
  final DateTime? startedAt;

  Call({this.id, this.phoneNumber, this.caller, this.recipient, this.startedAt});

  factory Call.fromJson(Map<String, dynamic> json) => _$CallFromJson(json);

  Map<String, dynamic> toJson() => _$CallToJson(this);
}

@JsonSerializable()
class Caller {
  final String? employeeId;
  final String? name;

  Caller({this.employeeId, this.name});

  factory Caller.fromJson(Map<String, dynamic> json) => _$CallerFromJson(json);

  Map<String, dynamic> toJson() => _$CallerToJson(this);
}
