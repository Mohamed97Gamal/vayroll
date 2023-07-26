import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/widgets/widgets.dart';

part 'department_Details.g.dart';

@JsonSerializable()
class DeaprtmentDetailsResponse {
  List<Employee>? records = [];
  int? recordsTotalCount;
  int? pagesTotalCount;
  int? pageIndex;
  int? pageSize;
  bool? hasNext;
  bool? hasPrevious;
  int? present;
  int? leave;
  int? total;
  //BaseModel department;

  DeaprtmentDetailsResponse({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
  });

  PagedList<Employee> toPagedList() {
    return new PagedList<Employee>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }

  factory DeaprtmentDetailsResponse.fromJson(Map<String, dynamic> json) => _$DeaprtmentDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeaprtmentDetailsResponseToJson(this);
}
