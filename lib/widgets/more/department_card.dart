import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class DepartmentCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext? context) {
    return CustomFutureBuilder<BaseResponse<DeaprtmentDetailsResponse>>(
      initFuture: () => ApiRepo().getDepartmentEmployess(
        context?.read<EmployeeProvider>().employee?.department?.id,
        context?.read<EmployeeProvider>().employee?.employeesGroup?.id,
        context?.read<EmployeeProvider>().employee?.id,
        pageIndex: 0,
        pageSize: 6,
      ),
      onSuccess: (context, snapshot) {
        List<Employee>? departmentEmployee = snapshot.data!.result!.records;
        if (departmentEmployee == null || departmentEmployee.isEmpty) departmentEmployee = [];

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: Text(
                      context.appStrings!.department,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (!context.read<EmployeeProvider>().employee!.hasRole(Role.CanViewDepartmentsDetails) &&
                          !context.read<EmployeeProvider>().employee!.hasRole(Role.CanViewAllDepartmentsDetails)) {
                        Navigation.navToDepartmentEmployees(context);
                      } else {
                        Navigation.navToDepartmentEmployess(context);
                      }
                    },
                    child: Text(
                      context.appStrings!.viewAll,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Theme.of(context).colorScheme.secondary),
                    ),
                  )
                ],
              ),
              SizedBox(height: 4),
              Text(
                context?.read<EmployeeProvider>().employee?.department?.name ?? "",
                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
              ),
              SizedBox(height: 12),
              departmentEmployee == null || departmentEmployee.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(11)),
                        color: Colors.white,
                      ),
                      child: Text(
                        context.appStrings!.thereIsNoEmployeesForYouNow,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    )
                  : Container(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: departmentEmployee.length > 6 ? 6 : departmentEmployee.length,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return DepartmentEmpCradWidget(empInfo: departmentEmployee![index]);
                        },
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
