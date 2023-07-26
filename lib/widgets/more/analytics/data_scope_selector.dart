import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class DataScopeSelector extends StatefulWidget {
  final Function? selectedOptionCallback;
  final Function? selectedDepartmentCallback;

  DataScopeSelector({Key? key, this.selectedOptionCallback, this.selectedDepartmentCallback}) : super(key: key);

  @override
  _DataScopeSelectorState createState() => _DataScopeSelectorState();
}

class _DataScopeSelectorState extends State<DataScopeSelector> {
  int? _radioOptionsValue = 0;
  List<Department>? _selectedDepartments;
  Employee? _employee;
  final deptAll = Department(id: "0", name: "All Departments");

  @override
  void initState() {
    super.initState();
    _employee = context.read<EmployeeProvider>().employee;
  }

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<BaseResponse<List<Department>>>(
      initFuture: () => _employee!.hasRole(Role.CLevel) || _employee!.hasRole(Role.CanViewAllDepartmentsDetails)
          ? ApiRepo().getDepartments(employeeGroupId: _employee!.employeesGroup!.id, accessible: false)
          : ApiRepo().getDepartments(employeeId: _employee!.id, accessible: true),
      onSuccess: (context, snapshot) {
        var departments = snapshot.data!.result;
        _selectedDepartments ??= departments;

        return departments != null && departments.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio(
                                value: 0,
                                groupValue: _radioOptionsValue,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (dynamic value) {
                                  setState(() {
                                    _radioOptionsValue = value;
                                    _selectedDepartments = [];
                                  });
                                  widget?.selectedOptionCallback?.call(value);
                                },
                              ),
                              Expanded(
                                child: Tooltip(
                                  message: context.appStrings!.directReports,
                                  child: Text(
                                    context.appStrings!.directReports,
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _radioOptionsValue,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (dynamic value) {
                                  setState(() {
                                    _radioOptionsValue = value;
                                    _selectedDepartments = departments;
                                    widget?.selectedDepartmentCallback
                                        ?.call(_selectedDepartments!.map((e) => e.id).toList());

                                    context.read<KeyProvider>().contactsCharts!.currentState!.refresh();
                                    context.read<KeyProvider>().experneceCharts!.currentState!.refresh();
                                    context.read<KeyProvider>().posisionCharts!.currentState!.refresh();
                                  });
                                  widget?.selectedOptionCallback?.call(value);
                                },
                              ),
                              Expanded(
                                child: Tooltip(
                                  message: context.appStrings!.department,
                                  child: Text(
                                    context.appStrings!.department,
                                    style: Theme.of(context).textTheme.bodyText1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                      ],
                    ),
                    if (_radioOptionsValue == 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: InnerDropdownFormField<Department>(
                          hint: context.appStrings!.departmentName,
                          value: _selectedDepartments!.length == 1 ? _selectedDepartments!.first : deptAll,
                          items: [
                            if (departments.length > 1)
                              DropdownMenuItem<Department>(value: deptAll, child: Text(deptAll.name!)),
                            for (final dept in departments)
                              DropdownMenuItem<Department>(value: dept, child: Text(dept.name!)),
                          ],
                          onChanged: (dept) {
                            setState(() {
                              if (dept == deptAll) {
                                _selectedDepartments = departments;
                              } else {
                                _selectedDepartments = [dept!];
                              }
                            });
                            widget?.selectedDepartmentCallback?.call(_selectedDepartments!.map((e) => e.id).toList());
                          },
                          validator: (value) => value == null ? context.appStrings!.requiredField : null,
                        ),
                      ),
                  ],
                ),
              )
            : Container();
      },
    );
  }
}
