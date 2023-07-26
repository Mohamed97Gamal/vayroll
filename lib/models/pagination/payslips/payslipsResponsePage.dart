import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/widgets/pagination/custom_paged_sliver_list_view.dart';

part 'payslipsResponsePage.g.dart';

@JsonSerializable()
class PayslipsResponsePage {

  List<Payslip>? records = [];

  int? recordsTotalCount;

  int? pagesTotalCount;

  int? pageIndex;

  int? pageSize;

  bool? hasNext;

  bool? hasPrevious;

  PayslipsResponsePage({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
  });

  PagedList<Payslip> toPagedList() {
    return new PagedList<Payslip>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }
  factory PayslipsResponsePage.fromJson(Map<String, dynamic> json) => _$PayslipsResponsePageFromJson(json);

  Map<String, dynamic> toJson() => _$PayslipsResponsePageToJson(this);
}
