import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/views/leave/appeal_tab.dart';
import 'package:vayroll/views/leave/leave_tab.dart';
import 'package:vayroll/widgets/widgets.dart';

class LeaveManagementPage extends StatefulWidget {
  final Employee? employee;
  final int tabIndex;

  const LeaveManagementPage({Key? key, this.employee, this.tabIndex = 0}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LeaveManagementPageState();
}

class LeaveManagementPageState extends State<LeaveManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomFutureBuilder<BaseResponse<List<Employee>>>(
        initFuture: () => ApiRepo().getEmployeeReportees(widget.employee?.id, widget.employee?.employeesGroup?.id),
        onSuccess: (context, snapshot) {
          List<Employee>? employeeReportees = snapshot.data?.result;
          bool hasReportees = employeeReportees != null && employeeReportees.isNotEmpty;
          return LeavePageContent(
            employee: widget.employee,
            tabIndex: widget.tabIndex,
            tabLength: hasReportees ? 4 : 2,
            employeeReportees: employeeReportees,
          );
        },
      ),
    );
  }
}

class LeavePageContent extends StatefulWidget {
  final Employee? employee;
  final int tabIndex;
  final int? tabLength;
  final List<Employee>? employeeReportees;

  const LeavePageContent({Key? key, this.employee, this.tabIndex = 0, this.tabLength, this.employeeReportees})
      : super(key: key);

  @override
  LeavePageContentState createState() => LeavePageContentState();
}

class LeavePageContentState extends State<LeavePageContent> with SingleTickerProviderStateMixin {
  final firstMonth = DateFormat('MMM-yyyy').format(DateTime(DateTime.now().year, 1));
  final lastMonth = DateFormat('MMM-yyyy').format(DateTime(DateTime.now().year, 12));
  List<LeaveBalanceResponseDTO> leaveBalancesValues=[];
  TabController? _tabController;
  int? leaveIndex = 0;

  @override
  void initState() {
    super.initState();
    print(widget.employeeReportees);
    _tabController = TabController(length: widget.tabLength!, vsync: this);
    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging || _tabController!.index != _tabController!.previousIndex) {
        setState(() {
          leaveIndex = _tabController?.index;
        });
      }
    });
    if (widget.tabIndex != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tabController!.animateTo(widget.tabIndex));
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        context.read<KeyProvider>().homeLeaveNotifier.refresh();
        context.read<KeyProvider>().decidableHomeFABKey?.currentState?.refresh();
        Navigator.of(context).pop();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _appBar() as PreferredSizeWidget?,
        body: Refreshable(
          key: context.read<KeyProvider>().leavePageKey,
          onRefresh: () {
            if (leaveIndex == 0) context.read<KeyProvider>().leaveKeyAll!.currentState!.refresh();
            if (leaveIndex == 1) context.read<KeyProvider>().leaveKeyMine!.currentState!.refresh();
            if (leaveIndex == 2) context.read<KeyProvider>().leaveKeyTeam!.currentState!.refresh();
          },
          child: Column(
            children: [
              _header(),
              _body(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      leading: CustomBackButton(onPressed: ()async{
        context.read<KeyProvider>().homeLeaveNotifier.refresh();
        context.read<KeyProvider>().decidableHomeFABKey?.currentState?.refresh();
        Navigator.of(context).pop();
      },),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _body() {
    return Expanded(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tabs(),
              Divider(height: 1, thickness: 1, color: DefaultThemeColors.whiteSmoke1),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    LeaveRequestsTab(),
                    if (widget.tabLength == 4) ...[
                      LeaveRequestsTab(isMine: true),
                      LeaveRequestsTab(
                        isMine: false,
                        employeeReportees: widget.employeeReportees,
                      ),
                    ],
                    AppealRequestsLeaveTab(),
                  ],
                ),
              ),
              _footer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: TitleStacked(context.appStrings!.leaveManagement, Theme.of(context).primaryColor),
        ),
        SizedBox(height: 8),
        Container(
          color: DefaultThemeColors.whiteSmoke3,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Leaves applicable from $firstMonth to $lastMonth",
                //   style: Theme.of(context).textTheme.subtitle1.copyWith(color: DefaultThemeColors.nepal),
                // ),
                CustomFutureBuilder<LeaveBalanceResponse>(
                  initFuture: () => ApiRepo().getLeaveBalance(widget.employee?.id),
                  onSuccess: (context, snapshot) {
                    var leaveBalances = snapshot.data!.result ?? [];
                    leaveBalancesValues=leaveBalances;
                    return leaveBalances.isNotEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            color: DefaultThemeColors.whiteSmoke3,
                            height: 120,
                            child: ListView.builder(
                              itemCount: leaveBalances.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () => showLeaveBalanceBottomSheet(
                                    context: context,
                                    leaveBalanceInfo: leaveBalances[index],
                                  ),
                                  child: LeaveBalanceCardWidget(
                                    leaveBalanceInfo: leaveBalances[index],
                                    showDetails: true,
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Container(
                              child: Text(
                                context.appStrings!.thereIsNoLeaveBalanceForYouNow,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabs() {
    var _width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(color: DefaultThemeColors.whiteSmoke3),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Center(
          child: TabBar(
            controller: _tabController,
            physics: ClampingScrollPhysics(),
            tabs: [
              Tab(text: context.appStrings!.all),
              if (widget.tabLength == 4) ...[
                Tab(text: context.appStrings!.me),
                Tab(text: context.appStrings!.team),
              ],
              Tab(text: context.appStrings!.appeal),
            ],
            indicatorColor: Theme.of(context).colorScheme.secondary,
            indicatorWeight: 3,
            labelColor: Theme.of(context).colorScheme.secondary,
            unselectedLabelColor: Theme.of(context).primaryColor,
            labelStyle: _width > 320
                ? Theme.of(context).textTheme.subtitle1
                : Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300),
          child: CustomElevatedButton(
            text: context.appStrings!.applyForLeave.toUpperCase(),
            onPressed: () => Navigation.navToSubmetRequest(context, RequestKind.leave, context.appStrings!.applyLeave),
          ),
        ),
      ),
    );
  }
}
