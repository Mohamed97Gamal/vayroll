import 'dart:convert';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/repo/disk/disk_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class OrganizationChartPage extends StatefulWidget {
  const OrganizationChartPage({Key? key}) : super(key: key);

  @override
  _OrganizationChartPageState createState() => _OrganizationChartPageState();
}

class _OrganizationChartPageState extends State<OrganizationChartPage> {
  GlobalKey _showcaseKey = GlobalKey();
  ChartEmployee? _chart;
  bool _showRootSubs = false, _canViewOrg = false;
  String? _employeesGroupId, _organizationId;
  Employee? _employee;

  _showCaseIfNotDisplayed(BuildContext buildContext) async {
    var displayed = await DiskRepo().getOrgChartShowcaseDisplayed();
    print(displayed);
    if (!displayed)
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          Future.delayed(Duration(seconds: 1), () => ShowCaseWidget.of(buildContext).startShowCase([_showcaseKey])));
  }

  @override
  void initState() {
    super.initState();
    _employee = context.read<EmployeeProvider>().employee;
    _canViewOrg = _employee!.hasRole(Role.CanViewOrgHierarchy);
    _employeesGroupId = _canViewOrg ? null : _employee!.employeesGroup!.id;
    _organizationId = _canViewOrg ? _employee!.employeesGroup!.organization?.id : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: ShowCaseWidget(
        onFinish: () {
          DiskRepo().saveOrgChartShowcaseDisplayed(true);
        },
        builder: Builder(
          builder: (context) {
            _showCaseIfNotDisplayed(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_header(context), _chartList(context)],
            );
          },
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: TitleStacked(
          _canViewOrg ? context.appStrings!.organizationHierarchy : context.appStrings!.companyHierarchy,
          DefaultThemeColors.prussianBlue),
    );
  }

  Widget _chartList(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 32),
              CustomFutureBuilder<BaseResponse<ChartEmployee>>(
                initFuture: () => ApiRepo().getEmployeeGroupChart(_employeesGroupId, _organizationId),
                onSuccess: (context, snapshot) {
                  _chart = snapshot.data!.result;
                  return Showcase(
                    key: _showcaseKey,
                    description: context.appStrings!.tapToBrowseTheHierarchy,
                    descTextStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                    tooltipBackgroundColor: Theme.of(context).colorScheme.secondary,
                    disposeOnTap: true,
                    onTargetClick: () {
                      DiskRepo().saveOrgChartShowcaseDisplayed(true);
                      setState(() => _showRootSubs = true);
                    },
                    onToolTipClick: () => DiskRepo().saveOrgChartShowcaseDisplayed(true),
                    child: _rootWidget(chart: _chart),
                  );
                },
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rootWidget({required ChartEmployee? chart}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmployeeListTile(
          employee: chart,
          onTap: () => setState(() => _showRootSubs = !_showRootSubs),
          isRoot: true,
        ),
        if (_showRootSubs && chart!.subs != null && chart.subs!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 42.0),
            child: DottedLine(
              direction: Axis.vertical,
              lineLength: 60,
              lineThickness: 2.0,
              dashLength: 2.0,
              dashColor: DefaultThemeColors.nepal,
              dashRadius: 1.0,
              dashGapLength: 2.0,
            ),
          ),
          chart.subs!.length == 1
              ? SingleEmployee(key: ObjectKey(chart.subs![0]), employee: chart.subs![0])
              : MultipleEmployees(key: ValueKey('${chart.id}_subs'), employees: chart.subs),
        ],
      ],
    );
  }
}

