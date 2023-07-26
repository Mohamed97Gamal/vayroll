import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class PayslipAppealRequestsTab extends StatefulWidget {
  const PayslipAppealRequestsTab({Key? key}) : super(key: key);

  @override
  State<PayslipAppealRequestsTab> createState() => _PayslipAppealRequestsTabState();
}

class _PayslipAppealRequestsTabState extends State<PayslipAppealRequestsTab> {
  int? payslipsAppealLength;

  @override
  Widget build(BuildContext context) {
    return CustomPagedListView<Appeal>(
      padding: EdgeInsets.symmetric(vertical: 12),
      initPageFuture: (pageKey) async {
        var appealResponse = await ApiRepo().getAppealRequests(
          category: RequestCategory.payroll,
          pageSize: pageSize,
          pageIndex: pageKey,
          submitter: true,
        );
        payslipsAppealLength = (payslipsAppealLength ?? 0) + (appealResponse.result?.records?.length ?? 0);
        return appealResponse.result!.toPagedList();
      },
      itemBuilder: (context, item, index) {
        String? submissionDate;
        if (item.submissionDate?.toString().isNotEmpty == true)
          submissionDate = dateFormat.format(item.submissionDate!);
        return Column(
          children: [
            AppealRequestCard(
              requestID: "${item.category ?? ""} ${item.entityReferenceNumber ?? ""}" ?? "",
              requestDate: submissionDate ?? "",
              onTap: () => Navigation.navToAppealRequestDetails(context, item.id),
            ),
            if (payslipsAppealLength != index + 1)
              Divider(
                height: 10,
                thickness: 1,
                indent: 60,
                color: DefaultThemeColors.whiteSmoke1,
              ),
          ],
        );
      },
    );
  }
}
