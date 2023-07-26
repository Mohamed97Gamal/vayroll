// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expenses _$ExpensesFromJson(Map<String, dynamic> json) => Expenses()
  ..name = json['name'] as String?
  ..amount = (json['amount'] as num?)?.toDouble()
  ..percentage = (json['percentage'] as num?)?.toDouble()
  ..color = json['color'] as String?;

Map<String, dynamic> _$ExpensesToJson(Expenses instance) => <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
      'percentage': instance.percentage,
      'color': instance.color,
    };
