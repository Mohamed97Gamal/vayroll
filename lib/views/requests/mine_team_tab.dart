import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/models/my_requests_response.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class MineAndTeamRequestsTab extends StatefulWidget {
  final bool team;

  const MineAndTeamRequestsTab({Key? key, this.team = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MineAndTeamRequestsTabState();
}

class MineAndTeamRequestsTabState extends State<MineAndTeamRequestsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.team
          ? CustomFutureBuilder<BaseResponse<List<Employee>>>(
              initFuture: () => ApiRepo().getEmployeeReportees(context.read<EmployeeProvider>().employee?.id,
                  context.read<EmployeeProvider>().employee?.employeesGroup?.id),
              onSuccess: (context, snapshot) {
                List<Employee>? employeeReportees = snapshot.data?.result;
                return MineAndTeamRequestsTabContent(
                  team: widget.team,
                  employeeReportees: employeeReportees,
                );
              },
            )
          : MineAndTeamRequestsTabContent(team: widget.team),
    );
  }
}

class MineAndTeamRequestsTabContent extends StatefulWidget {
  final bool team;
  final List<Employee>? employeeReportees;

  const MineAndTeamRequestsTabContent({Key? key, this.team = false, this.employeeReportees}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MineAndTeamRequestsTabContentState();
}

class MineAndTeamRequestsTabContentState extends State<MineAndTeamRequestsTabContent> {
  int? requetslength;

  Future<BaseResponse<AllRequestsResponse>> myRequests(int pageKey) {
    List<String?> employeesReporteesIds = [];

    if (widget.employeeReportees != null) {
      widget.employeeReportees?.forEach((element) {
        employeesReporteesIds.add(element.id);
      });
    }

    return ApiRepo().getAllRequests(
      pageSize: pageSize,
      pageIndex: pageKey,
      behalfOfMe: widget.team
          ? context.read<FilterTeamRequestsProvider>().behalfOfMe
          : context.read<FilterRequestsProvider>().behalfOfMe,
      submitter: widget.team
          ? context.read<FilterTeamRequestsProvider>().byMe
          : context.read<FilterRequestsProvider>().byMe,
      manager: widget.team,
      subject: widget.team ? employeesReporteesIds : [context.read<EmployeeProvider>().employee?.id],
      requestKind: widget.team
          ? context.read<FilterTeamRequestsProvider>().requestsTypes.isEmpty == true
              ? null
              : context.read<FilterTeamRequestsProvider>().requestsTypes
          : context.read<FilterRequestsProvider>().requestsTypes.isEmpty == true
              ? null
              : context.read<FilterRequestsProvider>().requestsTypes,
      fromClosedDate: widget.team
          ? context.read<FilterTeamRequestsProvider>().fromClosedDate != null
              ? (dateFormat2.format(context.read<FilterTeamRequestsProvider>().fromClosedDate!) ?? null)
              : null
          : context.read<FilterRequestsProvider>().fromClosedDate != null
              ? (dateFormat2.format(context.read<FilterRequestsProvider>().fromClosedDate!) ?? null)
              : null,
      toClosedDate: widget.team
          ? context.read<FilterTeamRequestsProvider>().toClosedDate != null
              ? (dateFormat2.format(context.read<FilterTeamRequestsProvider>().toClosedDate!))
              : null
          : context.read<FilterRequestsProvider>().toClosedDate != null
              ? (dateFormat2.format(context.read<FilterRequestsProvider>().toClosedDate!) ?? null)
              : null,
      fromSubmissionDate: widget.team
          ? context.read<FilterTeamRequestsProvider>().fromSubmissionDate != null
              ? (dateFormat2.format(context.read<FilterTeamRequestsProvider>().fromSubmissionDate!) ?? null)
              : null
          : context.read<FilterRequestsProvider>().fromSubmissionDate != null
              ? (dateFormat2.format(context.read<FilterRequestsProvider>().fromSubmissionDate!) ?? null)
              : null,
      toSubmissionDate: widget.team
          ? context.read<FilterTeamRequestsProvider>().toSubmissionDate != null
              ? (dateFormat2.format(context.read<FilterTeamRequestsProvider>().toSubmissionDate!) ?? null)
              : null
          : context.read<FilterRequestsProvider>().toSubmissionDate != null
              ? (dateFormat2.format(context.read<FilterRequestsProvider>().toSubmissionDate!) ?? null)
              : null,
      requestStatus: [RequestStatus.statusClosed],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => Navigation.navToSearchRequestsPage(context, widget.team),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: SvgPicture.asset(VPayIcons.search),
                  ),
                ),
                SizedBox(width: 16),
                InkWell(
                  onTap: () => widget.team
                      ? Navigation.navToFilterTeamRequestsPage(context)
                      : Navigation.navToFilterRequestsPage(context),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: SvgPicture.asset(VPayIcons.filter),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Refreshable(
              key:
                  widget.team ? context.read<RequestsKeyProvider>().teamkey : context.read<RequestsKeyProvider>().mykey,
              child: CustomPagedListView<MyRequestsResponseDTO>(
                initPageFuture: (pageKey) async {
                  var requestResult = await myRequests(pageKey);
                  requetslength = (requetslength ?? 0) + (requestResult.result?.records?.length ?? 0);
                  return requestResult.result!.toPagedList();
                },
                itemBuilder: (context, item, index) {
                  return RequestCard(
                    requestInfo: item,
                    total: requetslength,
                    index: index,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
