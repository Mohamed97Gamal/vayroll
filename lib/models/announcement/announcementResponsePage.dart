import 'package:vayroll/models/announcement/announcement.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/widgets/pagination/custom_paged_sliver_list_view.dart';

part 'announcementResponsePage.g.dart';

@JsonSerializable()
class AnnouncementResponsePage {

  List<Announcement>? records = [];

  int? recordsTotalCount;

  int? pagesTotalCount;

  int? pageIndex;

  int? pageSize;

  bool? hasNext;

  bool? hasPrevious;

  AnnouncementResponsePage({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
  });

  PagedList<Announcement> toPagedList() {
    return new PagedList<Announcement>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }
  factory AnnouncementResponsePage.fromJson(Map<String, dynamic> json) => _$AnnouncementResponsePageFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementResponsePageToJson(this);
}
