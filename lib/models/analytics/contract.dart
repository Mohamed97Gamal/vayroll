import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contract.g.dart';

@JsonSerializable()
class Contract {
  String? id;
  String? name;
  int? count;
  @ColorSerializer()
  Color? color;

  Contract({this.id, this.name, this.count, this.color});

  factory Contract.fromJson(Map<String, dynamic> json) => _$ContractFromJson(json);

  Map<String, dynamic> toJson() => _$ContractToJson(this);
}

class ColorSerializer implements JsonConverter<Color, int> {
  const ColorSerializer();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color color) => color.value;
}
