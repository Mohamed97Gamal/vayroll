import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/utils/utils.dart';

class AboutCompanyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AboutCompanyPageState();
}

class AboutCompanyPageState extends State<AboutCompanyPage> {
  Employee? _employee;
  GlobalKey<RefreshableState> _refreshPage = GlobalKey<RefreshableState>();

  @override
  void initState() {
    super.initState();
    _employee = context.read<EmployeeProvider>().employee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke3,
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Refreshable(
        key: _refreshPage,
        child: RefreshIndicator(
          onRefresh: () async => _refreshPage.currentState!.refresh(),
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              _header(),
              AboutCompanyCardWidget(),
              if (_employee!.hasRole(Role.CLevel) || _employee!.hasRole(Role.CanViewDashboards)) AnalyticsCard(),
              DepartmentCardWidget(),
              DocumentsCardWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: TitleStacked(context.appStrings!.aboutCompany, Theme.of(context).primaryColor),
    );
  }
}
