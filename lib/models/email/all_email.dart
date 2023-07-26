import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/email/email_DTO.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/widgets/pagination/custom_paged_sliver_list_view.dart';

part 'all_email.g.dart';

@JsonSerializable()
class AllEmailsResponse {
  List<EmailDTO>? records = [];
  int? recordsTotalCount;
  int? pagesTotalCount;
  int? pageIndex;
  int? pageSize;
  bool? hasNext;
  bool? hasPrevious;

  AllEmailsResponse({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
  });

  PagedList<EmailDTO> toPagedList() {
    return new PagedList<EmailDTO>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }

  factory AllEmailsResponse.fromJson(Map<String, dynamic> json) => _$AllEmailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AllEmailsResponseToJson(this);
}
