import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'hr_contact.g.dart';

@JsonSerializable(explicitToJson: true)
class HRContact {
  String? id;
  String? name;
  String? email;
  String? contactNumber;
  String? position;
  Group? employeesGroup;
  Attachment? photo;

  HRContact({
    this.position,
    this.id,
    this.name,
    this.email,
    this.contactNumber,
    this.employeesGroup,
    this.photo,
  });

  factory HRContact.fromJson(Map<String, dynamic> json) => _$HRContactFromJson(json);

  Map<String, dynamic> toJson() => _$HRContactToJson(this);
}
