import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/employee_provider.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class CheckInOutWidget extends StatefulWidget {
  final Color? textColor;
  final Color? timeColor;
  final Color? checkInButtonColor;
  final Color? checkOutButtonColor;
  final Color? checkInOutButtonCircleColor;
  final Color? loadingMessageColor;
  final bool showToday;
  final Function? onTap;
  final Function? onCheckIn;
  final Function? onCheckOut;

  const CheckInOutWidget({
    Key? key,
    this.textColor,
    this.timeColor,
    this.checkInButtonColor,
    this.checkOutButtonColor,
    this.checkInOutButtonCircleColor,
    this.loadingMessageColor,
    this.showToday = false,
    this.onTap,
    this.onCheckIn,
    this.onCheckOut,
  }) : super(key: key);

  @override
  _CheckInOutWidgetState createState() => _CheckInOutWidgetState();
}

class _CheckInOutWidgetState extends State<CheckInOutWidget> {
  String? _employeeId;
  Duration _workDuration = Duration.zero;
  Duration _totalWorkDuration = Duration.zero;
  bool _isCheckedIn = false;
  CheckInOut? _checkInData;
  Timer? _timer;
  final _refreshableKey = GlobalKey<RefreshableState>();
  late StateSetter _workDurationSetState;

  Future checkIn() async {
    final rootContext =
        context.findRootAncestorStateOfType<NavigatorState>()!.context;

    Position? position;
    try {
      position = await getPosition();
    } catch (ex) {
      position = null;
    }
    if (position == null) {
      var result = (await showConfirmationBottomSheet(
        context: rootContext,
        isDismissible: false,
        desc:
            "Please make sure your GPS is enabled and permission is granted to"
            " VAYROLL to fetch your location. Otherwise you can proceed with manual check in. Do you want to proceed?",
        confirmText: 'Proceed',
        cancelText: 'Cancel',
        onConfirm: () => Navigator.of(rootContext).pop(true),
      ))!;
      if (!result) return;
    }

    var sessionCheckIn = CheckInOut(
      time: DateTime.now(),
      latitude: position != null ? position.latitude : null,
      longitude: position != null ? position.longitude : null,
      isManual: position == null,
    );

    var response = (await showFutureProgressDialog<BaseResponse<String>>(
      context: rootContext,
      initFuture: () => ApiRepo().checkIn(_employeeId, sessionCheckIn),
    ))!;
    if (!response.status!) {
      await showCustomModalBottomSheet(
        context: rootContext,
        desc: response.message,
      );
      return;
    }

    if (widget.onCheckIn != null) widget.onCheckIn!();
  }

  void checkOut() async {
    final rootContext =
        context.findRootAncestorStateOfType<NavigatorState>()!.context;
    final appStrings = context.appStrings;

    DateTime checkOutTime = isSameDay(DateTime.now(), _checkInData!.time)
        ? DateTime.now()
        : DateTime(_checkInData!.time!.year, _checkInData!.time!.month,
            _checkInData!.time!.day, 23, 59, 59);

    var duration = checkOutTime.difference(_checkInData!.time!);
    if (duration.inMinutes < 1) {
      await showCustomModalBottomSheet(
          context: context,
          desc: context.appStrings!.sessionDurationShouldBeAtLeastOneMinute);
      return;
    }

    double workingHours =
        duration.inHours.toDouble() + (duration.inMinutes.remainder(60) / 60);

    var position = await getPosition();

    if (position == null) {
      var result = (await showConfirmationBottomSheet(
        context: rootContext,
        isDismissible: false,
        desc:
            "${appStrings!.pleaseMakeSureYourGPSIsEnabledAndPermissionIsGrantedTo}"
            "${appStrings.vPayToFetchYourLocationOtherwiseYouCanProceedWithManualCheckOutDoYouWantToProceed}",
        confirmText: appStrings.proceed,
        cancelText: appStrings.cancel,
        onConfirm: () => Navigator.of(rootContext).pop(true),
      ))!;
      if (!result) return;
    }

    var sessionCheckOut = CheckInOut(
      id: _checkInData!.id,
      time: checkOutTime,
      latitude: position != null ? position.latitude : null,
      longitude: position != null ? position.longitude : null,
      isManual: position == null,
      workingHours: workingHours,
    );

    var response = (await showFutureProgressDialog<BaseResponse<String>>(
      context: rootContext,
      initFuture: () => ApiRepo().checkOut(_employeeId, sessionCheckOut),
    ))!;
    if (!response.status!) {
      await showCustomModalBottomSheet(
        context: rootContext,
        desc: response.message! + ' ' + response.errors!.join(', '),
      );
      return;
    }

    _timer?.cancel();
    if (widget.onCheckOut != null) widget.onCheckOut!();
  }

