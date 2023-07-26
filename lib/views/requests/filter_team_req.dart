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

class FilterTeamRequestsPage extends StatefulWidget {
  State<StatefulWidget> createState() => FilterTeamRequestsPageState();
}

class FilterTeamRequestsPageState extends State<FilterTeamRequestsPage> {
  Employee? _employee;
  DateTime? fromClosedDate;
  DateTime? toClosedDate;
  DateTime? fromSubmissionDate;
  DateTime? toSubmissionDate;

  bool? attendanceAppeal = false;
  bool? leave = false;
  bool? empProfile = false;
  bool? expenseClaim = false;
  bool? document = false;

  bool? byMe = false;

  List<String> typesSelected = [];

  @override
  void initState() {
    super.initState();
    _employee = context.read<EmployeeProvider>().employee;

    typesSelected.addAll(context.read<FilterTeamRequestsProvider>().requestsTypes);
    if (typesSelected.contains(RequestKind.profileUpdate)) empProfile = true;
    if (typesSelected.contains(RequestKind.attendanceAppealRequest)) attendanceAppeal = true;
    if (typesSelected.contains(RequestKind.leave)) leave = true;
    if (typesSelected.contains(RequestKind.expenseClaim)) expenseClaim = true;
    if (typesSelected.contains(RequestKind.ducoment)) document = true;

    byMe = context.read<FilterTeamRequestsProvider>().byMe;

    fromClosedDate = context.read<FilterTeamRequestsProvider>().fromClosedDate ??
        DateTime(_employee!.hireDate!.year, _employee!.hireDate!.month, _employee!.hireDate!.day);
    toClosedDate = context.read<FilterTeamRequestsProvider>().toClosedDate ??
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);

    fromSubmissionDate = context.read<FilterTeamRequestsProvider>().fromSubmissionDate ??
        DateTime(_employee!.hireDate!.year, _employee!.hireDate!.month, _employee!.hireDate!.day);
    toSubmissionDate = context.read<FilterTeamRequestsProvider>().toSubmissionDate ??
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
            checkBox(context.appStrings!.documents, document, (value) => setState(() => document = value)),
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
            _filterSubmittionDate(),
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

  Widget _filterSubmittionDate() {
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
            if (fromClosedDate != context.read<FilterTeamRequestsProvider>().fromClosedDate)
              context.read<FilterTeamRequestsProvider>().fromClosedDate = fromClosedDate;
            if (toClosedDate != context.read<FilterTeamRequestsProvider>().toClosedDate)
              context.read<FilterTeamRequestsProvider>().toClosedDate = toClosedDate;

            if (fromSubmissionDate != context.read<FilterTeamRequestsProvider>().fromSubmissionDate)
              context.read<FilterTeamRequestsProvider>().fromSubmissionDate = fromSubmissionDate;
            if (toSubmissionDate != context.read<FilterTeamRequestsProvider>().toSubmissionDate)
              context.read<FilterTeamRequestsProvider>().toSubmissionDate = toSubmissionDate;

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

            if (document!) {
              if (!typesSelected.contains(RequestKind.ducoment)) typesSelected.add(RequestKind.ducoment);
            } else {
              typesSelected.remove(RequestKind.ducoment);
            }

            context.read<FilterTeamRequestsProvider>().requestsTypes = typesSelected;
            context.read<FilterTeamRequestsProvider>().byMe = byMe;
            context.read<RequestsKeyProvider>().teamkey!.currentState!.refresh();
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
                document = false;
                byMe = false;
                typesSelected = [];

                fromClosedDate = DateTime(_employee!.hireDate!.year, _employee!.hireDate!.month, _employee!.hireDate!.day);
                toClosedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);
                fromSubmissionDate =
                    DateTime(_employee!.hireDate!.year, _employee!.hireDate!.month, _employee!.hireDate!.day);
                toSubmissionDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);

                context.read<FilterTeamRequestsProvider>().requestsTypes = [];
                context.read<FilterTeamRequestsProvider>().fromClosedDate = null;
                context.read<FilterTeamRequestsProvider>().toClosedDate = null;
                context.read<FilterTeamRequestsProvider>().fromSubmissionDate = null;
                context.read<FilterTeamRequestsProvider>().toSubmissionDate = null;
                context.read<FilterTeamRequestsProvider>().behalfOfMe = false;
                context.read<FilterTeamRequestsProvider>().byMe = false;
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
