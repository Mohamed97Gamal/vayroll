import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/utils/utils.dart';

class FromToDateWidget extends StatelessWidget {
  final String? startDate;
  final String? endDate;
  final List<String>? startYears;
  final List<String>? endYears;
  final bool isCurrent;
  final Function(String?)? onchangeStartYear;
  final Function(String?)? onchangeEndYear;

  FromToDateWidget(
      {Key? key,
      this.onchangeStartYear,
      this.onchangeEndYear,
      this.startDate,
      this.endDate,
      this.endYears,
      this.isCurrent = false,
      this.startYears})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3,
              child: InnerDropdownFormField<String>(
                label: context.appStrings!.startYear,
                hint: context.appStrings!.select,
                icon: Icon(Icons.keyboard_arrow_down),
                value: startDate,
                items: startYears != null
                    ? startYears!.map((year) => DropdownMenuItem<String>(value: year, child: Text(year))).toList()
                    : null,
                onChanged: onchangeStartYear,
              ),
            ),
          ],
        ),
        Spacer(),
        Visibility(
          visible: !isCurrent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: InnerDropdownFormField<String>(
                  label: context.appStrings!.endYear,
                  hint: context.appStrings!.select,
                  icon: Icon(Icons.keyboard_arrow_down),
                  value: endDate,
                  items: endYears != null
                      ? endYears!.map((year) => DropdownMenuItem<String>(value: year, child: Text(year))).toList()
                      : null,
                  onChanged: onchangeEndYear,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
