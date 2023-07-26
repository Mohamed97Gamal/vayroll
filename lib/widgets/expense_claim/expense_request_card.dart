import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class ExpenseRequestCard extends StatelessWidget {
  final MyRequestsResponseDTO? expenseRequestInfo;
  final GlobalKey<RefreshableState>? refreshableKey;

  const ExpenseRequestCard({
    Key? key,
    this.expenseRequestInfo,
    this.refreshableKey,
  }) : super(key: key);

  Future _expenseRequestAction(BuildContext context, String action) async {
    final expenseRequestActionResponse = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().requestAction(expenseRequestInfo?.requestStateId, action),
    ))!;

    if (expenseRequestActionResponse.status!) {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc: expenseRequestActionResponse.message ?? " ",
      );
      refreshableKey!.currentState!.refresh();
    } else {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc: expenseRequestActionResponse.message ?? " ",
      );
      refreshableKey!.currentState!.refresh();

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return expenseCard(context, expenseRequestInfo);
  }

  Widget expenseCard(BuildContext context, MyRequestsResponseDTO? expenseRequestInfo) {
    String _dateValue = dateFormat.format(expenseRequestInfo!.submissionDate!);
    String? _expenseName;
    String? currency;
    String? _amount;

    expenseRequestInfo.attributes?.forEach((element) {
      //if (element?.code == "EXPENSE_DATE") _dateValue = element?.value;
      if (element.code == "EXPENSE_TYPE") _expenseName = element.value;
      if (element.code == "CURRENCY_CODE")
        currency = (element.value?.toString().length ?? 0) > 8
            ? "${element.value?.toString().substring(0, 8)}..."
            : element.value;
      if (element.code == "AMOUNT") _amount = element.value;
    });

    String dateValue = _dateValue.isNotEmpty == true ? dateFormat.format(expenseRequestInfo!.submissionDate!) : "";
    double amount = double.tryParse(_amount!) ?? 0;

    return ((dateValue.isNotEmpty == true && _expenseName?.isNotEmpty == true) &&
            (currency?.isNotEmpty == true && _amount?.toString().isNotEmpty == true))
        ? ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            onTap: () => Navigation.navToRequestDetails(context, expenseRequestInfo),
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_expenseName!, style: Theme.of(context).textTheme.subtitle1!.copyWith(height: 1)),
                      SizedBox(height: 4),
                      Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 250),
                        child: Text(
                          "(${expenseRequestInfo.requestNumber})",
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                height: 1,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                    amount.toString().split(".")[1] == "0"
                        ? ("$currency ${amount.toStringAsFixed(0) ?? ""}")
                        : ("$currency ${amount.toStringAsFixed(2) ?? ""}"),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16)),
              ],
            ),
            subtitle: Row(
              children: [
                Text(
                  dateValue ?? "",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 14, color: DefaultThemeColors.nepal),
                ),
                Spacer(),
                Text(expenseRequestInfo.status ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: statusColor(expenseRequestInfo.status, context))),
              ],
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: SvgPicture.asset(VPayIcons.fatwra),
            ),
            trailing: RequestActions(
              status: expenseRequestInfo.status,
              onSelected: (value) {
                if (value == "Revoke")
                  _expenseRequestAction(context, "REVOKE");
                else if (value == "Delete")
                  showConfirmationBottomSheet(
                    context: context,
                    desc: context.appStrings!.areYouSureYouWantToDeleteThisRequest,
                    isDismissible: false,
                    onConfirm: () async {
                      Navigator.of(context).pop();
                      await _expenseRequestAction(context, "DELETE");
                    },
                  );
                else if (value == "Resubmit")
                  Navigation.navToReSubmitRequest(
                      context, RequestKind.expenseClaim, "Claim Expenses", expenseRequestInfo.requestStateId);
              },
            ),
          )
        : SizedBox();
  }
}
