import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class PayslipsTab extends StatefulWidget {
  const PayslipsTab({Key? key}) : super(key: key);

  @override
  _PayslipsTabState createState() => _PayslipsTabState();
}

class _PayslipsTabState extends State<PayslipsTab> {
  int? payslipsLength;
  Employee? _employee;
  DateTime? fromDate;
  DateTime? toDate;
  bool showFilter = false;

  _emailPayslip(String payrollId) {
    showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().emailPayslip(_employee!.id, payrollId),
    ).then(
      (response) async => await showCustomModalBottomSheet(
        context: context,
        desc: response?.message ?? "",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _employee = context.read<EmployeeProvider>().employee;
    fromDate = DateTime(_employee!.hireDate!.year, _employee!.hireDate!.month, _employee!.hireDate!.day);
    toDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: SizedBox(
              height: 48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (showFilter) ...[
                    Expanded(
                      flex: 3,
                      child: InnerTextFormField(
                        hintText: context.appStrings!.from,
                        textAlignVertical: TextAlignVertical.bottom,
                        controller: TextEditingController(text: monthYearFormat.format(fromDate!)),
                        readOnly: true,
                        suffixIcon: SvgPicture.asset(
                          VPayIcons.calendar,
                          fit: BoxFit.none,
                          alignment: Alignment.center,
                        ),
                        onTap: () => showMonthPicker(
                          context: context,
                          initialDate: fromDate!,
                          firstDate:
                              DateTime(_employee!.hireDate!.year, _employee!.hireDate!.month, _employee!.hireDate!.day),
                          lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        ).then(
                          (date) {
                            if (date == null) return;
                            setState(() {
                              fromDate = date;
                              if (date.isAfter(toDate!)) toDate = DateTime(date.year, date.month + 1, 0);
                            });
                            context.read<KeyProvider>().payslipsKey!.currentState!.refresh();
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: InnerTextFormField(
                        hintText: context.appStrings!.to,
                        textAlignVertical: TextAlignVertical.bottom,
                        controller: TextEditingController(text: monthYearFormat.format(toDate!)),
                        readOnly: true,
                        suffixIcon: SvgPicture.asset(
                          VPayIcons.calendar,
                          fit: BoxFit.none,
                          alignment: Alignment.center,
                        ),
                        onTap: () => showMonthPicker(
                          context: context,
                          initialDate: toDate!,
                          firstDate: fromDate,
                          lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        ).then(
                          (date) {
                            if (date == null) return;
                            setState(() => toDate = DateTime(date.year, date.month + 1, 0));
                            context.read<KeyProvider>().payslipsKey!.currentState!.refresh();
                          },
                        ),
                      ),
                    ),
                  ],
                  Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => showFilter = !showFilter),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: showFilter ? DefaultThemeColors.lightCyan : Colors.transparent,
                      ),
                      child: SvgPicture.asset(
                        VPayIcons.filter,
                        fit: BoxFit.none,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Refreshable(
              key: context.read<KeyProvider>().payslipsKey,
              child: CustomPagedListView<Payslip>(
                initPageFuture: (pageKey) async {
                  var payslipsResult = await ApiRepo().getPayslips(_employee!.id,
                      fromDate: fromDate, toDate: toDate, pageIndex: pageKey, pageSize: pageSize);
                  payslipsLength = (payslipsLength ?? 0) + (payslipsResult.result?.records?.length ?? 0);
                  return payslipsResult.result!.toPagedList();
                },
                itemBuilder: (context, item, index) {
                  return Column(
                    children: [
                      PayslipListTile(payslip: item, onEmailPayslip: _emailPayslip),
                      if (payslipsLength != index + 1) ListDivider(),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
