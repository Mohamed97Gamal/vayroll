import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable()
class Country extends Equatable {
  final String? id;
  final String? name;
  final String? code;

  Country({this.id, this.name, this.code});

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);

  @override
  List<Object?> get props => [id, name, code];
}
