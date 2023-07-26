import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';

import '../widgets.dart';

class RequestCard extends StatelessWidget {
  final MyRequestsResponseDTO? requestInfo;
  final bool showStatus;
  final int? index;
  final int? total;

  const RequestCard({Key? key, this.requestInfo, this.showStatus = false, this.index, this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? issuerNoteValue = requestInfo?.attributes
        ?.firstWhereOrNull((element) => element.displayName == "Issuer Note")
        ?.value;

    return requestInfo?.transactionClassName?.isNotEmpty == true
        ? Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                onTap: () => Navigation.navToRequestDetails(context, requestInfo),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          requestInfo?.requestNumber ?? "",
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        if (requestInfo?.submissionDate?.toString().isNotEmpty == true)
                          Text(
                            dateFormat.format(requestInfo!.submissionDate!) ?? "",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              fontFamily: Fonts.brandon,
                              color: DefaultThemeColors.nepal,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          requestInfo?.transactionClassDisplayName ?? "",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Spacer(),
                        if (showStatus) ...[
                          Text(
                            requestInfo?.status ?? "",
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                  color: statusColor(requestInfo?.status, context),
                                ),
                          )
                        ] else ...[
                          if (requestInfo!.isAppealed!)
                            Text(
                              "appealed" ?? "",
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                        ],
                      ],
                    ),
                    if (requestInfo?.subjectId != context.watch<EmployeeProvider>().employee?.id && !showStatus) ...[
                      SizedBox(height: 4),
                      labelValue(context, "Subject Name: ", requestInfo?.subjectDisplayName ?? ""),
                      SizedBox(height: 4),
                      labelValue(context, "Subject ID: ", requestInfo?.subjectCode ?? ""),
                    ],
                  ],
                ),
                subtitle: (issuerNoteValue?.isNotEmpty == true && !showStatus)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(issuerNoteValue ?? "", style: Theme.of(context).textTheme.subtitle2),
                        ],
                      )
                    : null,
              ),
              if (total != index! + 1) ListDivider(),
            ],
          )
        : SizedBox();
  }

  Widget labelValue(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 14, color: DefaultThemeColors.nepal),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16),
        ),
      ],
    );
  }
}
