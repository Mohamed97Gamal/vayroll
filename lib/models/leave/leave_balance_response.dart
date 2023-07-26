import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'leave_balance_response.g.dart';

@JsonSerializable(explicitToJson: true)
class LeaveBalanceResponse {
  final bool? status;
  final String? message;
  final int? code;
  final List<String>? errors;
  final List<LeaveBalanceResponseDTO>? result;

  LeaveBalanceResponse({this.status, this.message, this.code, this.errors, this.result});

  factory LeaveBalanceResponse.fromJson(Map<String, dynamic> json) => _$LeaveBalanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveBalanceResponseToJson(this);
}

@JsonSerializable()
class LeaveBalanceResponseDTO {
  String? leaveRuleName;
  String? leaveRuleId;
  String? leaveBalanceId;
  String? leaveRuleCode;
  num? currentBalance;
  num? totalBalance;
  num? maxDaysPerRequest;
  String? leaveType;
  List<LeaveBalanceResponseDTO>? customLeaveBalances;
  String? hint;
  num? sequence;
  num? carryForwardTotalAllowedBalance;
  num? carryForwardBalance;
  num? remainingNegativeBalance;
  num? maxNegativeBalance;

  num get maxNegativeBalanceMinus => -(maxNegativeBalance ?? 0);

  factory LeaveBalanceResponseDTO.fromJson(Map<String, dynamic> json) => _$LeaveBalanceResponseDTOFromJson(json);

  bool? get haveCarryForward {
    if (customLeaveBalances == null) {
      return carryForwardTotalAllowedBalance != null && carryForwardTotalAllowedBalance != 0;
    }

    return customLeaveBalances
        ?.any((element) => element.carryForwardTotalAllowedBalance != null && element.carryForwardTotalAllowedBalance != 0);
  }

  bool get haveNegative {
    if (customLeaveBalances == null) {
      return maxNegativeBalance != null && maxNegativeBalance != 0;
    }

    return customLeaveBalances!.any((element) => element.maxNegativeBalance != null && element.maxNegativeBalance != 0);
  }

  num get percentage {
    return yourBalance == 0 && yourTotalBalance == 0 ? 0.0 : min(1.0, yourBalance / yourTotalBalance);
  }

  num get yourBalance {
    if (leaveType == "REQUEST_BASED") {
      return maxDaysPerRequest ?? 0;
    }
    if (leaveType == "SELF_BALANCE") {
      return (currentBalance ?? 0) + (carryForwardBalance ?? 0) + (remainingNegativeBalance ?? 0) + 0;
    }
    return currentBalance ?? 0;
  }

  num get yourTotalBalance {
    if (leaveType == "REQUEST_BASED") {
      return maxDaysPerRequest ?? 0;
    }
    if (leaveType == "SELF_BALANCE") {
      return (totalBalance ?? 0) + (carryForwardTotalAllowedBalance ?? 0) + (maxNegativeBalance ?? 0) + 0;
    }
    return totalBalance ?? 0;
  }

  Map<String, dynamic> toJson() => _$LeaveBalanceResponseDTOToJson(this);

  LeaveBalanceResponseDTO({
    this.currentBalance,
    this.customLeaveBalances,
    this.leaveBalanceId,
    this.leaveRuleCode,
    this.leaveRuleId,
    this.leaveRuleName,
    this.leaveType,
    this.maxDaysPerRequest,
    this.totalBalance,
    this.sequence,
    this.hint,
    this.carryForwardTotalAllowedBalance,
    this.carryForwardBalance,
    this.remainingNegativeBalance,
    this.maxNegativeBalance,
  });
}
