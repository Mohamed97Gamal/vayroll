import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/widgets/pagination/custom_paged_sliver_list_view.dart';

part 'all_appeal.g.dart';

@JsonSerializable()
class AllAppealResponse {
  List<Appeal>? records = [];
  int? recordsTotalCount;
  int? pagesTotalCount;
  int? pageIndex;
  int? pageSize;
  bool? hasNext;
  bool? hasPrevious;

  AllAppealResponse({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
  });

  PagedList<Appeal> toPagedList() {
    return new PagedList<Appeal>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }

  factory AllAppealResponse.fromJson(Map<String, dynamic> json) => _$AllAppealResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AllAppealResponseToJson(this);
}
