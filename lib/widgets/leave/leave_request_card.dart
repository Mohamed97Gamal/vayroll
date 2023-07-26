import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/employee_provider.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class LeaveRequestCard extends StatelessWidget {
  final MyRequestsResponseDTO? leaveRequestInfo;
  final GlobalKey<RefreshableState>? refreshableKey;
  final int? leaveLength;
  final int? index;

  const LeaveRequestCard({
    Key? key,
    this.leaveRequestInfo,
    this.refreshableKey,
    this.leaveLength,
    this.index,
  }) : super(key: key);

  Future _leaveRequestAction(BuildContext context, String action) async {
    final leaveRequestActionResponse =
        (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () =>
          ApiRepo().requestAction(leaveRequestInfo?.requestStateId, action),
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
        isDismissible: false,
        desc: leaveRequestActionResponse.message ?? " ",
      );
      refreshableKey!.currentState!.refresh();

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Employee? employee = context.watch<EmployeeProvider>().employee;
    bool sameEmployee = leaveRequestInfo?.subjectId == employee?.id;

    return sameEmployee
        ? leaveCard(context, sameEmployee, employee)
        : CustomFutureBuilder<BaseResponse<Employee>>(
            initFuture: () =>
                ApiRepo().getEmployee(employeeId: leaveRequestInfo?.subjectId),
            onSuccess: (context, snapshot) {
              Employee? employeeInfo = snapshot.data!.result;
              if (employee == null) employeeInfo = Employee();
              return leaveCard(context, sameEmployee, employeeInfo);
            },
          );
  }

  Widget leaveCard(BuildContext context, bool sameEmployee, Employee? employee) {
    String? _startDateValue;
    String? _endDateValue;
    String? _numberOfDaysValue;
    String? _leaveTypeValue;
    leaveRequestInfo?.attributes?.forEach((element) {
      if (element.code == "START_DATE") _startDateValue = element.value;
      if (element.code == "END_DATE") _endDateValue = element.value;
      if (element.code == "NUMBER_OF_DAYS")
        _numberOfDaysValue = element.value;
      if (element.code == "LEAVE_TYPE") _leaveTypeValue = element.value;
    });

    String startDate = _startDateValue?.isNotEmpty == true
        ? dateFormat.format(DateTime.tryParse(_startDateValue!)!)
        : "";

    String endDate = _endDateValue?.isNotEmpty == true
        ? dateFormat.format(DateTime.tryParse(_endDateValue!)!)
        : "";
    String numberOfDays = _numberOfDaysValue?.isNotEmpty == true
        ? (double.tryParse(_numberOfDaysValue!)
                    ?.toStringAsFixed(1)
                    .split(".")[1] ==
                "0"
            ? double.tryParse(_numberOfDaysValue!)!.toStringAsFixed(0)
            : double.tryParse(_numberOfDaysValue!)!.toStringAsFixed(1))
        : "";

    return ((_leaveTypeValue?.isNotEmpty == true &&
                startDate.isNotEmpty == true) &&
            (endDate.isNotEmpty == true && numberOfDays.isNotEmpty == true))
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigation.navToRequestDetails(
                        context, leaveRequestInfo),
                    child: Row(
                      children: [
                        if (_leaveTypeValue?.isNotEmpty == true)
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width - 220),
                            child: AutoSizeText(
                              _leaveTypeValue!,
                              minFontSize: 9,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        Spacer(),
                        Text(leaveRequestInfo?.status ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: statusColor(
                                        leaveRequestInfo?.status, context))),
                      ],
                    ),
                  ),
                  subtitle: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigation.navToRequestDetails(
                        context, leaveRequestInfo),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "(${leaveRequestInfo?.requestNumber})",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                      height: 1,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.normal),
                            ),
                            if (startDate.isNotEmpty == true &&
                                endDate.isNotEmpty == true)
                              Text(
                                "$startDate ${context.appStrings!.to} $endDate" ??
                                    "",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        fontSize: 14,
                                        color: DefaultThemeColors.nepal),
                              ),
                          ],
                        ),
                        Spacer(),
                        if (numberOfDays.isNotEmpty == true)
                          Text(
                              numberOfDays == "1"
                                  ? ("$numberOfDays ${context.appStrings!.day}")
                                  : ("$numberOfDays ${context.appStrings!.days}"),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontSize: 16)),
                      ],
                    ),
                  ),
                  leading: Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    child: sameEmployee
                        ? CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: (employee?.photoBase64 != null
                                ? MemoryImage(
                                    base64Decode(employee!.photoBase64!))
                                : AssetImage(VPayImages.avatar)) as ImageProvider<Object>?,
                          )
                        : employee?.photo?.id != null
                            ? AvatarFutureBuilder<BaseResponse<String>>(
                                initFuture: () =>
                                    ApiRepo().getFile(employee?.photo?.id),
                                onLoading: (context) {
                                  return Container(
                                    width: 20,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(8.0),
                                    child: const SplashArt(),
                                  );
                                },
                                onError: (context, snapshot) => CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      AssetImage(VPayImages.avatar),
                                ),
                                onSuccess: (context, snapshot) {
                                  final picBase64 = snapshot.data?.result;
                                  return CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: (picBase64 != null
                                        ? MemoryImage(base64Decode(picBase64))
                                        : AssetImage(VPayImages.avatar)) as ImageProvider<Object>?,
                                  );
                                },
                              )
                            : CircleAvatar(
                                backgroundImage: AssetImage(VPayImages.avatar),
                              ),
                  ),
                  trailing: RequestActions(
                    status: leaveRequestInfo?.status,
                    onSelected: (value) {
                      if (value == "Revoke")
                        _leaveRequestAction(context, "REVOKE");
                      else if (value == "Delete")
                        showConfirmationBottomSheet(
                          context: context,
                          desc: context
                              .appStrings!.areYouSureYouWantToDeleteThisRequest,
                          isDismissible: false,
                          onConfirm: () async {
                            Navigator.of(context).pop();
                            await _leaveRequestAction(context, "DELETE");
                          },
                        );
                      else if (value == "Resubmit")
                        Navigation.navToReSubmitRequest(
                            context,
                            RequestKind.leave,
                            context.appStrings!.applyLeave,
                            leaveRequestInfo?.requestStateId);
                    },
                  ),
                ),
                if (leaveLength != index! + 1) ListDivider(),
              ],
            ),
          )
        : SizedBox();
  }
}
