import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/future_builder.dart';
import 'package:vayroll/widgets/inner_dropdown_form_field.dart';

class ApplyForOthersWidget extends StatefulWidget {
  final String? requestKind;
  final String? kindDisplayName;
  final Employee? employee;
  final Employee? selectEmp;
  final Function(Employee? value)? onChanged;
  final bool? switchValue;
  final Function(bool value)? onSwitchChanged;

  const ApplyForOthersWidget({
    Key? key,
    this.requestKind,
    this.employee,
    this.selectEmp,
    this.onChanged,
    this.switchValue,
    this.onSwitchChanged,
    this.kindDisplayName,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ApplyForOthersWidgetState();
}

class ApplyForOthersWidgetState extends State<ApplyForOthersWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<BaseResponse<List<Employee>>>(
      initFuture: () => ApiRepo()
          .getRequestsubjects(widget.employee?.id, widget.requestKind),
      onSuccess: (context, snapshot) {
        List<Employee>? allEmployes = snapshot.data?.result;
        if (allEmployes == null) allEmployes = [];
        return Visibility(
          visible: allEmployes.isNotEmpty == true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    context.appStrings!.applyForOthers,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontSize: 21),
                  ),
                  Spacer(),
                  CupertinoSwitch(
                    value: widget.switchValue!,
                    activeColor: DefaultThemeColors.softLimeGreen,
                    onChanged: widget.onSwitchChanged,
                  ),
                ],
              ),
              if (widget.switchValue!) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(context.appStrings!.employee,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: DefaultThemeColors.nepal)),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InnerDropdownFormField<Employee>(
                    hint: context.appStrings!.selectEmployee,
                    value: widget.selectEmp,
                    items: allEmployes
                        .map((emp) => DropdownMenuItem<Employee>(
                            value: emp, child: Text(emp.fullName!)))
                        .toList(),
                    onChanged: widget.onChanged,
                    validator: (value) =>
                        value == null ? context.appStrings!.requiredField : null,
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
