import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/widgets/widgets.dart';

part 'all_department.g.dart';

@JsonSerializable()
class AllDeaprtmentResponse {
  List<Department>? records = [];
  int? recordsTotalCount;
  int? pagesTotalCount;
  int? pageIndex;
  int? pageSize;
  bool? hasNext;
  bool? hasPrevious;
  int? present;
  int? leave;
  int? total;

  AllDeaprtmentResponse({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
    this.present,
    this.leave,
    this.total,
  });

  PagedList<Department> toPagedList() {
    return new PagedList<Department>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }

  factory AllDeaprtmentResponse.fromJson(Map<String, dynamic> json) => _$AllDeaprtmentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AllDeaprtmentResponseToJson(this);
}