class SingleEmployee extends StatefulWidget {
  final ChartEmployee employee;
  SingleEmployee({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  _SingleEmployeeState createState() => _SingleEmployeeState();
}

class _SingleEmployeeState extends State<SingleEmployee> {
  bool showSubs = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmployeeListTile(
          employee: widget.employee,
          onTap: () {
            if (widget.employee.subs != null && widget.employee.subs!.isNotEmpty) setState(() => showSubs = !showSubs);
          },
        ),
        if (showSubs && widget.employee.subs != null && widget.employee.subs!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 42.0),
            child: DottedLine(
              direction: Axis.vertical,
              lineLength: 60,
              lineThickness: 2.0,
              dashLength: 2.0,
              dashColor: DefaultThemeColors.nepal,
              dashRadius: 1.0,
              dashGapLength: 2.0,
            ),
          ),
          widget.employee.subs!.length == 1
              ? SingleEmployee(key: ObjectKey(widget.employee.subs![0]), employee: widget.employee.subs![0])
              : MultipleEmployees(key: ValueKey('${widget.employee.id}_subs'), employees: widget.employee.subs),
        ],
      ],
    );
  }
}

class MultipleEmployees extends StatefulWidget {
  final List<ChartEmployee>? employees;
  MultipleEmployees({
    Key? key,
    required this.employees,
  }) : super(key: key);
  @override
  _MultipleEmployeesState createState() => _MultipleEmployeesState();
}

