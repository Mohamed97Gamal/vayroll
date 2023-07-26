import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/announcement/notificationModel.dart';
import 'package:vayroll/widgets/pagination/custom_paged_sliver_list_view.dart';

part 'notificationResponsePage.g.dart';

@JsonSerializable()
class NotificationResponsePage {

  List<NotificationModel>? records = [];

  int? recordsTotalCount;

  int? pagesTotalCount;

  int? pageIndex;

  int? pageSize;

  bool? hasNext;

  bool? hasPrevious;

  NotificationResponsePage({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
  });

  PagedList<NotificationModel> toPagedList() {
    return new PagedList<NotificationModel>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }
  factory NotificationResponsePage.fromJson(Map<String, dynamic> json) => _$NotificationResponsePageFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponsePageToJson(this);
}
