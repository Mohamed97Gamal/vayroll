import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';

part 'chart_employee.g.dart';

@JsonSerializable(explicitToJson: true)
class ChartEmployee extends Equatable {
  final String? id;
  final String? fullName;
  final BaseModel? position;
  final Attachment? photo;
  final bool? isServiceEnded;
  final ChartEmployee? externalEntity;
  final List<ChartEmployee>? subs;
  final String? type;

  ChartEmployee({
    this.id,
    this.fullName,
    this.position,
    this.photo,
    this.isServiceEnded,
    this.externalEntity,
    this.subs,
    this.type,
  });

  factory ChartEmployee.fromJson(Map<String, dynamic> json) => _$ChartEmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$ChartEmployeeToJson(this);

  @override
  List<Object?> get props => [id];

  bool isMe(BuildContext context) => id == context.read<EmployeeProvider>().employee!.id;
}
