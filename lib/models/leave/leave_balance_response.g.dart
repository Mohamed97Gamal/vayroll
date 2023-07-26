// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_balance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveBalanceResponse _$LeaveBalanceResponseFromJson(
        Map<String, dynamic> json) =>
    LeaveBalanceResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      code: json['code'] as int?,
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      result: (json['result'] as List<dynamic>?)
          ?.map((e) =>
              LeaveBalanceResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LeaveBalanceResponseToJson(
        LeaveBalanceResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'code': instance.code,
      'errors': instance.errors,
      'result': instance.result?.map((e) => e.toJson()).toList(),
    };

LeaveBalanceResponseDTO _$LeaveBalanceResponseDTOFromJson(
        Map<String, dynamic> json) =>
    LeaveBalanceResponseDTO(
      currentBalance: json['currentBalance'] as num?,
      customLeaveBalances: (json['customLeaveBalances'] as List<dynamic>?)
          ?.map((e) =>
              LeaveBalanceResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      leaveBalanceId: json['leaveBalanceId'] as String?,
      leaveRuleCode: json['leaveRuleCode'] as String?,
      leaveRuleId: json['leaveRuleId'] as String?,
      leaveRuleName: json['leaveRuleName'] as String?,
      leaveType: json['leaveType'] as String?,
      maxDaysPerRequest: json['maxDaysPerRequest'] as num?,
      totalBalance: json['totalBalance'] as num?,
      sequence: json['sequence'] as num?,
      hint: json['hint'] as String?,
      carryForwardTotalAllowedBalance:
          json['carryForwardTotalAllowedBalance'] as num?,
      carryForwardBalance: json['carryForwardBalance'] as num?,
      remainingNegativeBalance: json['remainingNegativeBalance'] as num?,
      maxNegativeBalance: json['maxNegativeBalance'] as num?,
    );

Map<String, dynamic> _$LeaveBalanceResponseDTOToJson(
        LeaveBalanceResponseDTO instance) =>
    <String, dynamic>{
      'leaveRuleName': instance.leaveRuleName,
      'leaveRuleId': instance.leaveRuleId,
      'leaveBalanceId': instance.leaveBalanceId,
      'leaveRuleCode': instance.leaveRuleCode,
      'currentBalance': instance.currentBalance,
      'totalBalance': instance.totalBalance,
      'maxDaysPerRequest': instance.maxDaysPerRequest,
      'leaveType': instance.leaveType,
      'customLeaveBalances': instance.customLeaveBalances,
      'hint': instance.hint,
      'sequence': instance.sequence,
      'carryForwardTotalAllowedBalance':
          instance.carryForwardTotalAllowedBalance,
      'carryForwardBalance': instance.carryForwardBalance,
      'remainingNegativeBalance': instance.remainingNegativeBalance,
      'maxNegativeBalance': instance.maxNegativeBalance,
    };
