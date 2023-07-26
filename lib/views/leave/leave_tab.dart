import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class LeaveRequestsTab extends StatefulWidget {
  final bool? isMine;
  final List<Employee>? employeeReportees;

  const LeaveRequestsTab({Key? key, this.isMine, this.employeeReportees})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => LeaveRequestsTabState();
}

class LeaveRequestsTabState extends State<LeaveRequestsTab> {
  int? leaveLength;
  GlobalKey<RefreshableState>? refreshKey;
  String? _status;
  List<String?> employeesReporteesIds = [];

  bool _filterVisiable = false;

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
      refreshKey = context.read<KeyProvider>().leaveKeyAll;
    else if (widget.isMine!)
      refreshKey = context.read<KeyProvider>().leaveKeyMine;
    else
      refreshKey = context.read<KeyProvider>().leaveKeyTeam;
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
          child: _leaveRequests(),
        ),
      ],
    );
  }

  Widget _leaveRequests() {
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
                //             RequestKind.leave
                //           ],
                //         requestStatus: [
                //             RequestStatus.statusNew,
                //             RequestStatus.statusSubmitted
                //           ])
                //     :
                await ApiRepo().getActiveRequests(
              RequestKind.leave,
              isMine: widget?.isMine,
              pageIndex: pageKey,
              pageSize: pageSize,
              requestStatus:
                  _status?.isNotEmpty == true && _status!.toUpperCase() != "ALL"
                      ? [_status!.toUpperCase()]
                      : [],
            );
            leaveLength = (leaveLength ?? 0) +
                (requestResult?.result?.records?.length ?? 0);
            return requestResult.result!.toPagedList();
          },
          itemBuilder: (context, item, index) {
            return LeaveRequestCard(
              leaveRequestInfo: item,
              refreshableKey: refreshKey,
              leaveLength: leaveLength,
              index: index,
            );
          },
        ),
      ),
    );
  }
}
