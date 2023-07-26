import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/leave/balance_bottom_sheet.dart';

Future<bool?> briefLeaveBalanceBottomSheet({
  required BuildContext context,
  List<LeaveBalanceBriefDTO>? leaveBalanceBriefs,
}) async {
  return await showModalBottomSheet<bool>(
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
    ),
    builder: (BuildContext context) {
      leaveBalanceBriefs?.sort((a, b) => a.drawingOrder!.compareTo(b.drawingOrder!));

      LeaveBalanceResponseDTO leaveBalanceSummary = LeaveBalanceResponseDTO();

      if (leaveBalanceSummary?.currentBalance == null) {
        double _currentBlanace = 0.0;
        double _totalBalance = 0.0;

        leaveBalanceBriefs?.forEach((element) {
          _currentBlanace = _currentBlanace + element.balanceAfter!;
          _totalBalance = _totalBalance + element.totalBalance!;
        });
        leaveBalanceSummary = LeaveBalanceResponseDTO(currentBalance: _currentBlanace, totalBalance: _totalBalance);
      }
      return WillPopScope(
        onWillPop: () async => true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${leaveBalanceBriefs!.first.leaveRuleName} Before & After",
                style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).primaryColor),
              ),
              SizedBox(height: 16),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: CircularPercentIndicator(
                    radius: 94.0,
                    lineWidth: 5.0,
                    percent: max(0.0, leaveBalanceSummary.percentage as double),
                    center: percentageText(context, leaveBalanceSummary, 15, isSummary: true),
                    progressColor: Theme.of(context).colorScheme.secondary,
                    backgroundColor: DefaultThemeColors.nepal,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Before",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                              fontFamily: Fonts.montserrat,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      for (final leaveBalanceBrief in leaveBalanceBriefs)
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
                                    leaveBalanceBrief.balanceBefore! / leaveBalanceBrief.totalBalance!,
                                  ),
                                ),
                                progressColor: darkColorBallet[leaveBalanceBriefs.indexOf(leaveBalanceBrief)],
                                backgroundColor: DefaultThemeColors.nepal,
                              ),
                            ),
                            SizedBox(width: 32.0),
                            Expanded(
                              child: FittedBox(
                                child: Row(
                                  children: [
                                    Text(
                                      (leaveBalanceBrief.balanceBefore!.isInt
                                          ? leaveBalanceBrief.balanceBefore!.toStringAsFixed(0)
                                          : leaveBalanceBrief.balanceBefore!.toStringAsFixed(1)),
                                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11,
                                            fontFamily: Fonts.montserrat,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(width: 8.0),
                                    // Text(
                                    //   "out of ${(leaveBalanceBrief.totalBalance.isInt ? leaveBalanceBrief.totalBalance.toStringAsFixed(0) : leaveBalanceBrief.totalBalance.toStringAsFixed(1))} allowed",
                                    //   style: Theme.of(context).textTheme.bodyText2.copyWith(
                                    //         fontWeight: FontWeight.w500,
                                    //         fontSize: 11,
                                    //         fontFamily: Fonts.montserrat,
                                    //       ),
                                    //   overflow: TextOverflow.ellipsis,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "After",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                              fontFamily: Fonts.montserrat,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      for (final leaveBalanceBrief in leaveBalanceBriefs)
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
                                    leaveBalanceBrief.balanceAfter! / leaveBalanceBrief.totalBalance!,
                                  ),
                                ),
                                progressColor: Theme.of(context).colorScheme.secondary,
                                backgroundColor: DefaultThemeColors.nepal,
                              ),
                            ),
                            SizedBox(width: 32.0),
                            Expanded(
                              child: FittedBox(
                                child: Row(
                                  children: [
                                    Text(
                                      (leaveBalanceBrief.balanceAfter!.isInt
                                          ? leaveBalanceBrief.balanceAfter!.toStringAsFixed(0)
                                          : leaveBalanceBrief.balanceAfter!.toStringAsFixed(1)),
                                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11,
                                            fontFamily: Fonts.montserrat,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(width: 8.0),
                                    // Text(
                                    //   "out of ${(leaveBalanceBrief.totalBalance.isInt ? leaveBalanceBrief.totalBalance.toStringAsFixed(0) : leaveBalanceBrief.totalBalance.toStringAsFixed(1))} allowed",
                                    //   style: Theme.of(context).textTheme.bodyText2.copyWith(
                                    //         fontWeight: FontWeight.w500,
                                    //         fontSize: 11,
                                    //         fontFamily: Fonts.montserrat,
                                    //       ),
                                    //   overflow: TextOverflow.ellipsis,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  for (final leaveBalanceBrief in leaveBalanceBriefs)
                    colorsName(
                      context,
                      leaveBalanceBrief.originalLeaveRuleName!,
                      darkColorBallet[leaveBalanceBriefs.indexOf(leaveBalanceBrief)],
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
