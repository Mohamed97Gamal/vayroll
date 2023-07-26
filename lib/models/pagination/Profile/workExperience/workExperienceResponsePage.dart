import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/widgets/pagination/custom_paged_sliver_list_view.dart';

part 'workExperienceResponsePage.g.dart';

@JsonSerializable()
class WorkExperienceResponsePage {

  List<ExperiencesResponseDTO>? records = [];

  int? recordsTotalCount;

  int? pagesTotalCount;

  int? pageIndex;

  int? pageSize;

  bool? hasNext;

  bool? hasPrevious;

  WorkExperienceResponsePage({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
  });

  PagedList<ExperiencesResponseDTO> toPagedList() {
    return new PagedList<ExperiencesResponseDTO>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }
  factory WorkExperienceResponsePage.fromJson(Map<String, dynamic> json) => _$WorkExperienceResponsePageFromJson(json);

  Map<String, dynamic> toJson() => _$WorkExperienceResponsePageToJson(this);
}
