// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      id: json['id'] as String?,
      name: json['name'] as String?,
      country: json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
      organization: json['organization'] == null
          ? null
          : BaseModel.fromJson(json['organization'] as Map<String, dynamic>),
      currency: json['currency'] == null
          ? null
          : Currency.fromJson(json['currency'] as Map<String, dynamic>),
      logo: json['logo'] == null
          ? null
          : Attachment.fromJson(json['logo'] as Map<String, dynamic>),
      sector: json['sector'] == null
          ? null
          : BaseModel.fromJson(json['sector'] as Map<String, dynamic>),
      numberOfBackOfficers: json['numberOfBackOfficers'] as int?,
      numberOfESSUsers: json['numberOfESSUsers'] as int?,
      numberOfEmployees: json['numberOfEmployees'] as int?,
      aboutEntity: json['aboutEntity'] as String?,
      activity: json['activity'] as String?,
      hrContact: json['hrContact'] as String?,
      hrEmail: json['hrEmail'] as String?,
      hrName: json['hrName'] as String?,
      hrPosition: json['hrPosition'] as String?,
      legalName: json['legalName'] as String?,
      address: json['address'] as String?,
      companyEmail: json['companyEmail'] as String?,
      phone: json['phone'] as String?,
      vcode: json['vcode'] as String?,
    );

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'country': instance.country?.toJson(),
      'organization': instance.organization?.toJson(),
      'logo': instance.logo?.toJson(),
      'currency': instance.currency?.toJson(),
      'sector': instance.sector?.toJson(),
      'numberOfEmployees': instance.numberOfEmployees,
      'numberOfBackOfficers': instance.numberOfBackOfficers,
      'numberOfESSUsers': instance.numberOfESSUsers,
      'legalName': instance.legalName,
      'activity': instance.activity,
      'hrName': instance.hrName,
      'hrPosition': instance.hrPosition,
      'hrEmail': instance.hrEmail,
      'hrContact': instance.hrContact,
      'aboutEntity': instance.aboutEntity,
      'companyEmail': instance.companyEmail,
      'phone': instance.phone,
      'address': instance.address,
      'vcode': instance.vcode,
    };
