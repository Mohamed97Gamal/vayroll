import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/expense_claim/expense_request_card.dart';
import 'package:vayroll/widgets/widgets.dart';

class ExpenseRequestsTab extends StatefulWidget {
  final bool? isMine;
  final List<Employee>? employeeReportees;

  const ExpenseRequestsTab({Key? key, this.isMine, this.employeeReportees}) : super(key: key);
  const ExpenseRequestsTab.mine({Key? key, this.isMine = true, this.employeeReportees}) : super(key: key);
  const ExpenseRequestsTab.team({Key? key, this.isMine = false, this.employeeReportees}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ExpenseRequestsTabState();
}

class ExpenseRequestsTabState extends State<ExpenseRequestsTab> {
  GlobalKey<RefreshableState>? refreshKey;
  String? _status;

  bool _filterVisiable = false;
  List<String?> employeesReporteesIds = [];

  int? expenseLength;

  @override
  void initState() {
    super.initState();
    if (widget?.isMine != null && widget?.isMine == false) {
      if (widget?.employeeReportees != null) {
        widget?.employeeReportees?.forEach((element) {
          employeesReporteesIds.add(element?.id);
        });
      }
    }
    _status = null;
    if (widget?.isMine == null)
      refreshKey = context.read<KeyProvider>().expenseKeyAll;
    else if (widget.isMine!)
      refreshKey = context.read<KeyProvider>().expenseKeyMine;
    else
      refreshKey = context.read<KeyProvider>().expenseKeyTeam;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterRequestsWidget(
          filterVisiable: _filterVisiable,
          status: _status,
          ontap: () => setState(() => _filterVisiable = !_filterVisiable),
          onStatusChange: (value) => setState(() {
            _status = value;
            refreshKey!.currentState!.refresh();
          }),
        ),
        Expanded(
          child: _expenseRequests(),
        ),
      ],
    );
  }

  Widget _expenseRequests() {
    return Refreshable(
      key: refreshKey,
      child: RefreshIndicator(
        onRefresh: () async => refreshKey?.currentState?.refresh(),
        child: CustomPagedListView<MyRequestsResponseDTO>(
          initPageFuture: (pageKey) async {
            var requestResult =
                // (widget?.isMine != null && widget?.isMine == false)
                //     ? await ApiRepo().getAllRequests(
                //         pageIndex: pageKey,
                //         pageSize: pageSize,
                //         submitter: true,
                //         subject: employeesReporteesIds,
                //         requestKind: [
                //             RequestKind.expenseClaim
                //           ],
                //         requestStatus: [
                //             RequestStatus.statusNew,
                //             RequestStatus.statusSubmitted
                //           ])
                //     :
                await ApiRepo().getActiveRequests(
              RequestKind.expenseClaim,
              isMine: widget?.isMine,
              pageIndex: pageKey,
              pageSize: pageSize,
              requestStatus:
                  _status?.isNotEmpty == true && _status!.toUpperCase() != "ALL" ? [_status!.toUpperCase()] : [],
            );
            expenseLength = (expenseLength ?? 0) + (requestResult?.result?.records?.length ?? 0);
            return requestResult.result!.toPagedList();
          },
          itemBuilder: (context, item, index) {
            return Column(
              children: [
                ExpenseRequestCard(
                  expenseRequestInfo: item,
                  refreshableKey: refreshKey,
                ),
                if (expenseLength != index + 1) ListDivider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
