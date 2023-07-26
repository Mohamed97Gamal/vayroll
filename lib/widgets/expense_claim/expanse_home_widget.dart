import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/common.dart';
import 'package:vayroll/widgets/widgets.dart';

class ExpenseClaimHomeWidget extends StatelessWidget {
  final Employee? employee;
  const ExpenseClaimHomeWidget({Key? key, this.employee}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Container(
        height: 170,
        width: double.maxFinite,
        child: CustomFutureBuilder<BaseResponse<ExpenseResponse>>(
          initFuture: () => ApiRepo().getExpensesClaims(employee?.id, dateFormat2.format(DateTime.now())),
          onSuccess: (context, snapshot) {
            ExpenseResponse? expenseClaim = snapshot.data!.result;
            if ((expenseClaim?.expenses?.isNotEmpty ?? false) &&
                expenseClaim?.expenses != null &&
                expenseClaim!.expenses!.length >= 6) expenseClaim.expenses = expenseClaim.expenses?.sublist(0, 6);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      context.appStrings!.expenseClaim,
                      style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 22),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () => Navigation.navToExpenseClaimDetails(context, employee),
                      child: Text(
                        context.appStrings!.viewAll,
                        style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                expenseClaim?.expenses?.isNotEmpty == true
                    ? Container(
                        height: 130,
                        width: double.maxFinite,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: expenseClaim!.expenses!.length,
                          separatorBuilder: (_, index) => SizedBox(width: 12),
                          itemBuilder: (expenseContext, index) {
                            return ExpenseHomeCard(expenseInfo: expenseClaim.expenses![index], emp: employee);
                          },
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          context.appStrings!.thereIsNoExpenseForYouNow,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      )
              ],
            );
          },
        ),
      ),
    );
  }
}
