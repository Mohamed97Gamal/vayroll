import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/common.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/widgets/widgets.dart';

class FilterRequestsPage extends StatefulWidget {
  State<StatefulWidget> createState() => FilterRequestsPageState();
}

class FilterRequestsPageState extends State<FilterRequestsPage> {
  Employee? _employee;
  DateTime? fromClosedDate;
  DateTime? toClosedDate;
  DateTime? fromSubmissionDate;
  DateTime? toSubmissionDate;

  bool? attendanceAppeal = false;
  bool? leave = false;
  bool? empProfile = false;
  bool? expenseClaim = false;
  bool? ducoment = false;

  bool? behalfOfMe = false;
  bool? byMe = false;

  List<String> typesSelected = [];

  @override
  void initState() {
    super.initState();
    _employee = context.read<EmployeeProvider>().employee;

    typesSelected.addAll(context.read<FilterRequestsProvider>().requestsTypes);
    if (typesSelected.contains(RequestKind.profileUpdate)) empProfile = true;
    if (typesSelected.contains(RequestKind.attendanceAppealRequest)) attendanceAppeal = true;
    if (typesSelected.contains(RequestKind.leave)) leave = true;
    if (typesSelected.contains(RequestKind.expenseClaim)) expenseClaim = true;
    if (typesSelected.contains(RequestKind.ducoment)) ducoment = true;

    behalfOfMe = context.read<FilterRequestsProvider>().behalfOfMe;
    byMe = context.read<FilterRequestsProvider>().byMe;

    var now = DateTime.now();

    fromClosedDate = context.read<FilterRequestsProvider>().fromClosedDate ??
        DateTime(now.year, now.month-1, now.day);
    toClosedDate = context.read<FilterRequestsProvider>().toClosedDate ??
        DateTime(now.year, now.month, now.day, 23, 59, 59);

    fromSubmissionDate = context.read<FilterRequestsProvider>().fromSubmissionDate ??
        DateTime(now.year, now.month-1, now.day);
    toSubmissionDate = context.read<FilterRequestsProvider>().toSubmissionDate ??
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke2,
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: DefaultThemeColors.whiteSmoke2,
        elevation: 0,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          _header(),
          _filters(),
          _footer(),
        ],
      ),
    );
  }

  Widget _filters() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.appStrings!.submittedBy,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: DefaultThemeColors.nepal,
                    fontSize: 16,
                  ),
            ),
            checkBox(context.appStrings!.behalfOfMe, behalfOfMe, (value) => setState(() => behalfOfMe = value)),
            checkBox(context.appStrings!.byMe, byMe, (value) => setState(() => byMe = value)),
            SizedBox(height: 6),
            Divider(height: 10, thickness: 1, color: DefaultThemeColors.whiteSmoke1),
            SizedBox(height: 6),
            Text(
              context.appStrings!.requestType,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: DefaultThemeColors.nepal,
                    fontSize: 16,
                  ),
            ),
            checkBox(
                context.appStrings!.employeeProfileUpdate, empProfile, (value) => setState(() => empProfile = value)),
            checkBox(context.appStrings!.leave, leave, (value) => setState(() => leave = value)),
            checkBox(context.appStrings!.attendanceAppeal, attendanceAppeal,
                (value) => setState(() => attendanceAppeal = value)),
            checkBox(context.appStrings!.expenseClaim, expenseClaim, (value) => setState(() => expenseClaim = value)),
            checkBox(context.appStrings!.documents, ducoment, (value) => setState(() => ducoment = value)),
            SizedBox(height: 6),
            Divider(height: 10, thickness: 1, color: DefaultThemeColors.whiteSmoke1),
            SizedBox(height: 6),
            Text(
              context.appStrings!.filterByClosedDate,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: DefaultThemeColors.nepal,
                    fontSize: 16,
                  ),
            ),
            _filterClosedDate(),
            SizedBox(height: 6),
            Divider(height: 10, thickness: 1, color: DefaultThemeColors.whiteSmoke1),
            SizedBox(height: 6),
            Text(
              context.appStrings!.filterBySubmissionDate,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: DefaultThemeColors.nepal,
                    fontSize: 16,
                  ),
            ),
            _filterSubmissionDate(),
          ],
        ),
      ),
    );
  }

  Widget checkBox(String type, bool? value, Function(bool? value) onChange) {
    return Row(
      children: [
        Text(
          type,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16),
        ),
        Spacer(),
        Checkbox(
          value: value,
          activeColor: Theme.of(context).colorScheme.secondary,
          onChanged: onChange,
        ),
      ],
    );
  }

  Widget _filterSubmissionDate() {
    return SizedBox(
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: InnerTextFormField(
              hintText: context.appStrings!.from,
              textAlignVertical: TextAlignVertical.bottom,
              controller: TextEditingController(text: dateFormat.format(fromSubmissionDate!)),
              readOnly: true,
              suffixIcon: SvgPicture.asset(
                VPayIcons.calendar,
                fit: BoxFit.none,
                alignment: Alignment.center,
              ),
              onTap: () async {
                final result = await showDatePicker(
                    context: context,
                    initialDate: fromSubmissionDate!,
                    firstDate: DateTime(_employee!.hireDate!.year, _employee!.hireDate!.month, _employee!.hireDate!.day),
                    lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light().copyWith(
                            primary: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        child: child!,
                      );
                    });
                if (result == null) return;
                setState(() {
                  fromSubmissionDate = result;
                  if (result.isAfter(toSubmissionDate!))
                    toSubmissionDate = DateTime(result.year, result.month, result.day, 23, 59, 59);
                });
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: InnerTextFormField(
              hintText: context.appStrings!.to,
              textAlignVertical: TextAlignVertical.bottom,
              controller: TextEditingController(text: dateFormat.format(toSubmissionDate!)),
              readOnly: true,
              suffixIcon: SvgPicture.asset(
                VPayIcons.calendar,
                fit: BoxFit.none,
                alignment: Alignment.center,
              ),
              onTap: () async {
                final result = await showDatePicker(
                    context: context,
                    initialDate: toSubmissionDate!,
                    firstDate: fromSubmissionDate!,
                    lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light().copyWith(
                            primary: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        child: child!,
                      );
                    });
                if (result == null) return;
                setState(() => toSubmissionDate = DateTime(result.year, result.month, result.day, 23, 59, 59));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterClosedDate() {
    return SizedBox(
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: InnerTextFormField(
              hintText: context.appStrings!.from,
              textAlignVertical: TextAlignVertical.bottom,
              controller: TextEditingController(text: dateFormat.format(fromClosedDate!)),
              readOnly: true,
              suffixIcon: SvgPicture.asset(
                VPayIcons.calendar,
                fit: BoxFit.none,
                alignment: Alignment.center,
              ),
              onTap: () async {
                final result = await showDatePicker(
                    context: context,
                    initialDate: fromClosedDate!,
                    firstDate: DateTime(_employee!.hireDate!.year, _employee!.hireDate!.month, _employee!.hireDate!.day),
                    lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light().copyWith(
                            primary: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        child: child!,
                      );
                    });
                if (result == null) return;
                setState(() {
                  fromClosedDate = result;
                  if (result.isAfter(toClosedDate!))
                    toClosedDate = DateTime(result.year, result.month, result.day, 23, 59, 59);
                });
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: InnerTextFormField(
              hintText: context.appStrings!.to,
              textAlignVertical: TextAlignVertical.bottom,
              controller: TextEditingController(text: dateFormat.format(toClosedDate!)),
              readOnly: true,
              suffixIcon: SvgPicture.asset(
                VPayIcons.calendar,
                fit: BoxFit.none,
                alignment: Alignment.center,
              ),
              onTap: () async {
                final result = await showDatePicker(
                    context: context,
                    initialDate: toClosedDate!,
                    firstDate: fromClosedDate!,
                    lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light().copyWith(
                            primary: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        child: child!,
                      );
                    });
                if (result == null) return;
                setState(() => toClosedDate = DateTime(result.year, result.month, result.day, 23, 59, 59));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: CustomElevatedButton(
          text: context.appStrings!.applyFilter.toUpperCase(),
          onPressed: () {
            if (fromClosedDate != context.read<FilterRequestsProvider>().fromClosedDate)
              context.read<FilterRequestsProvider>().fromClosedDate = fromClosedDate;
            if (toClosedDate != context.read<FilterRequestsProvider>().toClosedDate)
              context.read<FilterRequestsProvider>().toClosedDate = toClosedDate;

            if (fromSubmissionDate != context.read<FilterRequestsProvider>().fromSubmissionDate)
              context.read<FilterRequestsProvider>().fromSubmissionDate = fromSubmissionDate;
            if (toSubmissionDate != context.read<FilterRequestsProvider>().toSubmissionDate)
              context.read<FilterRequestsProvider>().toSubmissionDate = toSubmissionDate;

            if (empProfile!) {
              if (!typesSelected.contains(RequestKind.profileUpdate)) typesSelected.add(RequestKind.profileUpdate);
            } else {
              typesSelected.remove(RequestKind.profileUpdate);
            }
            if (attendanceAppeal!) {
              if (!typesSelected.contains(RequestKind.attendanceAppealRequest))
                typesSelected.add(RequestKind.attendanceAppealRequest);
            } else {
              typesSelected.remove(RequestKind.attendanceAppealRequest);
            }
            if (leave!) {
              if (!typesSelected.contains(RequestKind.leave)) typesSelected.add(RequestKind.leave);
            } else {
              typesSelected.remove(RequestKind.leave);
            }

            if (expenseClaim!) {
              if (!typesSelected.contains(RequestKind.expenseClaim)) typesSelected.add(RequestKind.expenseClaim);
            } else {
              typesSelected.remove(RequestKind.expenseClaim);
            }

            if (ducoment!) {
              if (!typesSelected.contains(RequestKind.ducoment)) typesSelected.add(RequestKind.ducoment);
            } else {
              typesSelected.remove(RequestKind.ducoment);
            }

            context.read<FilterRequestsProvider>().requestsTypes = typesSelected;
            context.read<FilterRequestsProvider>().behalfOfMe = behalfOfMe;
            context.read<FilterRequestsProvider>().byMe = byMe;
            context.read<RequestsKeyProvider>().mykey!.currentState!.refresh();
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Row(
        children: [
          TitleStacked(context.appStrings!.filters, DefaultThemeColors.prussianBlue),
          Spacer(),
          InkWell(
            onTap: () {
              setState(() {
                empProfile = false;
                leave = false;
                attendanceAppeal = false;
                expenseClaim = false;
                ducoment = false;
                behalfOfMe = false;
                byMe = false;
                typesSelected = [];

                fromClosedDate = DateTime(_employee!.hireDate!.year, _employee!.hireDate!.month, _employee!.hireDate!.day);
                toClosedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);
                fromSubmissionDate =
                    DateTime(_employee!.hireDate!.year, _employee!.hireDate!.month, _employee!.hireDate!.day);
                toSubmissionDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);

                context.read<FilterRequestsProvider>().requestsTypes = [];
                context.read<FilterRequestsProvider>().fromClosedDate = null;
                context.read<FilterRequestsProvider>().toClosedDate = null;
                context.read<FilterRequestsProvider>().fromSubmissionDate = null;
                context.read<FilterRequestsProvider>().toSubmissionDate = null;
                context.read<FilterRequestsProvider>().behalfOfMe = false;
                context.read<FilterRequestsProvider>().byMe = false;
              });
            },
            child: Text(
              context.appStrings!.reset,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
