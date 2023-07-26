import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/common.dart';
import 'package:vayroll/widgets/widgets.dart';

class TeamAttendanceTab extends StatefulWidget {
  const TeamAttendanceTab({Key? key}) : super(key: key);

  @override
  _TeamAttendanceTabState createState() => _TeamAttendanceTabState();
}

class _TeamAttendanceTabState extends State<TeamAttendanceTab> {
  String? _employeeId;
  DateTime? date;
  bool showFilter = false;
  var refreshTeamAttKey = GlobalKey<RefreshableState>();
  DateTime? oldestDate;

  int? teamAttendanceLength;

  @override
  void initState() {
    super.initState();
    _employeeId = context.read<EmployeeProvider>().employee!.id;
    oldestDate = context.read<EmployeeProvider>().employee!.employeesGroup!.establishmentDate;
    date = DateTime.now();
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (showFilter) ...[
                    Expanded(
                      child: InnerTextFormField(
                        hintText: context.appStrings!.date,
                        textAlignVertical: TextAlignVertical.bottom,
                        controller: TextEditingController(text: dateFormat.format(date!)),
                        readOnly: true,
                        suffixIcon: SvgPicture.asset(
                          VPayIcons.calendar,
                          fit: BoxFit.none,
                          alignment: Alignment.center,
                        ),
                        onTap: () async {
                          final result = await showDatePicker(
                              context: context,
                              initialDate: date!,
                              firstDate: oldestDate!,
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
                          setState(() => date = result);
                          refreshTeamAttKey.currentState!.refresh();
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        setState(() {
                          date = DateTime.now();
                        });
                        refreshTeamAttKey.currentState!.refresh();
                      },
                      child: Text(context.appStrings!.reset,
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14)),
                    ),
                  ],
                  if (!showFilter)
                    Text(
                      isSameDay(date, DateTime.now()) ? context.appStrings!.today : dateFormat.format(date!),
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
                    ),
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
              padding: const EdgeInsets.only(bottom: 16, left: 12),
              child: Refreshable(
                key: refreshTeamAttKey,
                child: RefreshIndicator(
                  onRefresh: () async => refreshTeamAttKey.currentState!.refresh(),
                  child: CustomPagedListView<EmployeeAttendance>(
                    initPageFuture: (pageKey) async {
                      var attendanceResult = await ApiRepo().getTeamAttendance(
                        _employeeId,
                        date!,
                        pageIndex: pageKey,
                        pageSize: pageSize,
                      );
                      teamAttendanceLength =
                          (teamAttendanceLength ?? 0) + (attendanceResult?.result?.records?.length ?? 0);
                      return attendanceResult.result!.toPagedList();
                    },
                    itemBuilder: (context, item, index) {
                      return Column(
                        children: [
                          TeamMemberAttendanceListTile(employeeAttendance: item),
                          if (teamAttendanceLength != index + 1)
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: ListDivider(),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
