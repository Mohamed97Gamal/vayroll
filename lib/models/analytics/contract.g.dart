// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contract _$ContractFromJson(Map<String, dynamic> json) => Contract(
      id: json['id'] as String?,
      name: json['name'] as String?,
      count: json['count'] as int?,
      color: _$JsonConverterFromJson<int, Color>(
          json['color'], const ColorSerializer().fromJson),
    );

Map<String, dynamic> _$ContractToJson(Contract instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'count': instance.count,
      'color': _$JsonConverterToJson<int, Color>(
          instance.color, const ColorSerializer().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