class _MultipleEmployeesState extends State<MultipleEmployees> {
  ChartEmployee? _selectedEmployee;
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !expanded
            ? Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: InkWell(
                  onTap: () => setState(() => expanded = true),
                  child: Row(
                    children: [
                      RowSuper(
                        innerDistance: -27,
                        children: [
                          for (var employee in widget.employees!.take(3)) EmployeeAvatar(employee: employee),
                        ],
                      ),
                      if (widget.employees!.length > 3) ...[
                        SizedBox(width: 12),
                        Row(
                          children: [
                            widget.employees!.firstWhereOrNull((e) => e.isMe(context)) != null
                                ? RichText(
                                    text: TextSpan(
                                      text: "${context.appStrings!.you} ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(color: DefaultThemeColors.mayaBlue),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: widget.employees![0].type == "EMPLOYEE"
                                              ? "+${widget.employees!.length - 1} ${context.appStrings!.people}"
                                              : widget.employees![0].type == "ENTITY"
                                                  ? "+${widget.employees!.length - 1} ${context.appStrings!.entities}"
                                                  : "+${widget.employees!.length - 1} ${context.appStrings!.organizations}",
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(
                                    widget.employees![0].type == "EMPLOYEE"
                                        ? "+${widget.employees!.length - 1} ${context.appStrings!.people}"
                                        : widget.employees![0].type == "ENTITY"
                                            ? "+${widget.employees!.length - 1} ${context.appStrings!.entities}"
                                            : "+${widget.employees!.length - 1} ${context.appStrings!.organizations}",
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        )
                      ]
                    ],
                  ),
                ),
              )
            : Container(
                height: 280,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    const BoxShadow(
                      color: DefaultThemeColors.gainsboro,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      spreadRadius: 0,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => setState(() => expanded = false),
                      child: Row(
                        children: [
                          Text(
                            widget.employees![0].type == "EMPLOYEE"
                                ? "+${widget.employees!.length - 1} ${context.appStrings!.people}"
                                : widget.employees![0].type == "ENTITY"
                                    ? "+${widget.employees!.length - 1} ${context.appStrings!.entities}"
                                    : "+${widget.employees!.length - 1} ${context.appStrings!.organizations}",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Icon(Icons.keyboard_arrow_up),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: widget.employees!.length,
                        separatorBuilder: (context, i) => SizedBox(height: 16),
                        itemBuilder: (context, i) {
                          return EmployeeListTile(
                            isSelected: _selectedEmployee == widget.employees![i],
                            employee: widget.employees![i],
                            padding: EdgeInsets.zero,
                            onTap: () => setState(() {
                              _selectedEmployee = widget.employees![i];
                              if (_selectedEmployee!.subs != null && _selectedEmployee!.subs!.isNotEmpty) {
                                var removedEmp = widget.employees!.removeAt(i);
                                widget.employees!.add(removedEmp);
                              }
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
        if (_selectedEmployee?.subs != null && _selectedEmployee!.subs!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 42.0),
            child: DottedLine(
              direction: Axis.vertical,
              lineLength: 60,
              lineThickness: 2.0,
              dashLength: 2.0,
              dashColor: expanded ? Theme.of(context).colorScheme.secondary : DefaultThemeColors.nepal,
              dashRadius: 1.0,
              dashGapLength: 2.0,
            ),
          ),
          _selectedEmployee!.subs!.length == 1
              ? SingleEmployee(key: ObjectKey(_selectedEmployee!.subs![0]), employee: _selectedEmployee!.subs![0])
              : MultipleEmployees(key: ValueKey('${_selectedEmployee!.id}_subs'), employees: _selectedEmployee!.subs),
        ],
      ],
    );
  }
}

class EmployeeListTile extends StatelessWidget {
  final ChartEmployee? employee;
  final EdgeInsetsGeometry? padding;
  final Function? onTap;
  final bool isSelected;
  final bool isRoot;
  const EmployeeListTile(
      {Key? key, this.employee, this.padding, this.onTap, this.isSelected = false, this.isRoot = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: padding,
      leading: EmployeeAvatar(employee: employee, isSelected: isSelected, isRoot: isRoot),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          employee!.isMe(context)
              ? Text(
                  "${context.appStrings!.you}",
                  style: !(employee!.isServiceEnded ?? false)
                      ? Theme.of(context).textTheme.subtitle1!.copyWith(color: DefaultThemeColors.mayaBlue)
                      : Theme.of(context).textTheme.subtitle1!.copyWith(color: DefaultThemeColors.gainsboro),
                )
              : Text(
                  employee!.fullName ?? "",
                  style: !(employee!.isServiceEnded ?? false)
                      ? Theme.of(context).textTheme.subtitle1
                      : Theme.of(context).textTheme.subtitle1!.copyWith(color: DefaultThemeColors.gainsboro),
                ),
          if (employee?.position?.name != null)
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
              child: AutoSizeText.rich(
                TextSpan(
                  children: [
                    TextSpan(text: employee!.position!.name),
                    TextSpan(
                      text: employee!.externalEntity != null ? " (${employee!.externalEntity!.fullName})" : "",
                      style: TextStyle(
                        color: !(employee!.isServiceEnded ?? false)
                            ? Theme.of(context).colorScheme.secondary
                            : DefaultThemeColors.gainsboro,
                      ),
                    ),
                  ],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    fontFamily: Fonts.brandon,
                    color:
                        !(employee!.isServiceEnded ?? false) ? DefaultThemeColors.nepal : DefaultThemeColors.gainsboro,
                  ),
                ),
                maxLines: 1,
              ),
            )
        ],
      ),
      onTap: onTap as void Function()?,
    );
  }
}

class EmployeeAvatar extends StatelessWidget {
  final ChartEmployee? employee;
  final bool isSelected;
  final bool isRoot;
  const EmployeeAvatar({Key? key, this.employee, this.isSelected = false, this.isRoot = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: 54,
      padding: isSelected || isRoot || employee!.isMe(context) ? EdgeInsets.all(2) : null,
      decoration: isSelected || isRoot || employee!.isMe(context)
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : employee!.isMe(context)
                          ? DefaultThemeColors.mayaBlue
                          : Theme.of(context).primaryColor),
            )
          : null,
      child: employee!.photo == null
          ? CircleAvatar(
              radius: 27,
              backgroundColor: Colors.transparent,
              backgroundImage: isRoot ? null : AssetImage(VPayImages.avatar),
              child: isRoot ? Icon(Icons.business, size: 32, color: Colors.black) : null,
            )
          : AvatarFutureBuilder<BaseResponse<String>>(
              initFuture: () => ApiRepo().getFile(employee!.photo!.id),
              onSuccess: (context, photoSnapshot) {
                String photoBase64 = photoSnapshot.data!.result!;
                return CircleAvatar(
                  radius: 27,
                  backgroundColor: Colors.transparent,
                  backgroundImage: MemoryImage(base64Decode(photoBase64)),
                );
              },
            ),
    );
  }
}
