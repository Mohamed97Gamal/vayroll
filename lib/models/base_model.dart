import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_model.g.dart';

@JsonSerializable()
class BaseModel extends Equatable {
  final String? id;
  final String? name;

  BaseModel({this.id, this.name});

  factory BaseModel.fromJson(Map<String, dynamic> json) => _$BaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseModelToJson(this);

  @override
  List<Object?> get props => [id, name];

  BaseModel copyWith({
    String? id,
    String? name,
  }) =>
      BaseModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );
}
