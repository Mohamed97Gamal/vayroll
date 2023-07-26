import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/approved_requests_tab_index_provider.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/views/requests/mine_team_tab.dart';
import 'package:vayroll/widgets/widgets.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({Key? key}) : super(key: key);

  @override
  RequestsPageState createState() => RequestsPageState();
}

class RequestsPageState extends State<RequestsPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int? requestsLength;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: context.read<ApprovedRequestsTabIndexProvider>().index!,
      length: 2,
      vsync: this,
    );
    context.read<ApprovedRequestsTabIndexProvider>().index = 0;
  }

  Future<BaseResponse<AllRequestsResponse>> getMyRequests(int pageKey) {
    return ApiRepo().getAllRequests(
      pageIndex: pageKey,
      pageSize: pageSize,
      behalfOfMe: context.read<FilterRequestsProvider>().behalfOfMe,
      submitter: context.read<FilterRequestsProvider>().byMe,
      requestKind: context.read<FilterRequestsProvider>().requestsTypes.isEmpty == true
          ? null
          : context.read<FilterRequestsProvider>().requestsTypes,
      fromClosedDate: context.read<FilterRequestsProvider>().fromClosedDate != null
          ? (dateFormat2.format(context.read<FilterRequestsProvider>().fromClosedDate!) ?? null)
          : null,
      toClosedDate: context.read<FilterRequestsProvider>().toClosedDate != null
          ? (dateFormat2.format(context.read<FilterRequestsProvider>().toClosedDate!) ?? null)
          : null,
      fromSubmissionDate: context.read<FilterRequestsProvider>().fromSubmissionDate != null
          ? (dateFormat2.format(context.read<FilterRequestsProvider>().fromSubmissionDate!) ?? null)
          : null,
      toSubmissionDate: context.read<FilterRequestsProvider>().toSubmissionDate != null
          ? (dateFormat2.format(context.read<FilterRequestsProvider>().toSubmissionDate!) ?? null)
          : null,
      requestStatus: [RequestStatus.statusClosed],
      subject: [context.read<EmployeeProvider>().employee?.id],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke2,
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _header(context),
            if (context.read<EmployeeProvider>().employee!.hasRole(Role.CanViewTeamRequests))
              _list()
            else
              _listUserView(),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: TitleStacked(context.appStrings!.approvedRequests, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _list() {
    var _width = MediaQuery.of(context).size.width;

    return Expanded(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
          ),
          Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: context.appStrings!.my),
                  Tab(text: context.appStrings!.team),
                ],
                indicatorColor: Theme.of(context).colorScheme.secondary,
                indicatorWeight: 3,
                labelColor: Theme.of(context).colorScheme.secondary,
                unselectedLabelColor: Theme.of(context).primaryColor,
                labelStyle: _width > 320
                    ? Theme.of(context).textTheme.subtitle1
                    : Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16),
              ),
              Divider(height: 1, thickness: 1, color: DefaultThemeColors.whiteSmoke1),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    MineAndTeamRequestsTab(team: false),
                    MineAndTeamRequestsTab(team: true),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _listUserView() {
    return Expanded(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => Navigation.navToSearchRequestsPage(context, false),
                      child: SvgPicture.asset(VPayIcons.search, width: 16),
                    ),
                    SizedBox(width: 16),
                    InkWell(
                      onTap: () => Navigation.navToFilterRequestsPage(context),
                      child: SvgPicture.asset(VPayIcons.filter),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Refreshable(
                  key: context.read<RequestsKeyProvider>().mykey,
                  child: CustomPagedListView<MyRequestsResponseDTO>(
                    initPageFuture: (pageKey) async {
                      var requestResult = await getMyRequests(pageKey);
                      requestsLength = (requestsLength ?? 0) + (requestResult.result?.records?.length ?? 0);
                      return requestResult.result!.toPagedList();
                    },
                    itemBuilder: (context, item, index) {
                      return RequestCard(
                        requestInfo: item,
                        total: requestsLength,
                        index: index,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
