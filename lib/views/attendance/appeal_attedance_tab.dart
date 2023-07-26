import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/utils/utils.dart';

class AttendanceAppealTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AttendanceAppealTabState();
}

class AttendanceAppealTabState extends State<AttendanceAppealTab> {
  final _attendanceRequestRefreshableKey = GlobalKey<RefreshableState>();
  String? _status;

  bool _filterVisible = false;

  int? attendanceAppeal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FilterRequestsWidget(
              filterVisiable: _filterVisible,
              status: _status,
              ontap: () => setState(() => _filterVisible = !_filterVisible),
              onStatusChange: (value) => setState(() {
                _status = value;
                _attendanceRequestRefreshableKey.currentState!.refresh();
              }),
            ),
          ),
          Expanded(
            child: attendanceTab(),
          ),
        ],
      ),
    );
  }

  Widget attendanceTab() {
    return Refreshable(
      key: _attendanceRequestRefreshableKey,
      child: CustomPagedListView<MyRequestsResponseDTO>(
        initPageFuture: (pageKey) async {
          var requestResult = await ApiRepo().getActiveRequests(
            RequestKind.attendanceAppealRequest,
            pageIndex: pageKey,
            pageSize: pageSize,
            requestStatus: _status?.isNotEmpty == true && _status!.toUpperCase() != "ALL" ? [_status!.toUpperCase()] : [],
          );
          attendanceAppeal = (attendanceAppeal ?? 0) + (requestResult?.result?.records?.length ?? 0);
          return requestResult.result!.toPagedList();
        },
        itemBuilder: (context, item, index) {
          return Column(
            children: [
              AttendanceAppealCard(
                attendanceInfo: item,
                refreshableKey: _attendanceRequestRefreshableKey,
                onTap: () => Navigation.navToRequestDetails(context, item),
              ),
              if (attendanceAppeal != index + 1)
                Divider(
                  height: 10,
                  thickness: 1,
                  indent: 60,
                  color: DefaultThemeColors.whiteSmoke1,
                ),
            ],
          );
        },
      ),
    );
  }
}
