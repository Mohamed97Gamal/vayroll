import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/widgets/pagination/custom_paged_sliver_list_view.dart';

part 'skillResponsePage.g.dart';

@JsonSerializable()
class SkillResponsePage {

  List<SkillsResponseDTO>? records = [];

  int? recordsTotalCount;

  int? pagesTotalCount;

  int? pageIndex;

  int? pageSize;

  bool? hasNext;

  bool? hasPrevious;

  SkillResponsePage({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
  });

  PagedList<SkillsResponseDTO> toPagedList() {
    return new PagedList<SkillsResponseDTO>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }
  factory SkillResponsePage.fromJson(Map<String, dynamic> json) => _$SkillResponsePageFromJson(json);

  Map<String, dynamic> toJson() => _$SkillResponsePageToJson(this);
}
