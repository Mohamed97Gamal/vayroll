import 'package:flutter/material.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class AttendanceListTile extends StatelessWidget {
  final CalendarAttendance attendance;
  final Function? onAppeal;

  const AttendanceListTile({Key? key, required this.attendance, this.onAppeal}) : super(key: key);

  String _workingHours(double? workHours) {
    if (workHours == null || workHours == 0)
      return '00:00 hrs';
    else {
      var hours = workHours.truncate();
      var minutes = ((workHours - hours) * 60).floor();
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} hrs';
    }
  }

  String _workingHoursDescription(double? difference) {
    if (difference == 0)
      return 'Full Day';
    else if (difference! > 0)
      return '(Overtime) Full Day';
    else if (difference < 0)
      return 'Incomplete Day';
    else
      return '';
  }

  Color _workingHoursColor(BuildContext context, double? difference) {
    if (difference == 0)
      return DefaultThemeColors.prussianBlue;
    else if (difference! > 0)
      return DefaultThemeColors.mantis;
    else
      return Theme.of(context).colorScheme.secondary;
  }

  String _dateName(DateTime? date, BuildContext context) {
    if (isSameDay(date, DateTime.now()))
      return context.appStrings!.today;
    else if (isSameDay(date, DateTime.now().subtract(Duration(days: 1))))
      return context.appStrings!.yesterday;
    else
      return dateFormat.format(date!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    _dateName(attendance.date, context),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        fontFamily: Fonts.brandon,
                        color: DefaultThemeColors.nepal),
                  ),
                  Spacer(),
                  Text(
                    _workingHoursDescription(attendance.differenceWorkingHours),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        fontFamily: Fonts.brandon,
                        color: DefaultThemeColors.nepal),
                  )
                ],
              ),
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: attendance.checkInTime != null ? timeFormat.format(attendance.checkInTime!) : '00:00 AM',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontWeight: FontWeight.w500, color: DefaultThemeColors.prussianBlue),
                        ),
                        TextSpan(
                          text: '   |   ',
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor.withAlpha(120)),
                        ),
                        TextSpan(
                          text:
                              attendance.checkOutTime != null ? timeFormat.format(attendance.checkOutTime!) : '00:00 PM',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontWeight: FontWeight.w500, color: DefaultThemeColors.prussianBlue),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    _workingHours(attendance.totalWorkingHours),
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: _workingHoursColor(context, attendance.differenceWorkingHours),
                        ),
                  ),
                ],
              )
            ],
          ),
        ),
        (attendance.isAppealed! || isSameDay(attendance.date, DateTime.now()))
            ? const SizedBox(width: 48)
            : Container(
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
                            "Raise an appeal",
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ),
                        value: "Appeal"),
                  ],
                  onSelected: (dynamic value) {
                    if (value == "Appeal" && onAppeal != null) onAppeal!();
                  },
                ),
            ),
      ],
      // dense: true,
      // contentPadding: EdgeInsets.fromLTRB(16, 12, 4, 12),
      // title: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Row(
      //       children: [
      //         Text(
      //           _dateName(attendance.date),
      //           style: TextStyle(
      //               fontSize: 14,
      //               fontWeight: FontWeight.normal,
      //               fontFamily: Fonts.brandon,
      //               color: DefaultThemeColors.nepal),
      //         ),
      //         Spacer(),
      //         Text(
      //           _workingHoursDescription(attendance.differenceWorkingHours),
      //           style: TextStyle(
      //               fontSize: 14,
      //               fontWeight: FontWeight.normal,
      //               fontFamily: Fonts.brandon,
      //               color: DefaultThemeColors.nepal),
      //         )
      //       ],
      //     ),
      //     Row(
      //       children: [
      //         RichText(
      //           text: TextSpan(
      //             children: <InlineSpan>[
      //               TextSpan(
      //                 text: attendance.checkInTime != null ? timeFormat.format(attendance.checkInTime) : '00:00 AM',
      //                 style: Theme.of(context)
      //                     .textTheme
      //                     .bodyText2
      //                     .copyWith(fontWeight: FontWeight.w500, color: DefaultThemeColors.prussianBlue),
      //               ),
      //               TextSpan(
      //                 text: '   |   ',
      //                 style: Theme.of(context)
      //                     .textTheme
      //                     .bodyText2
      //                     .copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor.withAlpha(120)),
      //               ),
      //               TextSpan(
      //                 text: attendance.checkOutTime != null ? timeFormat.format(attendance.checkOutTime) : '00:00 PM',
      //                 style: Theme.of(context)
      //                     .textTheme
      //                     .bodyText2
      //                     .copyWith(fontWeight: FontWeight.w500, color: DefaultThemeColors.prussianBlue),
      //               ),
      //             ],
      //           ),
      //         ),
      //         Spacer(),
      //         Text(
      //           _workingHours(attendance.totalWorkingHours),
      //           style: Theme.of(context).textTheme.bodyText2.copyWith(
      //                 fontWeight: FontWeight.w500,
      //                 color: _workingHoursColor(context, attendance.differenceWorkingHours),
      //               ),
      //         ),
      //       ],
      //     )
      //   ],
      // ),
      // trailing: attendance.isAppealed
      //     ? const SizedBox(width: 48)
      //     : PopupMenuButton(
      //         color: Theme.of(context).primaryColor,
      //         iconSize: 30,
      //         icon: Icon(
      //           Icons.more_vert,
      //           color: Theme.of(context).primaryColor,
      //         ),
      //         offset: Offset(-4, 40),
      //         padding: EdgeInsets.zero,
      //         shape: TooltipShape(),
      //         itemBuilder: (BuildContext context) => [
      //           PopupMenuItem(
      //               child: Center(
      //                 child: Text(
      //                   "Raise an appeal",
      //                   style: Theme.of(context)
      //                       .textTheme
      //                       .caption
      //                       .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
      //                 ),
      //               ),
      //               value: "Appeal"),
      //         ],
      //         onSelected: (value) {
      //           if (value == "Appeal" && onAppeal != null) onAppeal();
      //         },
      //       ),
    );
  }
}
