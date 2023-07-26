import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'summary.g.dart';

@JsonSerializable(explicitToJson: true)
class SummaryRequestsResponse {
  final bool? status;
  final String? message;
  final int? code;
  final List<String>? errors;
  final SummaryRequestsResponseDTO? result;

  SummaryRequestsResponse({this.status, this.message, this.code, this.errors, this.result});

  factory SummaryRequestsResponse.fromJson(Map<String, dynamic> json) => _$SummaryRequestsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryRequestsResponseToJson(this);
}

@JsonSerializable()
class SummaryRequestsResponseDTO {
  RequestDetailsDTOResponse? tree;
  SummaryAttributeRequestsResponseDTO? attributes;
  List<LeaveBalanceBriefDTO>? leaveBalanceBrief;

  factory SummaryRequestsResponseDTO.fromJson(Map<String, dynamic> json) => _$SummaryRequestsResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryRequestsResponseDTOToJson(this);

  SummaryRequestsResponseDTO();
}

@JsonSerializable()
class LeaveBalanceBriefDTO {
  String? leaveTransactionId;
  String? employeeId;
  String? leaveRuleCode;
  String? leaveRuleName;
  String? originalLeaveRuleCode;
  String? originalLeaveRuleName;
  int? drawingOrder;
  double? balanceBefore;
  double? allocatedDays;
  double? balanceAfter;
  double? totalBalance;

  factory LeaveBalanceBriefDTO.fromJson(Map<String, dynamic> json) => _$LeaveBalanceBriefDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveBalanceBriefDTOToJson(this);

  LeaveBalanceBriefDTO();
}

@JsonSerializable()
class SummaryAttributeRequestsResponseDTO {
  List<RequestStateAttributesDTO>? requestStateAttributes;

  factory SummaryAttributeRequestsResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$SummaryAttributeRequestsResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryAttributeRequestsResponseDTOToJson(this);

  SummaryAttributeRequestsResponseDTO();
}
