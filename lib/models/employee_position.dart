import 'package:json_annotation/json_annotation.dart';

part 'employee_position.g.dart';

@JsonSerializable()
class EmployeePosition{
  final String? id;
  final String? name;

  EmployeePosition({
    this.id,
    this.name,
  });

  factory EmployeePosition.fromJson(Map<String, dynamic> json) => _$EmployeePositionFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeePositionToJson(this);
}
