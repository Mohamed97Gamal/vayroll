import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class ExpenseAppealRequestsTab extends StatefulWidget {
  @override
  State<ExpenseAppealRequestsTab> createState() => _ExpenseAppealRequestsTabState();
}

class _ExpenseAppealRequestsTabState extends State<ExpenseAppealRequestsTab> {
  int? expensesAppealLength;

  @override
  Widget build(BuildContext context) {
    return CustomPagedListView<Appeal>(
      initPageFuture: (pageKey) async {
        var appealResponse = await ApiRepo().getAppealRequests(
          category: RequestCategory.expenseClaim,
          pageSize: pageSize,
          pageIndex: pageKey,
          submitter: true,
        );
        expensesAppealLength = (expensesAppealLength ?? 0) + (appealResponse.result?.records?.length ?? 0);
        return appealResponse.result!.toPagedList();
      },
      itemBuilder: (context, item, index) {
        String? submissionDate;
        if (item.submissionDate?.toString().isNotEmpty == true)
          submissionDate = dateFormat.format(item.submissionDate!);
        return Column(
          children: [
            AppealRequestCard(
              requestID: "${item.entityReferenceNumber ?? ""}" ?? "",
              requestDate: submissionDate ?? "",
              onTap: () => Navigation.navToAppealRequestDetails(context, item.id),
            ),
            if (expensesAppealLength != index + 1)
              Divider(
                height: 10,
                thickness: 1,
                //indent: 60,
                color: DefaultThemeColors.whiteSmoke1,
              ),
          ],
        );
      },
    );
  }
}
