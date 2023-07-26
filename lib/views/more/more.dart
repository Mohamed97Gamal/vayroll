import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/enums/role.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: (context.watch<EmployeeProvider>().employee?.photoBase64 != null
                ? MemoryImage(context.watch<EmployeeProvider>().employee!.photoBytes!)
                : AssetImage(VPayImages.avatar)) as ImageProvider<Object>?,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [_header(context), _list(context)],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: TitleStacked(context.appStrings!.more, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _list(BuildContext context) {
    var currentEmployee = context.read<EmployeeProvider>().employee!;
    String? employeesGroupId = currentEmployee.employeesGroup!.id;
    String? employeeId = currentEmployee.id;
    bool canViewAllDepartmentsAttendance = currentEmployee.hasRole(Role.CanViewAllDepartmentsAttendance);
    bool canViewDepartmentsAttendance = currentEmployee.hasRole(Role.CanViewDepartmentAttendance);
    bool canViewDepartmentsDetails = currentEmployee.hasRole(Role.CanViewDepartmentsDetails);
    bool canViewAllDepartmentsDetails = currentEmployee.hasRole(Role.CanViewAllDepartmentsDetails);
    bool canViewHierarchy =
        currentEmployee.hasRole(Role.CanViewEntityHierarchy) || currentEmployee.hasRole(Role.CanViewOrgHierarchy);
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: ListView(
          children: [
            SizedBox(height: 10),
            _listTile(
              context,
              leadingIconSvg: VPayIcons.information,
              title: context.appStrings!.aboutCompany,
              onTap: () => Navigation.navToAboutCompany(context),
            ),
            if (canViewHierarchy) ...[
              ListDivider(),
              _listTile(
                context,
                leadingIconSvg: VPayIcons.up_down,
                title: context.appStrings!.organizationHierarchy,
                onTap: () => Navigation.navToOrganizationChart(context),
              ),
            ],
            ListDivider(),
            _listTile(
              context,
              leadingIconSvg: VPayIcons.department,
              title: context.appStrings!.department,
              onTap: () async {
                if (!canViewDepartmentsDetails && !canViewAllDepartmentsDetails) {
                  Navigation.navToDepartmentEmployees(context);
                } else {
                  Navigation.navToDepartmentEmployess(context);
                }
              },
            ),
            if (canViewAllDepartmentsAttendance || canViewDepartmentsAttendance)
              Column(
                children: [
                  ListDivider(),
                  _listTile(
                    context,
                    leadingIconSvg: VPayIcons.departmentAttendance,
                    title: context.appStrings!.departmentAttendance,
                    onTap: () async {
                      final departmentsAttendanceResponse =
                          (await showFutureProgressDialog<BaseResponse<List<Department>>>(
                        context: context,
                        initFuture: () {
                          if (canViewAllDepartmentsAttendance) {
                            return ApiRepo().getDepartments(employeeGroupId: employeesGroupId, accessible: false);
                          } else {
                            return ApiRepo().getDepartments(employeeId: employeeId, accessible: true);
                          }
                        },
                      ))!;
                      if (departmentsAttendanceResponse.status!) {
                        if (canViewAllDepartmentsAttendance) {
                          Navigation.navToDepartment(
                              context, departmentsAttendanceResponse.result, null, employeesGroupId);
                        } else {
                          Navigation.navToDepartment(context, departmentsAttendanceResponse.result, employeeId, null);
                        }
                      }
                    },
                  ),
                ],
              ),
            CustomFutureBuilder<BaseResponse<bool>>(
              initFuture: () => ApiRepo().isUserApproverForDecidable(),
              onLoading: (context) {
                return Container();
              },
              onSuccess: (context, snapshot) {
                bool isApprover = snapshot.data?.result ?? false;
                return !isApprover
                    ? Container()
                    : Column(
                        children: [
                          ListDivider(),
                          _listTile(
                            context,
                            leadingIconSvg: VPayIcons.decidableRequestIconMore,
                            title: context.appStrings!.decidableRequests,
                            onTap: () => Navigation.navToDecidableRequests(context),
                          ),
                        ],
                      );
              },
            ),
            if (context.read<EmployeeProvider>().employee!.hasRole(Role.CanViewAppealRequests)) ...[
              ListDivider(),
              _listTile(
                context,
                leadingIconSvg: VPayIcons.appealManager,
                title: context.appStrings!.appealRequests,
                onTap: () => Navigation.navToAppealManagerChat(context),
              ),
            ],
            ListDivider(),
            _listTile(
              context,
              leadingIconSvg: VPayIcons.clock,
              title: context.appStrings!.history,
              onTap: () => Navigation.navToHistory(context),
            ),
            ListDivider(),
            _listTile(
              context,
              leadingIconSvg: VPayIcons.leaveIcon,
              title: context.appStrings!.leaveManagement,
              onTap: () => Navigation.navToLeaveManagement(context, context.read<EmployeeProvider>().employee),
            ),
            ListDivider(),
            _listTile(
              context,
              leadingIconSvg: VPayIcons.purse,
              title: context.appStrings!.payslipManagement,
              onTap: () => Navigation.navToPayslips(context),
            ),
            ListDivider(),
            _listTile(
              context,
              leadingIconSvg: VPayIcons.notesMenu,
              title: context.appStrings!.expenseManagement,
              onTap: () => Navigation.navToExpenseClaimDetails(context, context.read<EmployeeProvider>().employee),
            ),
            ListDivider(),
            _listTile(
              context,
              leadingIconSvg: VPayIcons.manRaisingHandIcon,
              title: context.appStrings!.attendance,
              onTap: () => Navigation.navToAttendance(context),
            ),
            ListDivider(),
            _listTile(
              context,
              leadingIconSvg: VPayIcons.calendar,
              title: context.appStrings!.calender,
              onTap: () => Navigation.navTocalenderPage(context, context.read<EmployeeProvider>().employee),
            ),
            ListDivider(),
            _listTile(
              context,
              leadingIconSvg: VPayIcons.hr,
              title: context.appStrings!.contactHR,
              onTap: () => Navigation.navToContactHR(context),
            ),
            ListDivider(),
          ],
        ),
      ),
    );
  }

  Widget _listTile(BuildContext context, {required String leadingIconSvg, required String title, Function? onTap}) => ListTile(
        leading: SvgPicture.asset(
          leadingIconSvg,
          fit: BoxFit.none,
        ),
        minLeadingWidth: 12,
        title: Text(
          title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        onTap: onTap as void Function()?,
      );
}
