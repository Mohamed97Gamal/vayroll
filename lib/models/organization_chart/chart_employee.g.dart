// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartEmployee _$ChartEmployeeFromJson(Map<String, dynamic> json) =>
    ChartEmployee(
      id: json['id'] as String?,
      fullName: json['fullName'] as String?,
      position: json['position'] == null
          ? null
          : BaseModel.fromJson(json['position'] as Map<String, dynamic>),
      photo: json['photo'] == null
          ? null
          : Attachment.fromJson(json['photo'] as Map<String, dynamic>),
      isServiceEnded: json['isServiceEnded'] as bool?,
      externalEntity: json['externalEntity'] == null
          ? null
          : ChartEmployee.fromJson(
              json['externalEntity'] as Map<String, dynamic>),
      subs: (json['subs'] as List<dynamic>?)
          ?.map((e) => ChartEmployee.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ChartEmployeeToJson(ChartEmployee instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'position': instance.position?.toJson(),
      'photo': instance.photo?.toJson(),
      'isServiceEnded': instance.isServiceEnded,
      'externalEntity': instance.externalEntity?.toJson(),
      'subs': instance.subs?.map((e) => e.toJson()).toList(),
      'type': instance.type,
    };
