// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      id: json['id'] as String?,
      name: json['name'] as String?,
      country: json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
      organization: json['organization'] == null
          ? null
          : BaseModel.fromJson(json['organization'] as Map<String, dynamic>),
      logo: json['logo'] == null
          ? null
          : Attachment.fromJson(json['logo'] as Map<String, dynamic>),
      currency: json['currency'] == null
          ? null
          : Currency.fromJson(json['currency'] as Map<String, dynamic>),
      sector: json['sector'] == null
          ? null
          : BaseModel.fromJson(json['sector'] as Map<String, dynamic>),
      establishmentDate: json['establishmentDate'] == null
          ? null
          : DateTime.parse(json['establishmentDate'] as String),
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'country': instance.country?.toJson(),
      'organization': instance.organization?.toJson(),
      'logo': instance.logo?.toJson(),
      'currency': instance.currency?.toJson(),
      'sector': instance.sector?.toJson(),
      'establishmentDate': instance.establishmentDate?.toIso8601String(),
    };
