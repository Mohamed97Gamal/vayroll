import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/src/provider.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/employee_provider.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/leave/brief_bottom_sheet.dart';
import 'package:vayroll/widgets/widgets.dart';

class RequestDetailsBody extends StatelessWidget {
  final RequestDetailsResponse? requestDetails;
  final MyRequestsResponseDTO? requestInfo;

  const RequestDetailsBody({Key? key, this.requestDetails, this.requestInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          if (requestInfo!.requestKind == RequestKind.leave)
            CustomFutureBuilder<BaseResponse<List<LeaveBalanceBriefDTO>>>(
              initFuture: () => ApiRepo().leaveBalancesDynamic(requestInfo?.subjectId, requestInfo?.transactionUUID),
              onSuccess: (context, snapshot) {
                var leaveBalances = snapshot.data!.result;
                if (leaveBalances == null) leaveBalances = [];
                // LeaveBalanceResponseDTO leaveBalanceInfo =
                //     leaveBalances?.firstWhere(((element) => element?.leaveRuleId == fieldInfo?.uuidValue));
                return briefLeaveBalanceCard(context, leaveBalances);
              },
            ),
          DetailsCardWidget(
            requestDetails: requestDetails,
            requestInfo: requestInfo,
            title: "Request Details",
          ),
          if (requestDetails?.attributes != null)
            DetailsCardWidget(
              requestDetails: requestDetails,
              title: "Request Data",
            ),
          if (requestDetails?.newValue != null)
            DetailsCardWidget(
              requestInfo: requestInfo,
              requestDetails: requestDetails,
              title: "New Value",
            ),
          if (requestDetails?.error?.isNotEmpty == true)
            DetailsCardWidget(
              title: requestDetails?.error,
            ),
          ListView.builder(
            itemCount: requestDetails?.request?.details?.length,
            padding: EdgeInsets.all(4),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return TreeStatesCardWidget(activeState: requestDetails?.request?.details![index]);
            },
          ),
          _footer(context),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context) {
    var _currentEmployee = context.read<EmployeeProvider>().employee;
    return Visibility(
      visible: (requestInfo?.status == RequestStatus.statusClosed &&
              (requestInfo!.requestKind == RequestKind.leave || requestInfo!.requestKind == RequestKind.expenseClaim)) &&
          !requestInfo!.isAppealed! &&
          _currentEmployee!.id == requestInfo!.subjectId,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: CustomElevatedButton(
              text: 'Raise appeal request'.toUpperCase(),
              onPressed: () => Navigation.navToAppealRequest(context, requestInfo!.id, requestInfo!.requestKind),
            ),
          ),
        ),
      ),
    );
  }

  Widget briefLeaveBalanceCard(BuildContext context, List<LeaveBalanceBriefDTO>? leaveBalanceBrief) {
    LeaveBalanceResponseDTO leaveBalanceSummary = LeaveBalanceResponseDTO();
    double _currentBlanace = 0.0;
    double _totalBalance = 0.0;

    leaveBalanceBrief?.forEach((element) {
      _currentBlanace = _currentBlanace + element.balanceAfter! ?? 0;
      _totalBalance = _totalBalance + (element.totalBalance ?? 0);
    });
    leaveBalanceSummary = LeaveBalanceResponseDTO(currentBalance: _currentBlanace, totalBalance: _totalBalance);
    return InkWell(
      onTap: () => briefLeaveBalanceBottomSheet(
        context: context,
        leaveBalanceBriefs: leaveBalanceBrief,
      ),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 35.0,
                lineWidth: 5.0,
                percent: max(0.0, calculatePercentage(leaveBalanceSummary)),
                center: percentageText(context, leaveBalanceSummary, 9,isSummary: false),
                progressColor: Theme.of(context).primaryColor,
                backgroundColor: DefaultThemeColors.nepal,
              ),
              SizedBox(width: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 44,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: leaveBalanceBrief?.length,
                        itemBuilder: (context, index) {
                          if (leaveBalanceBrief![index]?.allocatedDays == 0.0) return SizedBox();
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 3),
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2, maxHeight: 20),
                            child: Text(
                              "${(leaveBalanceBrief[index]?.allocatedDays?.toString().split(".")[1] == "0" ? (leaveBalanceBrief[index]?.allocatedDays?.toStringAsFixed(0).toString() ?? "") : (leaveBalanceBrief[index]?.allocatedDays?.toStringAsFixed(1).toString() ?? ""))} ${leaveBalanceBrief[index]?.originalLeaveRuleName}",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    fontFamily: Fonts.montserrat,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                    child: Text(
                      "Show Balance after and before",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            fontFamily: Fonts.montserrat,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
