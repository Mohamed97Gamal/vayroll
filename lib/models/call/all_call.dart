import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/widgets/pagination/custom_paged_sliver_list_view.dart';

part 'all_call.g.dart';

@JsonSerializable()
class AllCallsResponse {
  List<Call>? records = [];
  int? recordsTotalCount;
  int? pagesTotalCount;
  int? pageIndex;
  int? pageSize;
  bool? hasNext;
  bool? hasPrevious;

  AllCallsResponse({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
  });

  PagedList<Call> toPagedList() {
    return new PagedList<Call>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }

  factory AllCallsResponse.fromJson(Map<String, dynamic> json) => _$AllCallsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AllCallsResponseToJson(this);
}
