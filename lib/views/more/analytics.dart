import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String? _employeesGroupId;
  List<String>? _departmentIds;

  @override
  void initState() {
    super.initState();
    _employeesGroupId = context.read<EmployeeProvider>().employee!.employeesGroup!.id;
    _departmentIds = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          _body(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: TitleStacked(context.appStrings!.employeesAnalytics, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _body(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          DataScopeSelector(
            selectedOptionCallback: (value) {
              if (value == 0) {
                setState(() {
                  _departmentIds = null;
                });
              }
              context.read<KeyProvider>().contactsCharts!.currentState!.refresh();
              context.read<KeyProvider>().experneceCharts!.currentState!.refresh();
              context.read<KeyProvider>().posisionCharts!.currentState!.refresh();
            },
            selectedDepartmentCallback: (value) {
              setState(() {
                _departmentIds = value;
              });
              context.read<KeyProvider>().contactsCharts!.currentState!.refresh();
              context.read<KeyProvider>().experneceCharts!.currentState!.refresh();
              context.read<KeyProvider>().posisionCharts!.currentState!.refresh();
            },
          ),
          Expanded(
            child: ListView(
              children: [
                GraphCard(
                  child: ContractsWidget(departmentIds: _departmentIds, employeesGroupId: _employeesGroupId),
                ),
                GraphCard(
                  child: PositionChartWidget(departmentIds: _departmentIds, employeesGroupId: _employeesGroupId),
                ),
                GraphCard(
                  child: ExperienceWidget(departmentIds: _departmentIds, employeesGroupId: _employeesGroupId),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GraphCard extends StatelessWidget {
  final Widget child;

  GraphCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 2,
          )
        ],
      ),
      child: child,
    );
  }
}
