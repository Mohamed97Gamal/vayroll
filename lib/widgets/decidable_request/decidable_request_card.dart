import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/models/my_requests_response.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class DecidableRequestCard extends StatelessWidget {
  final MyRequestsResponseDTO? myRequestsResponseDTO;
  final GlobalKey<RefreshableState>? refreshableKey;
  final int? index;
  final int? totalLength;

  const DecidableRequestCard(
      {Key? key,
      this.myRequestsResponseDTO,
      this.refreshableKey,
      this.index,
      this.totalLength})
      : super(key: key);

  Future _attendanceRequestAction(BuildContext context, String action) async {
    var confirm = (await showConfirmationBottomSheet(
      context: context,
      isDismissible: false,
      desc: context.appStrings!.doAction(action),
      onConfirm: () => Navigator.of(context).pop(true),
    ))!;
    if (!confirm) return;

    final decidableRequestActionResponse =
        (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().makeActionOnDecidableRequest(
          requestStepId: myRequestsResponseDTO?.requestStepId ?? "",
          action: action.toUpperCase()),
    ))!;

    if (decidableRequestActionResponse.status!) {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc: decidableRequestActionResponse?.message ?? " ",
      );
      refreshableKey!.currentState!.refresh();
    } else {
      await showCustomModalBottomSheet(
        context: context,
        desc: decidableRequestActionResponse?.message ?? " ",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(myRequestsResponseDTO?.requestNumber ?? "",
                        style: Theme.of(context).textTheme.subtitle1),
                    Text(
                      "${myRequestsResponseDTO!.subjectName}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: DefaultThemeColors.nepal),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => _attendanceRequestAction(context, "APPROVE"),
                  child: SvgPicture.asset(
                    VPayIcons.accept,
                    fit: BoxFit.none,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => _attendanceRequestAction(context, "REJECT"),
                  child: SvgPicture.asset(
                    VPayIcons.reject,
                    fit: BoxFit.none,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: RequestActions(
                  status: context.appStrings!.details,
                  onSelected: (value) {
                    if (value == "Details")
                      Navigation.navToRequestDetails(
                          context, myRequestsResponseDTO);
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${myRequestsResponseDTO!.submissionDate!.day.toString()}-${myRequestsResponseDTO!.submissionDate!.month.toString()}-${myRequestsResponseDTO!.submissionDate!.year.toString()}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: DefaultThemeColors.nepal),
                ),
                Text(
                  context.appStrings!.submitted,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.green),
                ),
              ],
            ),
          ),
          if (totalLength != index! + 1)
            Divider(
                height: 1, thickness: 1, color: DefaultThemeColors.whiteSmoke1),
        ],
      ),
    );
  }
}
