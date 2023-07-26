// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummaryRequestsResponse _$SummaryRequestsResponseFromJson(
        Map<String, dynamic> json) =>
    SummaryRequestsResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      code: json['code'] as int?,
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      result: json['result'] == null
          ? null
          : SummaryRequestsResponseDTO.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SummaryRequestsResponseToJson(
        SummaryRequestsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'code': instance.code,
      'errors': instance.errors,
      'result': instance.result?.toJson(),
    };

SummaryRequestsResponseDTO _$SummaryRequestsResponseDTOFromJson(
        Map<String, dynamic> json) =>
    SummaryRequestsResponseDTO()
      ..tree = json['tree'] == null
          ? null
          : RequestDetailsDTOResponse.fromJson(
              json['tree'] as Map<String, dynamic>)
      ..attributes = json['attributes'] == null
          ? null
          : SummaryAttributeRequestsResponseDTO.fromJson(
              json['attributes'] as Map<String, dynamic>)
      ..leaveBalanceBrief = (json['leaveBalanceBrief'] as List<dynamic>?)
          ?.map((e) => LeaveBalanceBriefDTO.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$SummaryRequestsResponseDTOToJson(
        SummaryRequestsResponseDTO instance) =>
    <String, dynamic>{
      'tree': instance.tree,
      'attributes': instance.attributes,
      'leaveBalanceBrief': instance.leaveBalanceBrief,
    };

LeaveBalanceBriefDTO _$LeaveBalanceBriefDTOFromJson(
        Map<String, dynamic> json) =>
    LeaveBalanceBriefDTO()
      ..leaveTransactionId = json['leaveTransactionId'] as String?
      ..employeeId = json['employeeId'] as String?
      ..leaveRuleCode = json['leaveRuleCode'] as String?
      ..leaveRuleName = json['leaveRuleName'] as String?
      ..originalLeaveRuleCode = json['originalLeaveRuleCode'] as String?
      ..originalLeaveRuleName = json['originalLeaveRuleName'] as String?
      ..drawingOrder = json['drawingOrder'] as int?
      ..balanceBefore = (json['balanceBefore'] as num?)?.toDouble()
      ..allocatedDays = (json['allocatedDays'] as num?)?.toDouble()
      ..balanceAfter = (json['balanceAfter'] as num?)?.toDouble()
      ..totalBalance = (json['totalBalance'] as num?)?.toDouble();

Map<String, dynamic> _$LeaveBalanceBriefDTOToJson(
        LeaveBalanceBriefDTO instance) =>
    <String, dynamic>{
      'leaveTransactionId': instance.leaveTransactionId,
      'employeeId': instance.employeeId,
      'leaveRuleCode': instance.leaveRuleCode,
      'leaveRuleName': instance.leaveRuleName,
      'originalLeaveRuleCode': instance.originalLeaveRuleCode,
      'originalLeaveRuleName': instance.originalLeaveRuleName,
      'drawingOrder': instance.drawingOrder,
      'balanceBefore': instance.balanceBefore,
      'allocatedDays': instance.allocatedDays,
      'balanceAfter': instance.balanceAfter,
      'totalBalance': instance.totalBalance,
    };

SummaryAttributeRequestsResponseDTO
    _$SummaryAttributeRequestsResponseDTOFromJson(Map<String, dynamic> json) =>
        SummaryAttributeRequestsResponseDTO()
          ..requestStateAttributes = (json['requestStateAttributes']
                  as List<dynamic>?)
              ?.map((e) =>
                  RequestStateAttributesDTO.fromJson(e as Map<String, dynamic>))
              .toList();

Map<String, dynamic> _$SummaryAttributeRequestsResponseDTOToJson(
        SummaryAttributeRequestsResponseDTO instance) =>
    <String, dynamic>{
      'requestStateAttributes': instance.requestStateAttributes,
    };
