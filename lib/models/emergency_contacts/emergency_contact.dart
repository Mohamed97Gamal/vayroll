import 'package:json_annotation/json_annotation.dart';

import '../models.dart';

part 'emergency_contact.g.dart';

@JsonSerializable(explicitToJson: true)
class EmergencyContact {
  String? id;
  String? personName;
  Country? country;
  String? address;
  String? phoneNumber;
  String? action;

  EmergencyContact({this.id, this.personName, this.country, this.address, this.phoneNumber, this.action});

  factory EmergencyContact.fromJson(Map<String, dynamic> json) => _$EmergencyContactFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencyContactToJson(this);
}
