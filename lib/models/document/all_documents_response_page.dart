import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/document.dart';
import 'package:vayroll/widgets/pagination/custom_paged_sliver_list_view.dart';

part 'all_documents_response_page.g.dart';

@JsonSerializable()
class AllDocumentsResponsePage {
  List<Document>? records = [];
  int? recordsTotalCount;
  int? pagesTotalCount;
  int? pageIndex;
  int? pageSize;
  bool? hasNext;
  bool? hasPrevious;

  AllDocumentsResponsePage({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
  });

  PagedList<Document> toPagedList() {
    return new PagedList<Document>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }

  factory AllDocumentsResponsePage.fromJson(Map<String, dynamic> json) => _$AllDocumentsResponsePageFromJson(json);

  Map<String, dynamic> toJson() => _$AllDocumentsResponsePageToJson(this);
}
