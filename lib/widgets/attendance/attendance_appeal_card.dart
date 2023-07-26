import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class AttendanceAppealCard extends StatelessWidget {
  final MyRequestsResponseDTO? attendanceInfo;
  final GlobalKey<RefreshableState>? refreshableKey;
  final Function? onTap;

  const AttendanceAppealCard(
      {Key? key, this.attendanceInfo, this.refreshableKey, this.onTap})
      : super(key: key);

  String _dateName(DateTime? date, BuildContext context) {
    if (isSameDay(date, DateTime.now()))
      return context.appStrings!.today;
    else if (isSameDay(date, DateTime.now().subtract(Duration(days: 1))))
      return context.appStrings!.yesterday;
    else
      return dateFormat.format(date!);
  }

  Future _attendanceRequestAction(BuildContext context, String action) async {
    var confirm = (await showConfirmationBottomSheet(
      context: context,
      isDismissible: false,
      desc: context.appStrings!.doAction(action),
      onConfirm: () => Navigator.of(context).pop(true),
    ))!;
    if (!confirm) return;

    final leaveRequestActionResponse =
        (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo()
          .requestAction(attendanceInfo?.requestStateId, action.toUpperCase()),
    ))!;

    if (leaveRequestActionResponse.status!) {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc: leaveRequestActionResponse.message ?? " ",
      );
      refreshableKey!.currentState!.refresh();
    } else {
      await showCustomModalBottomSheet(
        context: context,
        desc: leaveRequestActionResponse.message ?? " ",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? _requestNumber = attendanceInfo!.requestNumber;
    String? _appealDateValue = attendanceInfo?.attributes
        ?.firstWhereOrNull((attribute) => attribute.code == 'APPEAL_DATE')
        ?.value;
    String? _checkInTimeValue = attendanceInfo?.attributes
        ?.firstWhereOrNull((attribute) => attribute.code == 'CHECKIN_TIME')
        ?.value;
    String? _checkOutTimeValue = attendanceInfo?.attributes
        ?.firstWhereOrNull((attribute) => attribute.code == 'CHECKOUT_TIME')
        ?.value;

    return ListTile(
      onTap: onTap as void Function()?,
      contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 16),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _appealDateValue != null
                    ? _dateName(DateTime.tryParse(_appealDateValue), context)
                    : "",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    fontFamily: Fonts.brandon,
                    color: DefaultThemeColors.nepal),
              ),
              Text(
                _requestNumber != null ? '   (' + _requestNumber + ')' : "",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    fontFamily: Fonts.brandon,
                    color: DefaultThemeColors.nepal),
              ),
              Spacer(),
              Text(attendanceInfo?.status ?? "",
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: statusColor(attendanceInfo?.status, context))),
            ],
          ),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: _checkInTimeValue != null
                          ? timeFormat
                              .format(DateTime.tryParse(_checkInTimeValue)!)
                          : '00:00 AM',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: DefaultThemeColors.prussianBlue),
                    ),
                    TextSpan(
                      text: '   |   ',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor.withAlpha(120)),
                    ),
                    TextSpan(
                      text: _checkOutTimeValue != null
                          ? timeFormat
                              .format(DateTime.tryParse(_checkOutTimeValue)!)
                          : '00:00 PM',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: DefaultThemeColors.prussianBlue),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      trailing: RequestActions(
        status: attendanceInfo?.status,
        onSelected: (value) {
          if (value == "Revoke")
            _attendanceRequestAction(context, value.toString());
          else if (value == "Delete")
            _attendanceRequestAction(context, value.toString());
          else if (value == "Resubmit") _onResubmit(context);
        },
      ),
    );
  }

  void _onResubmit(BuildContext context) {
    Navigation.navToResubmitAttendanceAppealRequest(
        context, attendanceInfo, refreshableKey);
  }
}
