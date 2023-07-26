import 'package:json_annotation/json_annotation.dart';

part 'gender_employees.g.dart';

@JsonSerializable()
class GenderEmployees {
  String? gender;
  int? numberOfEmployees;

  GenderEmployees({this.gender, this.numberOfEmployees});

  factory GenderEmployees.fromJson(Map<String, dynamic> json) => _$GenderEmployeesFromJson(json);

  Map<String, dynamic> toJson() => _$GenderEmployeesToJson(this);
}
