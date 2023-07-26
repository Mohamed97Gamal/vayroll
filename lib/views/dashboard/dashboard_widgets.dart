import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/utils/utils.dart';

class DashboardWidgetsPage extends StatefulWidget {
  @override
  _DashboardWidgetsPageState createState() => _DashboardWidgetsPageState();
}

class _DashboardWidgetsPageState extends State<DashboardWidgetsPage> {
  late bool canViewDepartmentAttendance;
  late bool canViewAllDepartmentsAttendance;
  List<DashboardWidget>? _widgets;

  @override
  void initState() {
    super.initState();
    _widgets = context.read<DashboardWidgetsProvider>().getCopy();
    canViewDepartmentAttendance = context.read<EmployeeProvider>().employee!.hasRole(Role.CanViewDepartmentAttendance);
    canViewAllDepartmentsAttendance =
        context.read<EmployeeProvider>().employee!.hasRole(Role.CanViewAllDepartmentsAttendance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke2,
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: Column(
        children: [_header(context), _list(context)],
      ),
    );
  }

  Widget _header(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleStacked(context.appStrings!.dashboardWidgets, DefaultThemeColors.prussianBlue),
              SizedBox(height: 16),
              Text(
                context.appStrings!.youCanShowOrHideMoveYourDashboardWidgetsAccordingToEaseOfUse,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
  );

  Widget _list(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 8),
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    var item = _widgets!.removeAt(oldIndex);
                    _widgets!.insert(newIndex, item);
                  });
                },
                children: [
                  for (DashboardWidget widget in _widgets!)
                    widget.name == WidgetName.department && !canViewDepartmentAttendance && !canViewAllDepartmentsAttendance
                        ? Container(key: ValueKey(widget))
                        : ListTile(
                            key: ValueKey(widget),
                            title: Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(VPayIcons.drag, fit: BoxFit.none),
                                    SizedBox(width: 12),
                                    Text(
                                      widget.title!,
                                      style: Theme.of(context).textTheme.subtitle1,
                                    ),
                                    Spacer(),
                                    CupertinoSwitch(
                                      value: widget.active!,
                                      onChanged: (value) {
                                        var calWidget = _widgets!.firstWhereOrNull(
                                            (element) => element.name == WidgetName.calendar);
                                        if ((widget.name == WidgetName.weeklyAttendance ||
                                                widget.name == WidgetName.birthdays) &&
                                            !calWidget!.active!) return;
                                        setState(() {
                                          widget.active = value;
                                          if (widget.name == WidgetName.calendar) {
                                            var wIndex = _widgets!
                                                .indexWhere((element) => element.name == WidgetName.weeklyAttendance);
                                            var bIndex =
                                                _widgets!.indexWhere((element) => element.name == WidgetName.birthdays);
                                            _widgets![wIndex].active = value;
                                            _widgets![bIndex].active = value;
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Divider(color: DefaultThemeColors.whiteSmoke1),
                              ],
                            ),
                          ),
                ],
              ),
            ),
            _footer(context),
          ],
        ),
      ),
    );
  }

  Widget _footer(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: CustomElevatedButton(
          text: context.appStrings!.save,
          onPressed: () async{
            context.read<DashboardWidgetsProvider>().widgets = _widgets!.toList();
            await showCustomModalBottomSheet(
                context: context,
                desc: context.appStrings!.widgetsSavedSuccessfully,
                isDismissible: true,
                );
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      );
}
