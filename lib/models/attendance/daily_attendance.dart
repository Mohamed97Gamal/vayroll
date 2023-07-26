import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/widgets/widgets.dart';

part 'daily_attendance.g.dart';

@JsonSerializable()
class AllDailyAttendanceResponse {
  List<AttendanceSession>? records = [];
  int? recordsTotalCount;
  int? pagesTotalCount;
  int? pageIndex;
  int? pageSize;
  bool? hasNext;
  bool? hasPrevious;
  double? totalHours;

  AllDailyAttendanceResponse({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
    this.totalHours,
  });

  PagedList<AttendanceSession> toPagedList() {
    return new PagedList<AttendanceSession>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }

  factory AllDailyAttendanceResponse.fromJson(Map<String, dynamic> json) => _$AllDailyAttendanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AllDailyAttendanceResponseToJson(this);
}
