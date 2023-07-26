import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/widgets/widgets.dart';

part 'department_attendance.g.dart';

@JsonSerializable()
class DepartmentAttendanceResponse {
  List<EmployeeAttendance>? records = [];
  int? recordsTotalCount;
  int? pagesTotalCount;
  int? pageIndex;
  int? pageSize;
  bool? hasNext;
  bool? hasPrevious;
  int? present;
  int? leave;
  int? total;
  //Department department;

  DepartmentAttendanceResponse({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
    this.present,
    this.leave,
    this.total,
    //this.department,
  });

  PagedList<EmployeeAttendance> toPagedList() {
    return new PagedList<EmployeeAttendance>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }

  factory DepartmentAttendanceResponse.fromJson(Map<String, dynamic> json) =>
      _$DepartmentAttendanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentAttendanceResponseToJson(this);
}
