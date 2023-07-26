import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/employee_provider.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/widgets/payslip/payslip_card.dart';
import 'package:vayroll/widgets/widgets.dart';

class PayslipHomeWidget extends StatefulWidget {
  final String? employeeId;

  const PayslipHomeWidget({Key? key, this.employeeId}) : super(key: key);

  @override
  State<PayslipHomeWidget> createState() => _PayslipHomeWidgetState();
}

class _PayslipHomeWidgetState extends State<PayslipHomeWidget> {
  List<Payslip>? payslips = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                context.appStrings!.payslips,
                style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 22),
              ),
              Spacer(),
              InkWell(
                onTap: () => Navigation.navToPayslips(context),
                child: Text(
                  context.appStrings!.viewAll,
                  style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
          Container(
            height: 150,
            width: double.maxFinite,
            child: CustomPagedListView<Payslip>(
              initPageFuture: (pageKey) async {
                var payslipsResult = await ApiRepo().getPayslips(context.read<EmployeeProvider>().employee!.id,
                    pageIndex: pageKey, pageSize: pageSize, numberOfMonths: 12);
                setState(() {
                  payslips = payslipsResult.result!.toPagedList().records;
                  if ((payslips?.isNotEmpty ?? false) && payslips != null && payslips!.length >= 6)
                    payslips = payslips!.sublist(0, 6);
                });
                return payslipsResult.result!.toPagedList();
              },
              scrollDirection: Axis.horizontal,
              noItemsFoundIndicatorBuilder: (context) => Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  context.appStrings!.thereIsNoPayslipsForYouNow,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              itemBuilder: (context, item, index) {
                return index < 6 ? PayslipCard(payslip: item) : Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
