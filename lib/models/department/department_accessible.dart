import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'department_accessible.g.dart';

@JsonSerializable()
class DepartmentAccessible extends Equatable {
  final List<Employee>? employees;
  final Department? department;

  DepartmentAccessible({
    this.employees,
    this.department,
  });

  factory DepartmentAccessible.fromJson(Map<String, dynamic> json) => _$DepartmentAccessibleFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentAccessibleToJson(this);

  @override
  List<Object?> get props => [department];
}
