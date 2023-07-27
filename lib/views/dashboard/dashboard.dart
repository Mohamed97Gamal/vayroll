import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/new_refreshable.dart';
import 'package:vayroll/widgets/widgets.dart';

import '../../widgets/calendar/full_home_calendar_widget.dart';

class DashboardPage extends StatefulWidget {
  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  StateSetter? _balloonsSetState;
  var _scrollController = ScrollController();
  late ConfettiController _confettiLeftController, _confettiRightController;
  late bool _confettiPlayed;
  double yOffset = 0;
  GlobalKey<RefreshableState> _refreshHomeKey = GlobalKey<RefreshableState>();
  GlobalKey<RefreshableState> _decidableKey = GlobalKey<RefreshableState>();

  @override
  void initState() {
    super.initState();
    _confettiPlayed = false;
    _scrollController.addListener(() {
      if (_balloonsSetState != null)
        _balloonsSetState!(() => yOffset = (_scrollController.offset / _scrollController.position.maxScrollExtent) * 2);
    });
    _confettiLeftController = ConfettiController(duration: const Duration(seconds: 8));
    _confettiRightController = ConfettiController(duration: const Duration(seconds: 8));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _confettiLeftController.dispose();
    _confettiRightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: CurvedShapeDashboard(
                heightRatio: MediaQuery.of(context).orientation == Orientation.portrait ? 0.55 : 1),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: Refreshable(
            key: context.read<KeyProvider>().decidableHomeFABKey,
            child: CustomFutureBuilder<BaseResponse<AllRequestsResponse>>(
              initFuture: () => ApiRepo().getDecidableRequests(
                approver: true,
                requestStatus: [RequestStatus.statusSubmitted],
                pageIndex: 0,
                pageSize: pageSize,
              ),
              onLoading: (context) {
                return FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () => context.read<KeyProvider>().decidableHomeFABKey!.currentState!.refresh(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              onError: (context, snapshot) {
                return FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () => context.read<KeyProvider>().decidableHomeFABKey!.currentState!.refresh(),
                  child: SvgPicture.asset(
                    VPayIcons.exclamation,
                    fit: BoxFit.none,
                    alignment: Alignment.center,
                  ),
                );
              },
              onSuccess: (context, snapshot) {
                List<MyRequestsResponseDTO>? myRequests = snapshot.data?.result?.records;
                if (myRequests == null) myRequests = [];
                return myRequests.isEmpty == true
                    ? Container()
                    : FloatingActionButton(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        onPressed: () => Navigation.navToDecidableRequests(context),
                        child: SvgPicture.asset(
                          VPayIcons.decidableRequestIcon,
                          fit: BoxFit.none,
                          alignment: Alignment.center,
                        ),
                      );
              },
            ),
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: SvgPicture.asset(
                VPayIcons.widgets,
                fit: BoxFit.none,
              ),
              onPressed: () => Navigation.navToDashboardWidgets(context),
            ),
            actions: [
              if (context.read<EmployeeProvider>().employee!.hasRole(Role.CanViewAppealRequests))
                NewRefreshable(
                    refreshNotifier: context.read<KeyProvider>().homeAppealManagerNotifier,
                    child: AppealManagerHomeIcon(employeeId: context.watch<EmployeeProvider>().employee?.id)),
              NewRefreshable(
                  refreshNotifier: context.read<KeyProvider>().homeAnnouncementsNotifier,
                  child: AnnouncementHomeIcon(employeeId: context.watch<EmployeeProvider>().employee?.id)),
              NewRefreshable(
                  refreshNotifier: context.read<KeyProvider>().homeNotificationsNotifier,
                  child: NotificationHomeIcon(employeeId: context.watch<EmployeeProvider>().employee?.id)),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  _userWidget(context.watch<EmployeeProvider>().employee),
                  SizedBox(
                    height: 100.0,
                    child: _checkInOutWidget(),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Refreshable(
                      key: _refreshHomeKey,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<KeyProvider>().decidableHomeFABKey!.currentState!.refresh();
                          _refreshHomeKey.currentState!.refresh();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Column(
                                children: _buildWidgets(context.watch<DashboardWidgetsProvider>().widgets),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              if (context.watch<EmployeeProvider>().employee!.birthDate != null &&
                  isSameDayWithoutYear(DateTime.now(), context.watch<EmployeeProvider>().employee!.birthDate)) ...[
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    _balloonsSetState = setState;
                    if (!_confettiPlayed)
                      Future.microtask(() => Future.delayed(Duration(seconds: 4), () {
                            if (mounted) {
                              setState(() {
                                _confettiLeftController.play();
                                _confettiRightController.play();
                                _confettiPlayed = true;
                              });
                            }
                          }));
                    return IgnorePointer(
                      child: SvgPicture.asset(
                        VPayImages.balloons,
                        alignment: Alignment(0, -1 + yOffset),
                        fit: BoxFit.fitWidth,
                        width: screenSize.width,
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: ConfettiWidget(
                    confettiController: _confettiLeftController,
                    blastDirection: -pi / 2.25,
                    maxBlastForce: 100,
                    minBlastForce: 50,
                    particleDrag: 0.03,
                    numberOfParticles: 20,
                    minimumSize: Size(10, 5),
                    maximumSize: Size(20, 10),
                    // gravity: 0.1,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ConfettiWidget(
                    confettiController: _confettiRightController,
                    blastDirection: -(pi - pi / 2.25),
                    maxBlastForce: 120,
                    minBlastForce: 30,
                    emissionFrequency: 0.01,
                    particleDrag: 0.02,
                    numberOfParticles: 20,
                    minimumSize: Size(10, 5),
                    maximumSize: Size(20, 10),
                    // gravity: 0.1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildWidgets(List<DashboardWidget> dashboardWidgets) {
    var _widgets = <Widget>[];
    for (DashboardWidget d in dashboardWidgets) {
      if (!d.active!) continue;
      switch (d.name!) {
        case WidgetName.calendar:
          _widgets.add(
            NewRefreshable(
              refreshNotifier: context.read<KeyProvider>().homeCalendarNotifier,
              child: FullHomeCalanderWidget(employeeInfo: context.watch<EmployeeProvider>().employee!)
            ),
          );
          break;
        case WidgetName.weeklyAttendance:
         // if (context.watch<StartEndDateProvider>().startDate?.toString().isNotEmpty == true) {
         //   _widgets.add(_weeklyAttendance(context.watch<EmployeeProvider>().employee?.id));
         // }
          break;
        case WidgetName.birthdays:
         // if (context.watch<StartEndDateProvider>().startDate?.toString().isNotEmpty == true) {
         //   _widgets.add(BirthdayHomeWidget(employee: context.watch<EmployeeProvider>().employee));
         // }
          break;
        case WidgetName.leaves:
          _widgets.add(NewRefreshable(
              refreshNotifier: context.read<KeyProvider>().homeLeaveNotifier,
              child: LeaveHomeWidget(employeeInfo: context.watch<EmployeeProvider>().employee)));
          break;
        case WidgetName.annualAttendance:
          _widgets.add(_annualAttendanceWidget());
          break;
        case WidgetName.department:
          _widgets.add(DepartmentHomeWidget(employeeId: context.watch<EmployeeProvider>().employee!.id));
          break;
        case WidgetName.payslips:
          _widgets.add(_payslipsWidget(context.watch<EmployeeProvider>().employee!.id));
          break;
        case WidgetName.expenseClaims:
          _widgets.add(ExpenseClaimHomeWidget(employee: context.watch<EmployeeProvider>().employee));
          break;
      }
    }
    for (int i = 0; i < _widgets.length; i++) {
      _widgets[i] = Container(
        width: double.maxFinite,
        child: _widgets[i],
        color: i % 2 == 0 ? Colors.white : DefaultThemeColors.whiteSmoke3,
      );
    }

    return _widgets;
  }

  Widget _userWidget(Employee? employeeInfo) {
    return UserHomeWidget(
      name: employeeInfo?.fullName,
      company: employeeInfo?.employeesGroup?.name,
      imageBase64: employeeInfo?.photoBase64,
      onTap: () => context.read<HomeTabIndexProvider>().index = 0,
    );
  }

  Widget _checkInOutWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: NewRefreshable(
        refreshNotifier: context.read<KeyProvider>().homeAttendanceNotifier,
        child: CheckInOutWidget(
          textColor: Colors.white,
          timeColor: Theme.of(context).colorScheme.secondary,
          checkInButtonColor: Colors.white,
          checkInOutButtonCircleColor: Colors.white,
          loadingMessageColor: Colors.white,
          showToday: true,
          onCheckIn: () {
            context.read<KeyProvider>().homeAttendanceNotifier.refresh();
             context.read<HomeCheckInNotifyProvider>().refresh();
          },
          onCheckOut: () {
            context.read<KeyProvider>().homeAttendanceNotifier.refresh();
             context.read<HomeCheckOutNotifyProvider>().refresh();
          },
          onTap: () => Navigation.navToAttendance(context),
        ),
      ),
    );
  }

  Widget _annualAttendanceWidget() {
    return Consumer2<HomeCheckInNotifyProvider, AttendanceCheckInNotifyProvider>(
      builder: (context, homeCheckInProvider, attendanceCheckInProvider, _) {
        return AnnualAttendanceWidget(
          key: UniqueKey(),
          employeeId: context.watch<EmployeeProvider>().employee!.id,
        );
      },
    );
  }

  Widget _payslipsWidget(String? employeeId) {
    return PayslipHomeWidget(employeeId: employeeId);
  }

  Widget _weeklyAttendance(String? employeeId) {
    return Consumer3<HomeCheckOutNotifyProvider, AttendanceCheckOutNotifyProvider, StartEndDateProvider>(
      builder: (context, homeCheckOutProvider, attendanceCheckOutProvider, startEndDateProvider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: AttendanceHomeWidget(
              key: UniqueKey(),
              employeeId: employeeId,
              startDate: startEndDateProvider.startDate,
              endDate: startEndDateProvider.endDate,
              onTap: () => Navigation.navToAttendance(context),
            ),
          ),
        );
      },
    );
  }
}
