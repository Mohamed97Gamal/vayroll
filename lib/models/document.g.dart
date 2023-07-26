// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) => Document(
      id: json['id'] as String?,
      name: json['name'] as String?,
      employeesGroup: json['employeesGroup'] == null
          ? null
          : Group.fromJson(json['employeesGroup'] as Map<String, dynamic>),
      attachment: json['attachment'] == null
          ? null
          : Attachment.fromJson(json['attachment'] as Map<String, dynamic>),
      department: json['department'] == null
          ? null
          : BaseModel.fromJson(json['department'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'department': instance.department?.toJson(),
      'employeesGroup': instance.employeesGroup?.toJson(),
      'attachment': instance.attachment?.toJson(),
    };
