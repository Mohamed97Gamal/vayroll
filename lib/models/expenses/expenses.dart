import 'package:json_annotation/json_annotation.dart';

part 'expenses.g.dart';

@JsonSerializable()
class Expenses {
  String? name;
  double? amount;
  double? percentage;
  String? color;

  factory Expenses.fromJson(Map<String, dynamic> json) => _$ExpensesFromJson(json);

  Map<String, dynamic> toJson() => _$ExpensesToJson(this);

  Expenses();
}
