import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:provider/provider.dart';

class DepartmentPage extends StatefulWidget {
  final int tabIndex;
  final List<Department>? departmentsAttendanceAccessible;
  final String? employeeId;
  final String? employeesGroupId;

  const DepartmentPage({
    Key? key,
    this.tabIndex = 0,
    this.departmentsAttendanceAccessible,
    this.employeeId,
    this.employeesGroupId,
  }) : super(key: key);

  @override
  _DepartmentPageState createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late DateTime dateTime;
  bool showFilter = false;
  List<GlobalKey<RefreshableState>> departmentsKeys = [];
  List<DateTime> employeesHireDates = [];
  var refreshDepartmentKey = GlobalKey<RefreshableState>();

  int? departmentLength;

  @override
  void initState() {
    super.initState();
    departmentsKeys = List<GlobalKey<RefreshableState>>.generate(
        widget.departmentsAttendanceAccessible!.length, (counter) => GlobalKey<RefreshableState>());
    _tabController = TabController(length: widget.departmentsAttendanceAccessible!.length, vsync: this);
    if (widget.tabIndex != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tabController!.animateTo(widget.tabIndex));
    }
    dateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke2,
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: widget.departmentsAttendanceAccessible!.length != 0
          ? Column(
              children: [
                _header(),
                const SizedBox(height: 8),
                _body(),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                _header(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 100, 8, 8),
                  child: Center(
                    heightFactor: 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          VPayImages.empty,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          height: 200,
                        ),
                        SizedBox(height: 16),
                        Text(
                          context.appStrings!.noDataToDisplay,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Color(0xff444053)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TitleStacked(context.appStrings!.attendance, DefaultThemeColors.prussianBlue),
              Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(VPayIcons.calendar, height: 16),
                      const SizedBox(width: 6),
                      dateTime.day != DateTime.now().day
                          ? Text(dateFormat.format(dateTime), style: Theme.of(context).textTheme.subtitle1)
                          : Text(context.appStrings!.today, style: Theme.of(context).textTheme.subtitle1),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

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
            child: Refreshable(
              key: refreshDepartmentKey,
              child: CustomFutureBuilder<BaseResponse<List<Department>>>(
                initFuture: () {
                  if (widget.employeeId != null) {
                    return ApiRepo().getDepartments(employeeId: widget.employeeId, accessible: true);
                  } else {
                    return ApiRepo().getDepartments(
                        employeeId: widget.employeeId, accessible: false, employeeGroupId: widget?.employeesGroupId);
                  }
                },
                onSuccess: (context, snapshot) {
                  var accessibleDepartments = snapshot.data!.result;
                  if (accessibleDepartments == null) accessibleDepartments = [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabBar(
                        controller: _tabController,
                        tabs: [for (var item in accessibleDepartments) Tab(text: item.name)],
                        isScrollable: true,
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
                            for (int i = 0; i < accessibleDepartments.length; i++)
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        if (showFilter) ...[
                                          SizedBox(
                                            width: 200,
                                            child: InnerTextFormField(
                                              hintText: context.appStrings!.from,
                                              textAlignVertical: TextAlignVertical.bottom,
                                              controller: TextEditingController(text: dateFormat.format(dateTime)),
                                              readOnly: true,
                                              suffixIcon: SvgPicture.asset(
                                                VPayIcons.calendar,
                                                fit: BoxFit.none,
                                                alignment: Alignment.center,
                                              ),
                                              onTap: () async {
                                                final result = await showDatePicker(
                                                  context: context,
                                                  initialDate: dateTime,
                                                  firstDate: context
                                                      .read<EmployeeProvider>()
                                                      .employee
                                                      !.employeesGroup
                                                      !.establishmentDate!,
                                                  lastDate: DateTime.now(),
                                                  builder: (BuildContext context, Widget? child) {
                                                    return Theme(
                                                      data: ThemeData.light().copyWith(
                                                        colorScheme: ColorScheme.light().copyWith(
                                                          primary: Theme.of(context).colorScheme.secondary,
                                                        ),
                                                      ),
                                                      child: child!,
                                                    );
                                                  },
                                                );
                                                if (result == null) return;
                                                setState(() {
                                                  dateTime = result;
                                                });
                                                refreshDepartmentKey.currentState!.refresh();
                                              },
                                            ),
                                          ),
                                          Spacer(),
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  dateTime = DateTime.now();
                                                });
                                                refreshDepartmentKey.currentState!.refresh();
                                              },
                                              child: Text(context.appStrings!.reset,
                                                  style: Theme.of(context).textTheme.subtitle1)),
                                        ],
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () => setState(() => showFilter = !showFilter),
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: showFilter ? DefaultThemeColors.lightCyan : Colors.transparent,
                                            ),
                                            child: SvgPicture.asset(
                                              VPayIcons.filter,
                                              fit: BoxFit.none,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomFutureBuilder<BaseResponse<DepartmentAttendanceResponse>>(
                                    initFuture: () => ApiRepo().getDepartmentAttendanceSummary(
                                      context.read<EmployeeProvider>().employee?.id,
                                      dateTime,
                                      accessibleDepartments![i].id,
                                    ),
                                    onSuccess: (context, snapshot) {
                                      return DepartmentTabCard(
                                        leave: snapshot?.data?.result?.leave,
                                        present: snapshot?.data?.result?.present,
                                        total: snapshot?.data?.result?.total,
                                      );
                                    },
                                  ),
                                  Expanded(
                                    child: RefreshIndicator(
                                      onRefresh: () async => refreshDepartmentKey.currentState!.refresh(),
                                      child: CustomPagedListView<EmployeeAttendance>(
                                        initPageFuture: (pageKey) async {
                                          var departmentAttendanceResponse = await ApiRepo().getDepartmentAttendance(
                                            context.read<EmployeeProvider>().employee?.id,
                                            dateTime,
                                            accessibleDepartments![i].id,
                                            pageIndex: pageKey,
                                            pageSize: pageSize,
                                          );
                                          departmentLength = (departmentLength ?? 0) +
                                              (departmentAttendanceResponse?.result?.records?.length ?? 0);
                                          return departmentAttendanceResponse.result!.toPagedList();
                                        },
                                        itemBuilder: (context, item, index) {
                                          return Column(
                                            children: [
                                              DepartmentEmployeeCard(attendance: item),
                                              if (departmentLength != index + 1)
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
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
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
