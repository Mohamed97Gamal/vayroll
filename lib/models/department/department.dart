import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'department.g.dart';

@JsonSerializable()
class Department extends Equatable {
  final String? name;
  final String? id;
  final Group? employeesGroup;
  final BaseModel? manager;

  Department({
    this.name,
    this.id,
    this.employeesGroup,
    this.manager,
  });

  factory Department.fromJson(Map<String, dynamic> json) => _$DepartmentFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentToJson(this);

  @override
  List<Object?> get props => [id, name];

  Department copyWith({
    String? id,
    String? name,
  }) =>
      Department(
        id: id ?? this.id,
        name: name ?? this.name,
      );
}
