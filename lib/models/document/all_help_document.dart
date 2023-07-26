import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/attachment.dart';
import 'package:vayroll/widgets/pagination/custom_paged_sliver_list_view.dart';

part 'all_help_document.g.dart';

@JsonSerializable()
class AllHelpDocumentsResponse {
  List<Attachment>? records = [];
  int? recordsTotalCount;
  int? pagesTotalCount;
  int? pageIndex;
  int? pageSize;
  bool? hasNext;
  bool? hasPrevious;

  AllHelpDocumentsResponse({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
  });

  PagedList<Attachment> toPagedList() {
    return new PagedList<Attachment>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }

  factory AllHelpDocumentsResponse.fromJson(Map<String, dynamic> json) => _$AllHelpDocumentsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AllHelpDocumentsResponseToJson(this);
}
