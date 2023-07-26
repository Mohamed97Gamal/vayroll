// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseResponse _$ExpenseResponseFromJson(Map<String, dynamic> json) =>
    ExpenseResponse()
      ..totalExpense = (json['totalExpense'] as num?)?.toDouble()
      ..expenses = (json['expenses'] as List<dynamic>?)
          ?.map((e) => Expenses.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ExpenseResponseToJson(ExpenseResponse instance) =>
    <String, dynamic>{
      'totalExpense': instance.totalExpense,
      'expenses': instance.expenses,
    };
