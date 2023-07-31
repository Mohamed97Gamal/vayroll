import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class DepartmentManagerEmployeesPage extends StatefulWidget {
  final int tabIndex;

  const DepartmentManagerEmployeesPage({
    Key? key,
    this.tabIndex = 0,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => DepartmentManagerEmployeesPageState();
}

class DepartmentManagerEmployeesPageState extends State<DepartmentManagerEmployeesPage> {
  @override
  void initState() {
    super.initState();

    if (widget.tabIndex != 0) {
      //WidgetsBinding.instance.addPostFrameCallback((_) => _tabController.animateTo(widget.tabIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    var _employeeId = context.read<EmployeeProvider>().employee!.id;
    var employeesGroupId = context.read<EmployeeProvider>().employee!.employeesGroup!.id;
    var canViewAllDepartmentsDetails =
        context.read<EmployeeProvider>().employee!.hasRole(Role.CanViewAllDepartmentsDetails);
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke3,
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: DefaultThemeColors.whiteSmoke3,
        elevation: 0,
      ),
      body: CustomFutureBuilder<BaseResponse<List<Department>>>(
        initFuture: () {
          if (canViewAllDepartmentsDetails)
            return ApiRepo().getDepartments(employeeGroupId: employeesGroupId, accessible: false);
          else
            return ApiRepo().getDepartments(employeeId: _employeeId, accessible: true);
        },
        onSuccess: (context, snapshot) {
          var departments = snapshot.data!.result!;
          if (departments.isEmpty) {
            return Column(
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
            );
          }
          // ignore: unnecessary_statements
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              _header(),
              DepartmentsContent(departments),
            ],
          );
        },
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleStacked(context.appStrings!.department, Theme.of(context).primaryColor),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}

class DepartmentsContent extends StatefulWidget {
  final List<Department> departmentEmployees;

  DepartmentsContent(this.departmentEmployees);

  @override
  _DepartmentsContentState createState() => _DepartmentsContentState();
}

class _DepartmentsContentState extends State<DepartmentsContent> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  for (var item in widget.departmentEmployees) Tab(text: item.name),
                ],
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
                flex: 1,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    for (int i = 0; i < widget.departmentEmployees.length; i++)
                      EmployeesList(widget.departmentEmployees[i]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.departmentEmployees.length, vsync: this);
    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) setState(() {});
    });
  }

//

}

class EmployeesList extends StatefulWidget {
  final Department departments;

  EmployeesList(this.departments);

  @override
  _EmployeesListState createState() => _EmployeesListState();
}

class _EmployeesListState extends State<EmployeesList> {
  String? searchEmpName;
  GlobalKey<RefreshableState> _searchRefreshKey = GlobalKey<RefreshableState>();

  TextEditingController _textController = TextEditingController();

  int? employeeLength;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext? context) {
    return Container(
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
              key: _searchRefreshKey,
              child: RefreshIndicator(
                onRefresh: () async => _searchRefreshKey.currentState!.refresh(),
                child: Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 12, right: 8),
                  child: CustomPagedListView<Employee>(
                    initPageFuture: (pageKey) async {
                      var departmentDetailsResponse = await ApiRepo().getDepartmentEmployess(
                        widget.departments.id,
                        context?.read<EmployeeProvider>().employee?.employeesGroup?.id,
                        context?.read<EmployeeProvider>().employee?.id,
                        pageIndex: pageKey,
                        pageSize: pageSize,
                        employeeName: searchEmpName,
                      );
                      employeeLength = (employeeLength ?? 0).toInt() + 0.toInt() + (departmentDetailsResponse.result?.records?.length.toInt()??0);
                      return departmentDetailsResponse.result!.toPagedList();
                    },
                    itemBuilder: (context, item, index) {
                      return Column(
                        children: [
                          empCard(item),
                          if (employeeLength != index + 1)
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
            ),
          ),
        ],
      ),
    );
  }

  Widget empCard(Employee? empInfo) {
    return InkWell(
      onTap: () => Navigation.navToViewProfilePage(context, empInfo, false, departments: widget.departments),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            empInfo?.photo?.id != null
                ? AvatarFutureBuilder<BaseResponse<String>>(
                    initFuture: () => ApiRepo().getFile(empInfo?.photo?.id),
                    onLoading: (context) => CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary),
                    onSuccess: (context, snapshot) {
                      String? photo = snapshot.data?.result;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              (photo != null ? MemoryImage(base64Decode(photo)) : AssetImage(VPayImages.avatar)) as ImageProvider<Object>?,
                        ),
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(VPayImages.avatar),
                    ),
                  ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ((empInfo?.firstName ?? "") + " " + (empInfo?.familyAcronym ??"")),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                    // overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    empInfo?.position?.name ?? "",
                    // overflow: TextOverflow.ellipsis,
                    style:
                        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14, color: DefaultThemeColors.nepal),
                  ),
                ],
              ),
            ),
            //Spacer(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => saveCall(
                      context,
                      empInfo!.contactNumber,
                      recipient: Caller(
                        name: empInfo.fullName,
                        employeeId: empInfo.id,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: DefaultThemeColors.mayaBlue,
                      child: SvgPicture.asset(
                        VPayIcons.contacts_call,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  InkWell(
                    onTap: () => showEmailBottomSheet(
                      context: context,
                      toRecipients: [empInfo?.email],
                      recipientType: RecipientType.emp,
                    ),
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: SvgPicture.asset(
                        VPayIcons.Subscribe,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
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
                controller: _textController,
                hintText: context.appStrings!.searchByEmployeeName,
                textStyle: Theme.of(context).textTheme.bodyText2,
                onSaved: (String? value) => searchEmpName = value?.trim()??"",
                onChanged: (value) {
                  setState(() {
                    searchEmpName = value;
                    _searchRefreshKey.currentState!.refresh();
                  });
                },
              ),
            ),
            SizedBox(width: 8),
            InkWell(
                onTap: () => setState(() {
                      searchEmpName = null;
                      _textController.clear();
                      _searchRefreshKey.currentState!.refresh();
                    }),
                child: SvgPicture.asset(VPayIcons.close)),
          ],
        ),
      ),
    );
  }
}
