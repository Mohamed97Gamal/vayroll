import 'package:flutter/material.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/views/decidable_requests/decidable_request_appeal_tab.dart';
import 'package:vayroll/views/decidable_requests/decidable_request_documents_tab.dart';
import 'package:vayroll/views/decidable_requests/decidable_request_expense_tab.dart';
import 'package:vayroll/views/decidable_requests/decidable_request_leave_tab.dart';
import 'package:vayroll/views/decidable_requests/decidable_request_profile_tab.dart';
import 'package:vayroll/widgets/back_button.dart';
import 'package:vayroll/widgets/title_stack.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/utils/utils.dart';

class DecidableRequests extends StatefulWidget {
  final int tabIndex;

  const DecidableRequests({Key? key, this.tabIndex = 0}) : super(key: key);

  @override
  _DecidableRequestsState createState() => _DecidableRequestsState();
}

class _DecidableRequestsState extends State<DecidableRequests> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
        backgroundColor: DefaultThemeColors.whiteSmoke2,
        appBar: AppBar(
          leading: CustomBackButton(
            onPressed: () async {
              context.read<KeyProvider>().homeLeaveNotifier.refresh();
              context.read<KeyProvider>().decidableHomeFABKey?.currentState?.refresh();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_header(), _body()],
        ),
      ),
    );
  }

  Widget _header() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: TitleStacked(context.appStrings!.decidableRequests, DefaultThemeColors.prussianBlue),
      );

  Widget _body() {
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
              Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: context.appStrings!.profile),
                    Tab(text: context.appStrings!.leave),
                    Tab(text: context.appStrings!.attendanceAppeal),
                    Tab(text: context.appStrings!.expenseClaim),
                    Tab(text: context.appStrings!.documents),
                  ],
                  isScrollable: true,
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  indicatorWeight: 3,
                  labelColor: Theme.of(context).colorScheme.secondary,
                  unselectedLabelColor: Theme.of(context).primaryColor,
                  labelStyle: _width > 320 ? Theme.of(context).textTheme.subtitle1 : Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16),
                ),
              ),
              Divider(height: 1, thickness: 1, color: DefaultThemeColors.whiteSmoke1),
              Expanded(
                flex: 1,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    DecidableRequestProfileTab(),
                    DecidableRequestLeaveTab(),
                    DecidableRequestAppealTab(),
                    DecidableRequestExpenseTab(),
                    DecidableDocumentsTab(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
