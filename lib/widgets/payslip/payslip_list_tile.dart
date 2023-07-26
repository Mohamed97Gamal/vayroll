import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class PayslipListTile extends StatelessWidget {
  final Payslip? payslip;
  final Function? onEmailPayslip;
  const PayslipListTile({Key? key, this.payslip, this.onEmailPayslip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        payslip!.reportName!,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subtitle: Text(
        monthYearFormat2.format(payslip!.payrollEmployeeCalculation!.payroll!.payrollCalendar!.endDate!),
        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
      ),
      onTap: () => Navigation.navToPayslipDetails(context, payslip),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _salariesWidget(context, payslip!),
          Container(
            child: PopupMenuButton(
              color: Theme.of(context).primaryColor,
              iconSize: 30,
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryColor,
              ),
              offset: Offset(-4, 40),
              padding: EdgeInsets.zero,
              shape: TooltipShape(),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                    child: Center(
                      child: Text(
                        "Email Payslip",
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                    value: "email"),
              ],
              onSelected: (dynamic value) {
                if (value == "email") onEmailPayslip!(payslip!.payrollEmployeeCalculation!.payroll!.id);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _salariesWidget(BuildContext context, Payslip p) {
    var salaries = p.salaries;
    if (salaries == null || salaries.isEmpty) return Container();
    if (salaries.length == 1)
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currencyFormat.format(salaries[0].value ?? 0) + " " + salaries[0].currency!.code!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: Fonts.brandon,
              color: _getSalaryColor(context, salaries[0].status),
            ),
          ),
          if (salaries[0].status != SalaryChange.same)
            SizedBox(
              width: 16,
              child: _arrowWidget(context, salaries[0].status, 12),
            ),
        ],
      );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: () {
        List<Widget> salaryRows = [];
        for (Salary salary in salaries) {
          salaryRows.add(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currencyFormat.format(salary.value ?? 0) + " " + salary.currency!.code!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    fontFamily: Fonts.brandon,
                    color: _getSalaryColor(context, salary.status),
                  ),
                ),
                if (salary.status != SalaryChange.same)
                  SizedBox(
                    width: 12,
                    child: _arrowWidget(context, salary.status, 8),
                  ),
              ],
            ),
          );
        }
        return salaryRows;
      }(),
    );
  }

  Color _getSalaryColor(BuildContext context, String? salaryChange) {
    switch (salaryChange) {
      case SalaryChange.same:
        return Theme.of(context).primaryColor;
      case SalaryChange.increased:
        return DefaultThemeColors.limeGreen;
      case SalaryChange.decreased:
        return DefaultThemeColors.red;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  Widget _arrowWidget(BuildContext context, String? salaryChange, double arrowHeight) {
    String icon;
    switch (salaryChange) {
      case SalaryChange.same:
        icon = VPayIcons.exclamation;
        break;
      case SalaryChange.increased:
        icon = VPayIcons.arrow_up;
        break;
      case SalaryChange.decreased:
        icon = VPayIcons.arrow_down;
        break;
      default:
        icon = VPayIcons.exclamation;
        break;
    }
    return SvgPicture.asset(icon, color: _getSalaryColor(context, salaryChange), height: arrowHeight);
  }
}
