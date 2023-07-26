import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';

class PayslipCard extends StatelessWidget {
  final Payslip payslip;

  const PayslipCard({required this.payslip});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: EdgeInsets.only(bottom: 6, right: 5.0, left: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withAlpha(12),
              offset: Offset(0.0, 3.0), //(x,y)
              blurRadius: 3.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Positioned(
                top: -20,
                right: -18,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getCircleColor(context, payslip.generalStatus),
                  ),
                ),
              ),
              if (payslip.generalStatus != SalaryChange.same) _arrowWidget(context, payslip.generalStatus),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payslip.reportName!,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14),
                    ),
                    Text(
                      payslip.payrollEmployeeCalculation!.payroll!.customPayrollType ?? "Salary",
                      style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),
                    ),
                    Text(
                      monthYearFormat2.format(payslip.payrollEmployeeCalculation!.payroll!.payrollCalendar!.endDate!),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        fontFamily: Fonts.brandon,
                        color: DefaultThemeColors.nepal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCircleColor(BuildContext context, String? salaryChange) {
    switch (salaryChange) {
      case SalaryChange.same:
        return DefaultThemeColors.mayaBlue.withAlpha(90);
      case SalaryChange.increased:
        return DefaultThemeColors.limeGreen.withAlpha(33);
      case SalaryChange.decreased:
        return DefaultThemeColors.red.withAlpha(33);
      default:
        return DefaultThemeColors.mayaBlue.withAlpha(90);
    }
  }

  Widget _arrowWidget(BuildContext context, String? salaryChange) {
    Color color;
    String icon;
    double rightOffset;
    switch (salaryChange) {
      case SalaryChange.increased:
        color = DefaultThemeColors.limeGreen;
        icon = VPayIcons.arrow_up;
        rightOffset = 18;
        break;
      case SalaryChange.decreased:
        color = DefaultThemeColors.red;
        icon = VPayIcons.arrow_down;
        rightOffset = 18;
        break;
      default:
        color = Theme.of(context).primaryColor;
        icon = VPayIcons.exclamation;
        rightOffset = 22;
        break;
    }

    return Positioned(
      top: 15,
      right: rightOffset,
      child: SvgPicture.asset(icon, color: color, fit: BoxFit.none),
    );
  }
}
