import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/emergency_contacts/emergency_contact.dart';
import 'package:vayroll/widgets/pagination/custom_paged_sliver_list_view.dart';

part 'emergencyContactsResponsePage.g.dart';

@JsonSerializable()
class EmergencyContactsResponsePage {

  List<EmergencyContact>? records = [];

  int? recordsTotalCount;

  int? pagesTotalCount;

  int? pageIndex;

  int? pageSize;

  bool? hasNext;

  bool? hasPrevious;

  EmergencyContactsResponsePage({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
  });

  PagedList<EmergencyContact> toPagedList() {
    return new PagedList<EmergencyContact>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }
  factory EmergencyContactsResponsePage.fromJson(Map<String, dynamic> json) => _$EmergencyContactsResponsePageFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencyContactsResponsePageToJson(this);
}
