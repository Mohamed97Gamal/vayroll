import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/widgets/widgets.dart';

part 'my_requests_response.g.dart';

@JsonSerializable(explicitToJson: true)
class MyRequestsResponse {
  final bool? status;
  final String? message;
  final int? code;
  final List<String>? errors;
  final List<MyRequestsResponseDTO>? result;

  MyRequestsResponse({this.status, this.message, this.code, this.errors, this.result});

  factory MyRequestsResponse.fromJson(Map<String, dynamic> json) => _$MyRequestsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MyRequestsResponseToJson(this);
}

@JsonSerializable()
class AllRequestsResponse {
  List<MyRequestsResponseDTO>? records = [];
  int? recordsTotalCount;
  int? pagesTotalCount;
  int? pageIndex;
  int? pageSize;
  bool? hasNext;
  bool? hasPrevious;

  AllRequestsResponse({
    this.records,
    this.recordsTotalCount,
    this.pagesTotalCount,
    this.pageIndex,
    this.pageSize,
    this.hasNext,
    this.hasPrevious,
  });

  PagedList<MyRequestsResponseDTO> toPagedList() {
    return new PagedList<MyRequestsResponseDTO>()
      ..pageSize = pageSize
      ..hasPrevious = hasPrevious
      ..hasNext = hasNext
      ..pageIndex = pageIndex
      ..recordsTotalCount = recordsTotalCount
      ..pagesTotalCount = pagesTotalCount
      ..records = records;
  }

  factory AllRequestsResponse.fromJson(Map<String, dynamic> json) => _$AllRequestsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AllRequestsResponseToJson(this);
}

@JsonSerializable()
class MyRequestsResponseDTO {
  String? id;
  String? requestNumber;
  String? requestKind;
  String? subjectId;
  String? subjectDisplayName;
  String? subjectCode;
  String? subjectName;
  DateTime? submissionDate;
  String? status;
  String? requestStatusDescription;
  String? transactionClassName;
  String? transactionClassDisplayName;
  String? requestId;
  String? requestStateId;
  String? transactionUUID;
  bool? isActiveRequest;
  bool? isAppealed;
  List<AttributesResponseDTO>? attributes;
  String? requestStepId;

  MyRequestsResponseDTO({
    this.id,
    this.requestNumber,
    this.requestKind,
    this.subjectId,
    this.subjectDisplayName,
    this.subjectCode,
    this.subjectName,
    this.submissionDate,
    this.status,
    this.requestStatusDescription,
    this.transactionClassName,
    this.transactionClassDisplayName,
    this.requestId,
    this.requestStateId,
    this.transactionUUID,
    this.isActiveRequest,
    this.isAppealed,
    this.attributes,
    this.requestStepId,
  });

  factory MyRequestsResponseDTO.fromJson(Map<String, dynamic> json) => _$MyRequestsResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$MyRequestsResponseDTOToJson(this);
}
