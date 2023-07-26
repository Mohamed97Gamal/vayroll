import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/employee_provider.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class AttendanceTab extends StatefulWidget {
  final GlobalKey<RefreshableState>? refreshAttendanceKey;

  const AttendanceTab({Key? key, this.refreshAttendanceKey}) : super(key: key);

  @override
  _AttendanceTabState createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  Employee? _employee;
  late DateTime fromDate;
  late DateTime toDate;
  bool showFilter = false;
  bool pageLoaded = false;

  @override
  void initState() {
    super.initState();
    _employee = context.read<EmployeeProvider>().employee;
    fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1).isBefore(_employee!.hireDate!)
        ? DateTime(_employee!.hireDate!.year, _employee!.hireDate!.month, _employee!.hireDate!.day)
        : DateTime(DateTime.now().year, DateTime.now().month, 1);
    toDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer3<HomeCheckOutNotifyProvider, AttendanceCheckInNotifyProvider, AttendanceCheckOutNotifyProvider>(
        builder: (context, homeCheckOut, attendanceCheckIn, attendanceCheckOut, _) {
          if (pageLoaded)
            WidgetsBinding.instance.addPostFrameCallback((_) => widget.refreshAttendanceKey!.currentState!.refresh());
          pageLoaded = true;
          return Column(
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
                            controller: TextEditingController(text: dateFormat.format(fromDate)),
                            readOnly: true,
                            suffixIcon: SvgPicture.asset(
                              VPayIcons.calendar,
                              fit: BoxFit.none,
                              alignment: Alignment.center,
                            ),
                            onTap: () async {
                              final result = await showDatePicker(
                                  context: context,
                                  initialDate: fromDate,
                                  firstDate: DateTime(
                                      _employee!.hireDate!.year, _employee!.hireDate!.month, _employee!.hireDate!.day),
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
                                fromDate = result;
                                if (result.isAfter(toDate))
                                  toDate = DateTime(result.year, result.month, result.day, 23, 59, 59);
                              });
                              widget.refreshAttendanceKey!.currentState!.refresh();
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: InnerTextFormField(
                            hintText: context.appStrings!.to,
                            textAlignVertical: TextAlignVertical.bottom,
                            controller: TextEditingController(text: dateFormat.format(toDate)),
                            readOnly: true,
                            suffixIcon: SvgPicture.asset(
                              VPayIcons.calendar,
                              fit: BoxFit.none,
                              alignment: Alignment.center,
                            ),
                            onTap: () async {
                              final result = await showDatePicker(
                                  context: context,
                                  initialDate: toDate,
                                  firstDate: fromDate,
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
                              setState(() => toDate = DateTime(result.year, result.month, result.day, 23, 59, 59));
                              widget.refreshAttendanceKey!.currentState!.refresh();
                            },
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Refreshable(
                    key: widget.refreshAttendanceKey,
                    child: CustomFutureBuilder<BaseResponse<List<CalendarAttendance>>>(
                      initFuture: () => ApiRepo().getCalendarAttendance(_employee!.id, fromDate, toDate),
                      onSuccess: (context, snapshot) {
                        var attendance = snapshot.data!.result!;
                        return (attendance.isEmpty)
                            ? Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        VPayImages.empty,
                                        fit: BoxFit.contain,
                                        alignment: Alignment.center,
                                        height: 200,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        context.appStrings!.noDataToDisplay,
                                        style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Color(0xff444053)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.fromLTRB(16, 0, 4, 0),
                                separatorBuilder: (context, i) {
                                  return Divider(height: 40);
                                },
                                itemCount: attendance.length,
                                itemBuilder: (context, i) {
                                  return AttendanceListTile(
                                    attendance: attendance[i],
                                    onAppeal: () => Navigation.navToAttendanceAppealRequest(context, attendance[i]),
                                  );
                                },
                              );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
