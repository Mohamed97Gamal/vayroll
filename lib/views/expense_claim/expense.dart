import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/views/expense_claim/appeal_tab.dart';
import 'package:vayroll/views/expense_claim/expense_tab.dart';
import 'package:vayroll/widgets/expense_claim/pie_chart.dart';
import 'package:vayroll/widgets/widgets.dart';

int? expenseIndex = 0;

class ExpenseClaimPage extends StatefulWidget {
  final Employee? employee;
  final int tabIndex;
  const ExpenseClaimPage({Key? key, this.employee, this.tabIndex = 0}) : super(key: key);
  @override
  State<StatefulWidget> createState() => ExpenseClaimPageState();
}

class ExpenseClaimPageState extends State<ExpenseClaimPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomFutureBuilder<BaseResponse<List<Employee>>>(
        initFuture: () => ApiRepo().getEmployeeReportees(widget.employee?.id, widget.employee?.employeesGroup?.id),
        onSuccess: (context, snapshot) {
          List<Employee>? employeeReportees = snapshot.data?.result;
          bool hasReportees = employeeReportees != null && employeeReportees.isNotEmpty;
          return ExpenseClaimContent(
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

class ExpenseClaimContent extends StatefulWidget {
  final Employee? employee;
  final int tabIndex;
  final int? tabLength;
  final List<Employee>? employeeReportees;

  const ExpenseClaimContent({Key? key, this.employee, this.tabIndex = 0, this.tabLength, this.employeeReportees})
      : super(key: key);
  @override
  ExpenseClaimContentState createState() => ExpenseClaimContentState();
}

class ExpenseClaimContentState extends State<ExpenseClaimContent> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabLength!, vsync: this);
    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging || _tabController!.index != _tabController!.previousIndex) {
        setState(() {
          expenseIndex = _tabController?.index;
        });
      }
    });
    if (widget.tabIndex != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tabController!.animateTo(widget.tabIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke3,
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: Refreshable(
        key: context.read<KeyProvider>().expensePageKey,
        onRefresh: () {
          if (expenseIndex == 0) context.read<KeyProvider>().expenseKeyAll!.currentState!.refresh();
          if (expenseIndex == 1) context.read<KeyProvider>().expenseKeyMine!.currentState!.refresh();
          if (expenseIndex == 2) context.read<KeyProvider>().expenseKeyTeam!.currentState!.refresh();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            CustomFutureBuilder<BaseResponse<ExpenseResponse>>(
              initFuture: () => ApiRepo().getExpensesClaims(widget.employee?.id, dateFormat2.format(DateTime.now())),
              onSuccess: (context, snapshot) {
                ExpenseResponse? expenseClaim = snapshot.data!.result;
                return (expenseClaim?.expenses?.isEmpty == true)
                    ? SizedBox()
                    : PieChartWidget(expenseClaim: expenseClaim);
              },
            ),
            _BodyContent(
              employee: widget.employee,
              tabController: _tabController,
              tabIndex: widget.tabIndex,
              tabLength: widget.tabLength,
              employeeReportees: widget.employeeReportees,
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: TitleStacked(context.appStrings!.expense, DefaultThemeColors.prussianBlue),
    );
  }
}

class _BodyContent extends StatefulWidget {
  final Employee? employee;
  final int? tabIndex;
  final int? tabLength;
  final TabController? tabController;
  final List<Employee>? employeeReportees;

  const _BodyContent(
      {Key? key, this.employee, this.tabIndex, this.tabLength, this.tabController, this.employeeReportees})
      : super(key: key);
  @override
  BodyContentState createState() => BodyContentState();
}

class BodyContentState extends State<_BodyContent> {
  @override
  Widget build(BuildContext context) {
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
              _tabs(),
              Divider(height: 1, thickness: 1, color: DefaultThemeColors.whiteSmoke1),
              Expanded(
                child: TabBarView(
                  controller: widget.tabController,
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    ExpenseRequestsTab(),
                    if (widget.tabLength == 4) ...[
                      ExpenseRequestsTab.mine(),
                      ExpenseRequestsTab.team(
                        employeeReportees: widget.employeeReportees,
                      ),
                    ],
                    ExpenseAppealRequestsTab(),
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

  Widget _tabs() {
    var _width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(color: DefaultThemeColors.whiteSmoke3),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Center(
          child: TabBar(
            controller: widget.tabController,
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
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: CustomElevatedButton(
          text: context.appStrings!.expenseClaim.toUpperCase(),
          onPressed: () => Navigation.navToSubmetRequest(
            context,
            RequestKind.expenseClaim,
            context.appStrings!.expenseClaim,
          ),
        ),
      ),
    );
  }
}
