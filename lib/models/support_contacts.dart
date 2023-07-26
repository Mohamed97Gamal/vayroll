import 'package:json_annotation/json_annotation.dart';

part 'support_contacts.g.dart';

@JsonSerializable()
class SupportContacts {
  final String? email;
  final String? phone;
  final String? workingHours;

  SupportContacts({this.email, this.phone, this.workingHours});

  factory SupportContacts.fromJson(Map<String, dynamic> json) => _$SupportContactsFromJson(json);

  Map<String, dynamic> toJson() => _$SupportContactsToJson(this);
}
