// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Call _$CallFromJson(Map<String, dynamic> json) => Call(
      id: json['id'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      caller: json['caller'] == null
          ? null
          : Caller.fromJson(json['caller'] as Map<String, dynamic>),
      recipient: json['recipient'] == null
          ? null
          : Caller.fromJson(json['recipient'] as Map<String, dynamic>),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
    );

Map<String, dynamic> _$CallToJson(Call instance) => <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'caller': instance.caller,
      'recipient': instance.recipient,
      'startedAt': instance.startedAt?.toIso8601String(),
    };

Caller _$CallerFromJson(Map<String, dynamic> json) => Caller(
      employeeId: json['employeeId'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$CallerToJson(Caller instance) => <String, dynamic>{
      'employeeId': instance.employeeId,
      'name': instance.name,
    };
