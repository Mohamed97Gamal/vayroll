import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'company_info.g.dart';

@JsonSerializable(explicitToJson: true)
class Company {
  String? id;
  String? name;
  Country? country;
  BaseModel? organization;
  Attachment? logo;
  Currency? currency;
  BaseModel? sector;
  int? numberOfEmployees;
  int? numberOfBackOfficers;
  int? numberOfESSUsers;
  String? legalName;
  String? activity;
  String? hrName;
  String? hrPosition;
  String? hrEmail;
  String? hrContact;
  String? aboutEntity;
  String? companyEmail;
  String? phone;
  String? address;
  String? vcode;

  Company({
    this.id,
    this.name,
    this.country,
    this.organization,
    this.currency,
    this.logo,
    this.sector,
    this.numberOfBackOfficers,
    this.numberOfESSUsers,
    this.numberOfEmployees,
    this.aboutEntity,
    this.activity,
    this.hrContact,
    this.hrEmail,
    this.hrName,
    this.hrPosition,
    this.legalName,
    this.address,
    this.companyEmail,
    this.phone,
    this.vcode,
  });

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
