import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/views/attendance/appeal_attedance_tab.dart';
import 'package:vayroll/views/attendance/attendance_tab.dart';
import 'package:vayroll/views/attendance/team_attendance_tab.dart';
import 'package:vayroll/widgets/widgets.dart';

class AttendancePage extends StatefulWidget {
  final int tabIndex;

  const AttendancePage({Key? key, this.tabIndex = 0}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> with SingleTickerProviderStateMixin {
  final _refreshAttendanceKey = GlobalKey<RefreshableState>();
  TabController? _tabController;
  late bool showTeamAttendance;

  @override
  void initState() {
    super.initState();
    showTeamAttendance = context.read<EmployeeProvider>().employee!.hasRole(Role.CanViewTeamAttendance);
    _tabController = TabController(length: showTeamAttendance ? 3 : 2, vsync: this);
    if (widget.tabIndex != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tabController!.animateTo(widget.tabIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke2,
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: Column(
        children: [_header(), _body()],
      ),
    );
  }

  Widget _header() => Consumer<HomeCheckOutNotifyProvider>(builder: (context, checkOutProvider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TitleStacked(context.appStrings!.attendance, DefaultThemeColors.prussianBlue),
                  Column(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(VPayIcons.calendar, height: 16),
                          const SizedBox(width: 6),
                          Text(dateFormat.format(DateTime.now()), style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CheckInOutWidget(
                key: UniqueKey(),
                timeColor: Theme.of(context).primaryColor,
                checkOutButtonColor: DefaultThemeColors.red,
                onCheckIn: () {
                  // _refreshAttendanceKey.currentState.refresh();
                  context.read<AttendanceCheckInNotifyProvider>().refresh();
                  context.read<KeyProvider>().homeAttendanceNotifier.refresh();
                },
                onCheckOut: () {
                  // _refreshAttendanceKey.currentState.refresh();
                  context.read<AttendanceCheckOutNotifyProvider>().refresh();
                  context.read<KeyProvider>().homeAttendanceNotifier.refresh();
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      });

  Widget _body() {
    var _width = MediaQuery.of(context).size.width;
    return Expanded(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: showTeamAttendance ? true : false,
                tabs: [
                  Tab(text: context.appStrings!.attendance),
                  if (showTeamAttendance) Tab(text: context.appStrings!.teamAttendance),
                  Tab(text: context.appStrings!.appealRequests),
                ],
                indicatorColor: Theme.of(context).colorScheme.secondary,
                indicatorWeight: 3,
                labelColor: Theme.of(context).colorScheme.secondary,
                unselectedLabelColor: Theme.of(context).primaryColor,
                labelStyle: _width > 320
                    ? Theme.of(context).textTheme.subtitle1
                    : Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16),
              ),
              Divider(height: 1, thickness: 1, color: DefaultThemeColors.whiteSmoke1),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    AttendanceTab(refreshAttendanceKey: _refreshAttendanceKey),
                    if (showTeamAttendance) TeamAttendanceTab(),
                    AttendanceAppealTab(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
