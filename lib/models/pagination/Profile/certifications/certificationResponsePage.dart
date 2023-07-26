import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/widgets/pagination/custom_paged_sliver_list_view.dart';

part 'certificationResponsePage.g.dart';

@JsonSerializable()
class CertificationResponsePage {

  List<CertificateResponseDTO>? records = [];

  int? recordsTotalCount;

  int? pagesTotalCount;

  int? pageIndex;

  int? pageSize;

  bool? hasNext;

  bool? hasPrevious;

  CertificationResponsePage({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
  });

  PagedList<CertificateResponseDTO> toPagedList() {
    return new PagedList<CertificateResponseDTO>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }
  factory CertificationResponsePage.fromJson(Map<String, dynamic> json) => _$CertificationResponsePageFromJson(json);

  Map<String, dynamic> toJson() => _$CertificationResponsePageToJson(this);
}
