import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class SearchRequestsPage extends StatefulWidget {
  final bool team;
  const SearchRequestsPage({Key? key, this.team = false}) : super(key: key);
  @override
  State<StatefulWidget> createState() => SearchRequestsPageState();
}

class SearchRequestsPageState extends State<SearchRequestsPage> {
  final _refreshableKey = GlobalKey<RefreshableState>();
  final TextEditingController _controller = new TextEditingController();

  String? searchRequestNumber;
  List<MyRequestsResponseDTO> allRequest = [];

  int? requestsLength;

  FilterRequestsProvider? myFilter;
  FilterTeamRequestsProvider? teamFilter;

  @override
  void initState() {
    super.initState();
    myFilter = context.read<FilterRequestsProvider>();
    teamFilter = context.read<FilterTeamRequestsProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke2,
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: DefaultThemeColors.whiteSmoke2,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _header(),
          _list(),
        ],
      ),
    );
  }

  Widget searchTextArea() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            SvgPicture.asset(VPayIcons.search),
            SizedBox(width: 12),
            Expanded(
              child: InnerTextFormField(
                controller: _controller,
                hintText: context.appStrings!.searchByRequestNumber,
                textStyle: Theme.of(context).textTheme.bodyText2,
                onSaved: (String? value) => searchRequestNumber = value?.trim()??"",
                onChanged: (value) {
                  searchRequestNumber = value;
                  _refreshableKey.currentState!.refresh();
                },
              ),
            ),
            SizedBox(width: 8),
            InkWell(
                onTap: () => setState(() {
                      _controller.clear();
                      searchRequestNumber = null;
                      _refreshableKey.currentState!.refresh();
                    }),
                child: SvgPicture.asset(VPayIcons.close)),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 4),
      child: TitleStacked(context.appStrings!.requestSearch, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _list() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: searchTextArea(),
            ),
            Expanded(
              child: Refreshable(
                key: _refreshableKey,
                child: CustomPagedListView<MyRequestsResponseDTO>(
                  initPageFuture: (pageKey) async {
                    var requestResult = await ApiRepo().getAllRequests(
                      behalfOfMe: widget.team ? teamFilter!.behalfOfMe : myFilter!.behalfOfMe,
                      submitter: widget.team ? teamFilter!.byMe : myFilter!.byMe,
                      requestKind: widget.team
                          ? teamFilter!.requestsTypes?.isEmpty == false
                              ? teamFilter!.requestsTypes
                              : null
                          : myFilter!.requestsTypes?.isEmpty == false
                              ? myFilter!.requestsTypes
                              : null,
                      pageIndex: pageKey,
                      pageSize: pageSize,
                      fromClosedDate: widget.team
                          ? teamFilter?.fromClosedDate != null
                              ? (dateFormat2.format(teamFilter!.fromClosedDate!))
                              : null
                          : myFilter?.fromClosedDate != null
                              ? (dateFormat2.format(myFilter!.fromClosedDate!))
                              : null,
                      toClosedDate: widget.team
                          ? teamFilter?.toClosedDate != null
                              ? (dateFormat2.format(teamFilter!.toClosedDate!))
                              : null
                          : myFilter?.toClosedDate != null
                              ? (dateFormat2.format(myFilter!.toClosedDate!))
                              : null,
                      fromSubmissionDate: widget.team
                          ? teamFilter?.fromSubmissionDate != null
                              ? (dateFormat2.format(teamFilter!.fromSubmissionDate!))
                              : null
                          : myFilter?.fromSubmissionDate != null
                              ? (dateFormat2.format(myFilter!.fromSubmissionDate!))
                              : null,
                      toSubmissionDate: widget.team
                          ? teamFilter?.toSubmissionDate != null
                              ? (dateFormat2.format(teamFilter!.toSubmissionDate!))
                              : null
                          : myFilter?.toSubmissionDate != null
                              ? (dateFormat2.format(myFilter!.toSubmissionDate!))
                              : null,
                      requestNumber: searchRequestNumber,
                      requestStatus: [RequestStatus.statusClosed],
                      subject: widget.team ? [] : [context?.read<EmployeeProvider>().employee?.id],
                    );
                    requestsLength = (requestsLength ?? 0) + (requestResult?.result?.records?.length ?? 0);
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
      ),
    );
  }
}
