import 'package:flutter/material.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/views/payslip/appeal_tab.dart';
import 'package:vayroll/views/payslip/payslips_tab.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/utils/utils.dart';

class PayslipsPage extends StatefulWidget {
  final int tabIndex;
  const PayslipsPage({Key? key, this.tabIndex = 0}) : super(key: key);

  @override
  _PayslipsPageState createState() => _PayslipsPageState();
}

class _PayslipsPageState extends State<PayslipsPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.tabIndex != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tabController!.animateTo(widget.tabIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke2,
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_header(), _body()],
      ),
    );
  }

  Widget _header() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: TitleStacked(context.appStrings!.payslips, DefaultThemeColors.prussianBlue),
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
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: context.appStrings!.payslips),
                  Tab(text: 'Appeal Requests'),
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
                    PayslipsTab(),
                    PayslipAppealRequestsTab(),
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
