import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'position_gender.g.dart';

@JsonSerializable(explicitToJson: true)
class PositionGender {
  String? position;
  List<GenderEmployees>? employeesPerGender;

  PositionGender({this.position, this.employeesPerGender});

  factory PositionGender.fromJson(Map<String, dynamic> json) => _$PositionGenderFromJson(json);

  Map<String, dynamic> toJson() => _$PositionGenderToJson(this);
}