  Future<Position?> getPosition() async {
    return await showFutureProgressDialog<Position?>(
      context: context,
      nullable: true,
      initFuture: () async {
        try {
          var serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            return null; // Future.error('Location services are disabled.');
          }

          var permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              return null; // Future.error('Location permissions are denied');
            }
          } else if (permission == LocationPermission.deniedForever) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.deniedForever) {
              return null; // Future.error('Location permissions are permanently denied, we cannot request permissions.');
            }
          }

          return await Geolocator.getCurrentPosition(
            timeLimit: Duration(seconds: 5),
          ).timeout(Duration(seconds: 5), onTimeout: (() => null) as FutureOr<Position> Function()?);
        } catch (ex) {
          return null;
        }
      },
    );
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 15), (t) => updateWorkDuration());
  }

  void updateWorkDuration() {
    if (!mounted) return;
    if (!_isCheckedIn) return;
    if (!isSameDay(_checkInData!.time, DateTime.now())) {
      context
          .read<AutoCheckOutProvider>()
          .autoCheckOut(context, _checkInData, _employeeId);
    }
    _workDurationSetState(() => _workDuration =
        _totalWorkDuration + DateTime.now().difference(_checkInData!.time!));
  }

  @override
  void initState() {
    super.initState();
    _employeeId = context.read<EmployeeProvider>().employee!.id;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Refreshable(
      key: _refreshableKey,
      child: CustomFutureBuilder<BaseResponse<AllDailyAttendanceResponse>>(
        loadingMessageColor: widget.loadingMessageColor,
        initFuture: () async => ApiRepo().getAttendanceSessions(
          _employeeId,
          pageIndex: 0,
          pageSize: pageSize,
        ),
        onSuccess: (context, snapshot) {
          var totalWorkingHours = snapshot.data?.result?.totalHours;
          if (totalWorkingHours != null && totalWorkingHours != 0) {
            _totalWorkDuration = Duration(
              hours: totalWorkingHours.truncate(),
              minutes: ((totalWorkingHours - totalWorkingHours.truncate()) * 60)
                  .floor(),
            );
          }

          DateTime? firstCheckIn = DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 0);
          var lastCheckout = DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 0);
          var sessions = snapshot.data?.result?.records;
          if (sessions == null || sessions.isEmpty) {
            _isCheckedIn = false;
            _checkInData = null;
            _workDuration = Duration.zero;
            _timer?.cancel();
          } else {
            var firstSession = sessions.reduce(
                (a, b) => a.checkInTime!.isBefore(b.checkInTime!) ? a : b);
            var lastSession = sessions
                .reduce((a, b) => a.checkInTime!.isAfter(b.checkInTime!) ? a : b);
            firstCheckIn = firstSession.checkInTime;
            lastCheckout = lastSession.checkOutTime ?? lastCheckout;
            if (lastSession.checkOutTime == null) {
              _isCheckedIn = true;
              _checkInData = CheckInOut(
                  id: lastSession.id,
                  time: DateTime.parse(lastSession.checkInTime
                      .toString()
                      .replaceFirst('Z', '')));
              _workDuration = _totalWorkDuration +
                  DateTime.now().difference(_checkInData!.time!);
              Future.microtask(() => startTimer());
            } else {
              _isCheckedIn = false;
              _checkInData = null;
              _workDuration = _totalWorkDuration;
              _timer?.cancel();
            }
          }

          double textWidth =
              MediaQuery.of(context).size.width - 32 - 44 - 12 - 96;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.showToday) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      context.appStrings!.today,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 15, color: DefaultThemeColors.mayaBlue),
                    ),
                    SizedBox(height: 4),
                    Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: widget.onTap as void Function()?,
                      child: Text(
                        context.appStrings!.viewAll,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 15, color: DefaultThemeColors.mayaBlue),
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ],
              Row(
                children: [
                  _isCheckedIn
                      ? CheckOutButton(
                          squareColor: widget.checkOutButtonColor,
                          circleColor: widget.checkInOutButtonCircleColor,
                          onPressed: checkOut,
                        )
                      : CheckInButton(
                          triangleColor: widget.checkInButtonColor,
                          circleColor: widget.checkInOutButtonCircleColor,
                          onPressed: checkIn,
                        ),
                  SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.appStrings!.workingHours,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          color: widget.textColor ??
                                              DefaultThemeColors.nepal),
                                ),
                                StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    _workDurationSetState = setState;
                                    return Text(
                                      '${_workDuration.inHours.toString().padLeft(2, '0')}:${_workDuration.inMinutes.remainder(60).toString().padLeft(2, '0')} hrs',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              color: widget.timeColor ??
                                                  DefaultThemeColors
                                                      .prussianBlue),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Check-In/Out',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          color: widget.textColor ??
                                              DefaultThemeColors.nepal),
                                ),
                                SizedBox(height: 3),
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 168),
                                  child: SizedBox(
                                    width: textWidth,
                                    child: FittedBox(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                    '${(firstCheckIn!.hour == 0 && firstCheckIn.minute == 0) ? '00:00 AM' : timeFormat.format(firstCheckIn)}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: widget
                                                                .timeColor ??
                                                            DefaultThemeColors
                                                                .prussianBlue)),
                                            TextSpan(
                                              text: '  |  ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: widget.textColor ??
                                                          DefaultThemeColors
                                                              .nepal),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${(lastCheckout.hour == 0 && lastCheckout.minute == 0) ? '00:00 PM' : timeFormat.format(lastCheckout)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: widget.timeColor ??
                                                          DefaultThemeColors
                                                              .prussianBlue),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
