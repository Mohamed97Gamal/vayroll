import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'salary.g.dart';

@JsonSerializable(explicitToJson: true)
class Salary {
  double? value;
  String? status;
  Currency? currency;

  Salary({
    this.value,
    this.status,
    this.currency,
  });

  factory Salary.fromJson(Map<String, dynamic> json) => _$SalaryFromJson(json);

  Map<String, dynamic> toJson() => _$SalaryToJson(this);
}
