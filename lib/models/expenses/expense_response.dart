import 'package:vayroll/models/expenses/expenses.dart';

import 'package:json_annotation/json_annotation.dart';

part 'expense_response.g.dart';

@JsonSerializable()
class ExpenseResponse {
  double? totalExpense;
  List<Expenses>? expenses;

	factory ExpenseResponse.fromJson(Map<String, dynamic> json) => _$ExpenseResponseFromJson(json);

	Map<String, dynamic> toJson() => _$ExpenseResponseToJson(this);

	ExpenseResponse();

}
