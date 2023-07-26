import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'group.g.dart';

@JsonSerializable(explicitToJson: true)
class Group extends Equatable {
  final String? id;
  final String? name;
  final Country? country;
  final BaseModel? organization;
  final Attachment? logo;
  final Currency? currency;
  final BaseModel? sector;
  final DateTime? establishmentDate;

  Group({
    this.id,
    this.name,
    this.country,
    this.organization,
    this.logo,
    this.currency,
    this.sector,
    this.establishmentDate,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  @override
  List<Object?> get props => [id, name, country, organization, logo, currency, sector];
}
