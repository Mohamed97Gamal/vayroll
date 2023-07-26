import 'package:flutter/material.dart';
import 'package:vayroll/models/leave/leave_balance_response.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class LeaveHomeWidget extends StatelessWidget {
  final Employee? employeeInfo;

  const LeaveHomeWidget({Key? key, this.employeeInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<LeaveBalanceResponse>(
      initFuture: () => ApiRepo().getLeaveBalance(employeeInfo!.id),
      onSuccess: (context, snapshot) {
        var leaveBalances = snapshot.data!.result;
        if ((leaveBalances?.isNotEmpty ?? false) && leaveBalances != null && leaveBalances.length >= 6)
          leaveBalances = leaveBalances.sublist(0, 6);
        if (leaveBalances == null) leaveBalances = [];
        return Container(
          height: 191,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(context.appStrings!.leaveManagement,
                      style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 22)),
                  Spacer(),
                  InkWell(
                      onTap: () => Navigation.navToLeaveManagement(context, employeeInfo),
                      child: Text(context.appStrings!.viewAll,
                          style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14))),
                ],
              ),
              SizedBox(height: 8),
              if (leaveBalances?.isNotEmpty == true) ...[
                Container(
                  height: 120,
                  child: ListView.builder(
                    itemCount: leaveBalances?.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return leaveBalances?.isNotEmpty == true
                          ? LeaveBalanceCardWidget(leaveBalanceInfo: leaveBalances![index])
                          : Container(
                              child: Text(
                                context.appStrings!.thereIsNoLeaveBalanceForYouNow,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            );
                    },
                  ),
                ),
              ] else
                Center(
                  child: Container(
                    child: Text(
                      context.appStrings!.thereIsNoLeaveBalanceForYouNow,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
