import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/department/department_home_card.dart';
import 'package:vayroll/widgets/future_builder.dart';
import 'package:vayroll/widgets/widgets.dart';

class DepartmentHomeWidget extends StatefulWidget {
  final String? employeeId;

  const DepartmentHomeWidget({Key? key, this.employeeId}) : super(key: key);

  @override
  _DepartmentHomeWidgetState createState() => _DepartmentHomeWidgetState();
}

class _DepartmentHomeWidgetState extends State<DepartmentHomeWidget> {
  late bool canViewDepartmentAttendance;
  late bool canViewAllDepartmentsAttendance;
  String? employeesGroupId;
  String? employeesId;
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    employeesId = context.read<EmployeeProvider>().employee!.id;
    employeesGroupId = context.read<EmployeeProvider>().employee!.employeesGroup!.id;
    canViewDepartmentAttendance = context.read<EmployeeProvider>().employee!.hasRole(Role.CanViewDepartmentAttendance);
    canViewAllDepartmentsAttendance =
        context.read<EmployeeProvider>().employee!.hasRole(Role.CanViewAllDepartmentsAttendance);
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewDepartmentAttendance && !canViewAllDepartmentsAttendance) {
      return Container();
    } else {
      return CustomFutureBuilder<BaseResponse<List<Department>>>(
        initFuture: () {
          if (canViewAllDepartmentsAttendance) {
            return ApiRepo().getDepartments(
              employeeGroupId: employeesGroupId,
              employeeId: employeesId,
            );
          } else {
            return ApiRepo().getDepartments(
              employeeGroupId: employeesGroupId,
              employeeId: employeesId,
              accessible: true,
            );
          }
        },
        onSuccess: (context, snapshot) {
          var departmentsAttendance = snapshot.data!.result;
          if (departmentsAttendance == null) departmentsAttendance = [];
          return Container(
            color: DefaultThemeColors.whiteSmoke2,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        context.appStrings!.departmentAttendance,
                        style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 22),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (canViewAllDepartmentsAttendance) {
                            Navigation.navToDepartment(context, departmentsAttendance, null, employeesGroupId);
                          } else {
                            Navigation.navToDepartment(context, departmentsAttendance, widget.employeeId, null);
                          }
                        },
                        child: Text(
                          context.appStrings!.viewAll,
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                if (departmentsAttendance.isEmpty)
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      context.appStrings!.thereIsNoDepartmentForYouNow,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                if (departmentsAttendance?.isNotEmpty == true) ...[
                  departmentsAttendance.length >= 2
                      ? ListView.builder(
                          itemCount: 2,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CustomFutureBuilder<BaseResponse<DepartmentAttendanceResponse>>(
                              initFuture: () async => await ApiRepo().getDepartmentAttendanceSummary(
                                employeesId,
                                date,
                                departmentsAttendance![index].id,
                              ),
                              onSuccess: (context, snapshot) {
                                DepartmentAttendanceResponse? departmentAttendance = snapshot.data!.result;
                                return DepartmentHomeCard(
                                  departmentAttendanceResponse: departmentAttendance,
                                  department: departmentsAttendance![index].name,
                                );
                              },
                            );
                          },
                        )
                      : CustomFutureBuilder<BaseResponse<DepartmentAttendanceResponse>>(
                          initFuture: () async => await ApiRepo().getDepartmentAttendanceSummary(
                            employeesId,
                            date,
                            departmentsAttendance![0].id,
                          ),
                          onSuccess: (context, snapshot) {
                            DepartmentAttendanceResponse? departmentAttendance = snapshot.data!.result;
                            return DepartmentHomeCard(
                              departmentAttendanceResponse: departmentAttendance,
                              department: departmentsAttendance![0].name,
                            );
                          },
                        ),
                ]
              ],
            ),
          );
        },
      );
    }
  }
}
