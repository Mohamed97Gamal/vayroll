import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/widgets/pagination/custom_paged_sliver_list_view.dart';

part 'educationResponsePage.g.dart';

@JsonSerializable()
class EducationResponsePage {

  List<EducationResponseDTO>? records = [];

  int? recordsTotalCount;

  int? pagesTotalCount;

  int? pageIndex;

  int? pageSize;

  bool? hasNext;

  bool? hasPrevious;

  EducationResponsePage({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
  });

  PagedList<EducationResponseDTO> toPagedList() {
    return new PagedList<EducationResponseDTO>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }
  factory EducationResponsePage.fromJson(Map<String, dynamic> json) => _$EducationResponsePageFromJson(json);

  Map<String, dynamic> toJson() => _$EducationResponsePageToJson(this);
}
