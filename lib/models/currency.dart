import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

@JsonSerializable(explicitToJson: true)
class Currency extends Equatable {
  final String? id;
  final String? name;
  final String? code;

  Currency({
    this.id,
    this.name,
    this.code,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => _$CurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        code,
      ];

  Currency copyWith({
    String? id,
    String? unitName,
    String? code,
  }) =>
      Currency(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code ?? this.code,
      );
}
