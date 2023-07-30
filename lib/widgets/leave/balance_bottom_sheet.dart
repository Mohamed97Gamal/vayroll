import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';

Future<bool?> showLeaveBalanceBottomSheet({
  required BuildContext context,
  LeaveBalanceResponseDTO? leaveBalanceInfo,
}) async {
  return await showModalBottomSheet<bool>(
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
    ),
    builder: (BuildContext context) => WillPopScope(
      onWillPop: () async => true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${leaveBalanceInfo!.leaveRuleName} Details",
              style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 16),
            Center(
              child: CircularPercentIndicator(
                radius: 45.0,
                lineWidth: 8.0,
                percent: max(
                  0.0,
                  min(
                    1.0,
                    leaveBalanceInfo.yourBalance /
                        (leaveBalanceInfo.yourTotalBalance <= (leaveBalanceInfo.maxNegativeBalance ?? 0)
                            ? 1
                            : leaveBalanceInfo.yourTotalBalance),
                  ),
                ),
                center: Text(
                  "${(leaveBalanceInfo.yourBalance.isInt ? leaveBalanceInfo.yourBalance.toStringAsFixed(0) : leaveBalanceInfo.yourBalance.toStringAsFixed(1))}",
                  style: TextStyle(
                    color: leaveBalanceInfo.yourBalance == 0 ? Color(0xFF99B1C3) : Theme.of(context).colorScheme.secondary,
                  ),
                ),
                progressColor: Theme.of(context).colorScheme.secondary,
                backgroundColor: DefaultThemeColors.nepal,
              ),
            ),
            SizedBox(height: 8),
            Divider(
              height: 10,
              thickness: 1,
              indent: 0,
              color: DefaultThemeColors.whiteSmoke1,
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (leaveBalanceInfo.customLeaveBalances != null &&
                    (leaveBalanceInfo.haveNegative || leaveBalanceInfo.haveCarryForward!))
                  for (final subtype in leaveBalanceInfo.customLeaveBalances!) LeaveBalanceWidget(leaveBalanceInfo: subtype),
                if (leaveBalanceInfo.customLeaveBalances != null &&
                    !leaveBalanceInfo.haveNegative &&
                    !leaveBalanceInfo.haveCarryForward!)
                  AllLeaveBalanceWidget(leaveBalanceInfo: leaveBalanceInfo),
                if (leaveBalanceInfo.customLeaveBalances == null)
                  LeaveBalanceWidget(leaveBalanceInfo: leaveBalanceInfo, showTotal: true),
                SizedBox(height: 8),
                Divider(
                  height: 10,
                  thickness: 1,
                  indent: 0,
                  color: DefaultThemeColors.whiteSmoke1,
                ),
                if (leaveBalanceInfo.customLeaveBalances != null &&
                    (leaveBalanceInfo.haveNegative || leaveBalanceInfo.haveCarryForward!))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Row(
                      children: [
                        Text(
                          "Total Balance",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          "${(leaveBalanceInfo.yourBalance.isInt ? leaveBalanceInfo.yourBalance.toStringAsFixed(0) : leaveBalanceInfo.yourBalance.toStringAsFixed(1))}   /   ${(leaveBalanceInfo.yourTotalBalance.isInt ? leaveBalanceInfo.yourTotalBalance.toStringAsFixed(0) : leaveBalanceInfo.yourTotalBalance.toStringAsFixed(1))}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              children: [
                colorsName(context, "Used Balance",Color(0xFF99B1C3)),
                if (leaveBalanceInfo.yourTotalBalance != 0)
                  colorsName(context, "Your Balance", Theme.of(context).colorScheme.secondary),
                if (leaveBalanceInfo.haveCarryForward!) colorsName(context, "Carry Forward", DefaultThemeColors.darkPink),
                if (leaveBalanceInfo.yourTotalBalance != 0)
                  colorsName(context, "Current Year Balance", DefaultThemeColors.prussianBlue),
                if (leaveBalanceInfo.haveNegative) colorsName(context, "Negative", DefaultThemeColors.brass),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class AllLeaveBalanceWidget extends StatelessWidget {
  final LeaveBalanceResponseDTO? leaveBalanceInfo;

  const AllLeaveBalanceWidget({
    Key? key,
    required this.leaveBalanceInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (final subtype in leaveBalanceInfo!.customLeaveBalances!)
              LeaveBalanceWidget(
                leaveBalanceInfo: subtype,
                showCard: false,
              ),
            SizedBox(height: 8),
            Divider(
              height: 10,
              thickness: 1,
              indent: 0,
              color: DefaultThemeColors.whiteSmoke1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  Text(
                    "Total Balance",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Text(
                    "${(leaveBalanceInfo!.yourBalance.isInt ? leaveBalanceInfo!.yourBalance.toStringAsFixed(0) : leaveBalanceInfo!.yourBalance.toStringAsFixed(1))}   /   ${(leaveBalanceInfo!.yourTotalBalance.isInt ? leaveBalanceInfo!.yourTotalBalance.toStringAsFixed(0) : leaveBalanceInfo!.yourTotalBalance.toStringAsFixed(1))}",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaveBalanceWidget extends StatelessWidget {
  final LeaveBalanceResponseDTO? leaveBalanceInfo;
  final bool showTotal;
  final bool showCard;

  const LeaveBalanceWidget({
    Key? key,
    required this.leaveBalanceInfo,
    this.showTotal = false,
    this.showCard = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: showCard ? null : EdgeInsets.zero,
      color: showCard ? null : Colors.transparent,
      elevation: showCard ? 4.0 : 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(showCard ? 8.0 : 0.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(showCard ? 16.0 : 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leaveBalanceInfo!.yourTotalBalance == 0)
              Row(
                children: [
                  SvgPicture.asset(
                    VPayIcons.info,
                    height: 40.0,
                    width: 40.0,
                    fit: BoxFit.scaleDown,
                    color: Color(0xFF99B1C3),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      "You already consumed your ${leaveBalanceInfo!.leaveRuleName} Balance",
                      style: TextStyle(color: Color(0xFF99B1C3)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            if (leaveBalanceInfo!.yourTotalBalance != 0)
              Text(
                leaveBalanceInfo!.leaveRuleName!,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      fontFamily: Fonts.montserrat,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            if (leaveBalanceInfo!.yourTotalBalance != 0) SizedBox(height: 2.0),
            if (leaveBalanceInfo!.carryForwardTotalAllowedBalance != null && leaveBalanceInfo!.carryForwardTotalAllowedBalance != 0)
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      lineHeight: 5.0,
                      percent: max(
                        0.0,
                        min(
                          1.0,
                          leaveBalanceInfo!.carryForwardBalance! / leaveBalanceInfo!.carryForwardTotalAllowedBalance!,
                        ),
                      ),
                      progressColor: DefaultThemeColors.darkPink,
                      backgroundColor: DefaultThemeColors.nepal,
                    ),
                  ),
                  SizedBox(width: 32.0),
                  Expanded(
                    flex: 4,
                    child: FittedBox(
                      child: Row(
                        children: [
                          Text(
                            (leaveBalanceInfo!.carryForwardBalance!.isInt
                                ? leaveBalanceInfo!.carryForwardBalance!.toStringAsFixed(0)
                                : leaveBalanceInfo!.carryForwardBalance!.toStringAsFixed(1)),
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  fontFamily: Fonts.montserrat,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "out of ${(leaveBalanceInfo!.carryForwardTotalAllowedBalance!.isInt ? leaveBalanceInfo!.carryForwardTotalAllowedBalance!.toStringAsFixed(0) : leaveBalanceInfo!.carryForwardTotalAllowedBalance!.toStringAsFixed(1))} allowed",
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  fontFamily: Fonts.montserrat,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (leaveBalanceInfo!.carryForwardTotalAllowedBalance != null && leaveBalanceInfo!.carryForwardTotalAllowedBalance != 0)
              SizedBox(height: 2.0),
            if (leaveBalanceInfo!.totalBalance != null && leaveBalanceInfo!.totalBalance != 0)
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      lineHeight: 5.0,
                      percent: leaveBalanceInfo!.currentBalance! / leaveBalanceInfo!.totalBalance! < 0
                          ? 0
                          : min(1.0, leaveBalanceInfo!.currentBalance! / leaveBalanceInfo!.totalBalance!),
                      progressColor: Theme.of(context).primaryColor,
                      backgroundColor: DefaultThemeColors.nepal,
                    ),
                  ),
                  SizedBox(width: 32.0),
                  Expanded(
                    flex: 4,
                    child: FittedBox(
                      child: Row(
                        children: [
                          Text(
                            (leaveBalanceInfo!.currentBalance!.isInt
                                ? leaveBalanceInfo!.currentBalance!.toStringAsFixed(0)
                                : leaveBalanceInfo!.currentBalance!.toStringAsFixed(1)),
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  fontFamily: Fonts.montserrat,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "out of ${(leaveBalanceInfo!.totalBalance!.isInt ? leaveBalanceInfo!.totalBalance!.toStringAsFixed(0) : leaveBalanceInfo!.totalBalance!.toStringAsFixed(1))} allowed",
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  fontFamily: Fonts.montserrat,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (leaveBalanceInfo!.totalBalance != null && leaveBalanceInfo!.totalBalance != 0) SizedBox(height: 2.0),
            if (leaveBalanceInfo!.leaveType == "REQUEST_BASED" && leaveBalanceInfo!.maxDaysPerRequest != 0)
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      lineHeight: 5.0,
                      percent: max(
                        0.0,
                        min(
                          1.0,
                          leaveBalanceInfo!.maxDaysPerRequest! / leaveBalanceInfo!.maxDaysPerRequest!,
                        ),
                      ),
                      progressColor: Theme.of(context).primaryColor,
                      backgroundColor: DefaultThemeColors.nepal,
                    ),
                  ),
                  SizedBox(width: 32.0),
                  Expanded(
                    flex: 4,
                    child: FittedBox(
                      child: Row(
                        children: [
                          Text(
                            (leaveBalanceInfo!.maxDaysPerRequest!.isInt
                                ? leaveBalanceInfo!.maxDaysPerRequest!.toStringAsFixed(0)
                                : leaveBalanceInfo!.maxDaysPerRequest!.toStringAsFixed(1)),
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  fontFamily: Fonts.montserrat,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "out of ${(leaveBalanceInfo!.maxDaysPerRequest!.isInt ? leaveBalanceInfo!.maxDaysPerRequest!.toStringAsFixed(0) : leaveBalanceInfo!.maxDaysPerRequest!.toStringAsFixed(1))} allowed",
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  fontFamily: Fonts.montserrat,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (leaveBalanceInfo!.leaveType == "REQUEST_BASED" && leaveBalanceInfo!.maxDaysPerRequest != 0) SizedBox(height: 2.0),
            if (leaveBalanceInfo!.maxNegativeBalance != null && leaveBalanceInfo!.maxNegativeBalance != 0)
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      lineHeight: 5.0,
                      percent: max(
                        0.0,
                        min(
                          1.0,
                          leaveBalanceInfo!.remainingNegativeBalance! / leaveBalanceInfo!.maxNegativeBalance!,
                        ),
                      ),
                      progressColor: DefaultThemeColors.brass,
                      backgroundColor: DefaultThemeColors.nepal,
                    ),
                  ),
                  SizedBox(width: 32.0),
                  Expanded(
                    flex: 4,
                    child: FittedBox(
                      child: Row(
                        children: [
                          Text(
                            (leaveBalanceInfo!.remainingNegativeBalance!.isInt
                                ? leaveBalanceInfo!.remainingNegativeBalance!.toStringAsFixed(0)
                                : leaveBalanceInfo!.remainingNegativeBalance!.toStringAsFixed(1)),
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  fontFamily: Fonts.montserrat,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "out of ${(leaveBalanceInfo!.maxNegativeBalance!.isInt ? leaveBalanceInfo!.maxNegativeBalance!.toStringAsFixed(0) : leaveBalanceInfo!.maxNegativeBalance!.toStringAsFixed(1))} allowed",
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  fontFamily: Fonts.montserrat,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (leaveBalanceInfo!.maxNegativeBalance != null && leaveBalanceInfo!.maxNegativeBalance != 0) SizedBox(height: 2.0),
            if (showTotal && leaveBalanceInfo!.yourTotalBalance != 0) SizedBox(height: 4.0),
            if (showTotal && leaveBalanceInfo!.yourTotalBalance != 0)
              Divider(
                height: 10,
                thickness: 1,
                indent: 0,
                color: DefaultThemeColors.whiteSmoke1,
              ),
            if (showTotal && leaveBalanceInfo!.yourTotalBalance != 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      "Total Balance",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    Text(
                      "${(leaveBalanceInfo!.yourBalance.isInt ? leaveBalanceInfo!.yourBalance.toStringAsFixed(0) : leaveBalanceInfo!.yourBalance.toStringAsFixed(1))}   /   ${(leaveBalanceInfo!.yourTotalBalance.isInt ? leaveBalanceInfo!.yourTotalBalance.toStringAsFixed(0) : leaveBalanceInfo!.yourTotalBalance.toStringAsFixed(1))}",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget percentageText(BuildContext context, LeaveBalanceResponseDTO leaveBalanceInfo, double fontSize, {required bool isSummary}) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: leaveBalanceInfo.yourBalance.isInt
              ? leaveBalanceInfo.yourBalance.toStringAsFixed(0)
              : leaveBalanceInfo.yourBalance.toStringAsFixed(1),
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontSize: fontSize,
                color: Theme.of(context).primaryColor,
                fontFamily: Fonts.montserrat,
              ),
        ),
        if (!isSummary)
          TextSpan(
            text: " / " +
                (leaveBalanceInfo.yourTotalBalance.isInt
                    ? leaveBalanceInfo.yourTotalBalance.toStringAsFixed(0)
                    : leaveBalanceInfo.yourTotalBalance.toStringAsFixed(1)),
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: Fonts.montserrat,
                  fontSize: fontSize,
                  color: DefaultThemeColors.nepal,
                ),
          ),
      ],
    ),
  );
}

Widget percentageTextSubType(BuildContext context, LeaveBalanceResponseDTO? leaveBalanceInfo, double fontSize,
    {bool showMaxCurrentBalanace = false}) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: ((leaveBalanceInfo?.currentBalance ?? 0) > (leaveBalanceInfo?.totalBalance ?? 0) && !showMaxCurrentBalanace)
              ? leaveBalanceInfo?.totalBalance?.toString().isNotEmpty == true
                  ? (leaveBalanceInfo?.totalBalance?.toString().split(".")[1] == "0"
                      ? (leaveBalanceInfo?.totalBalance?.toStringAsFixed(0).toString() ?? "")
                      : (leaveBalanceInfo?.totalBalance?.toStringAsFixed(1).toString() ?? ""))
                  : "0"
              : leaveBalanceInfo?.currentBalance?.toString().isNotEmpty == true
                  ? (leaveBalanceInfo?.currentBalance?.toString().split(".")[1] == "0"
                      ? (leaveBalanceInfo?.currentBalance?.toStringAsFixed(0).toString() ?? "")
                      : (leaveBalanceInfo?.currentBalance?.toStringAsFixed(1).toString() ?? ""))
                  : "0",
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontSize: fontSize,
                color: Theme.of(context).primaryColor,
                fontFamily: Fonts.montserrat,
              ),
        ),
        TextSpan(
          text: leaveBalanceInfo?.totalBalance?.toString().isNotEmpty == true
              ? (leaveBalanceInfo?.totalBalance?.toString().split(".")[1] == "0"
                  ? "/${leaveBalanceInfo?.totalBalance?.toStringAsFixed(0).toString()}"
                  : "/${leaveBalanceInfo?.totalBalance?.toStringAsFixed(1).toString()}")
              : leaveBalanceInfo?.maxDaysPerRequest?.toString().split(".")[1] == "0"
                  ? "/${leaveBalanceInfo?.maxDaysPerRequest?.toStringAsFixed(0).toString()}"
                  : "/${leaveBalanceInfo?.maxDaysPerRequest?.toStringAsFixed(1).toString()}",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.w500,
                fontFamily: Fonts.montserrat,
                fontSize: fontSize,
                color: Theme.of(context).primaryColor,
              ),
        ),
      ],
    ),
  );
}

Widget colorsName(BuildContext context, String name, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
    child: Row(
      children: [
        Container(
          height: 18,
          width: 18,
          decoration: BoxDecoration(shape: BoxShape.rectangle, color: color),
        ),
        SizedBox(width: 8),
        Text(
          name,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                fontFamily: Fonts.montserrat,
                color: color,
              ),
        ),
      ],
    ),
  );
}

Widget creditBalanace(BuildContext context, LeaveBalanceResponseDTO leaveBalanceInfo) {
  return Visibility(
    visible: (leaveBalanceInfo.currentBalance ?? 0) > (leaveBalanceInfo.totalBalance ?? 0),
    child: Column(
      children: [
        Text(
          ((leaveBalanceInfo.currentBalance ?? 0) - (leaveBalanceInfo.totalBalance ?? leaveBalanceInfo.maxDaysPerRequest!))
                      .toString()
                      .split(".")[1] ==
                  "0"
              ? "${((leaveBalanceInfo.currentBalance ?? 0) - (leaveBalanceInfo.totalBalance ?? leaveBalanceInfo.maxDaysPerRequest!)).toStringAsFixed(0)}"
              : "${((leaveBalanceInfo.currentBalance ?? 0) - (leaveBalanceInfo.totalBalance ?? leaveBalanceInfo.maxDaysPerRequest!)).toStringAsFixed(1)}",
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontSize: 10,
                color: DefaultThemeColors.softLimeGreen,
                fontFamily: Fonts.montserrat,
              ),
        ),
        SizedBox(height: 8),
        Container(
          height: 5,
          width: 30,
          color: DefaultThemeColors.softLimeGreen,
        )
      ],
    ),
  );
}
