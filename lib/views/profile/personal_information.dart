import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class PersonalInformationTab extends StatefulWidget {
  const PersonalInformationTab({Key? key}) : super(key: key);

  @override
  _PersonalInformationTabState createState() => _PersonalInformationTabState();
}

class _PersonalInformationTabState extends State<PersonalInformationTab> {
  Employee? _employee;

  Widget _actionButtons(BuildContext context) {
    var hideTabs = context.read<HomeTabIndexProvider>().hideBarItems!;
    if (hideTabs)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 120,
            child: CustomElevatedButton(
              text: context.appStrings!.update.toUpperCase(),
              textStyle:
                  TextStyle(color: Theme.of(context).colorScheme.secondary),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23)),
                ),
                side: MaterialStateProperty.all(BorderSide(
                    color: Theme.of(context).colorScheme.secondary, width: 1)),
              ),
              onPressed: () => showPersonalInfoRequestBottomSheet(
                  context: context, employee: _employee),
            ),
          ),
          SizedBox(width: 20),
          SizedBox(
            width: 120,
            child: CustomElevatedButton(
              text: context.appStrings!.confirm,
              onPressed: () => _confirmProfile(),
            ),
          ),
        ],
      );
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300),
      child: CustomElevatedButton(
        text: context.appStrings!.raiseRequest,
        onPressed: () => showPersonalInfoRequestBottomSheet(
            context: context, employee: _employee),
      ),
    );
  }

  void _confirmProfile() async {
    var response = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().confirmProfile(_employee!.id),
    ))!;
    if (response.status!) {
      await showCustomModalBottomSheet(
        context: context,
        desc: response.message,
        isDismissible: false,
      );
      context.read<HomeTabIndexProvider>().hideBarItems = false;
      context.read<HomeTabIndexProvider>().index = 2;
    } else {
      await showCustomModalBottomSheet(
        context: context,
        desc: response.message ?? context.appStrings!.errorConfirmingProfile,
        icon: VPayIcons.blockUser,
      );
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _employee = context.watch<EmployeeProvider>().employee;
  // }

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<BaseResponse<Employee>>(
        initFuture: () async =>
            context.read<EmployeeProvider>().get(force: true),
        onSuccess: (context, snapshot) {
          _employee = snapshot.data!.result;
          return Scaffold(
            backgroundColor: Colors.white,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _actionButtons(context),
            body: CustomScrollView(
              key: PageStorageKey<String>("personalInfoScrollKey"),
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      PersonalInfoListTile(
                        leadingIconSvg: VPayIcons.profile_gender,
                        title: context.appStrings!.gender,
                        data: "${_employee?.gender![0].toUpperCase()}${_employee?.gender?.substring(1).toLowerCase()}",
                      ),
                      ListDivider(),
                      PersonalInfoListTile(
                        leadingIconSvg: VPayIcons.profile_cake,
                        title: context.appStrings!.birthdate,
                        data: _employee?.birthDate != null
                            ? dateFormat.format(_employee!.birthDate!)
                            : "",
                      ),
                      ListDivider(),
                      PersonalInfoListTile(
                        leadingIcon: Icon(Icons.menu_book_outlined,
                            size: 18, color: Theme.of(context).primaryColor),
                        title: context.appStrings!.religion,
                        data: "${_employee?.religion![0].toUpperCase()}${_employee?.religion?.substring(1).toLowerCase()}",
                      ),
                      ListDivider(),
                      PersonalInfoListTile(
                        leadingIconSvg: VPayIcons.profile_department,
                        title: context.appStrings!.department,
                        data: _employee?.department?.name,
                      ),
                      ListDivider(),
                      PersonalInfoListTile(
                        leadingIconSvg: VPayIcons.profile_position,
                        title: context.appStrings!.position,
                        data: _employee?.position?.name,
                      ),
                      ListDivider(),
                      PersonalInfoListTile(
                        leadingIcon: Icon(Icons.badge_outlined,
                            size: 18, color: Theme.of(context).primaryColor),
                        title: context.appStrings!.hireDate,
                        data: _employee!.hireDate != null
                            ? dateFormat.format(_employee!.hireDate!)
                            : "",
                      ),
                      ListDivider(),
                      PersonalInfoListTile(
                        leadingIconSvg: VPayIcons.profile_currency,
                        title: context.appStrings!.currency,
                        data: _employee?.currency?.name,
                      ),
                      ListDivider(),
                      PersonalInfoListTile(
                        leadingIconSvg: VPayIcons.profile_manager,
                        title: context.appStrings!.reportingManager,
                        data: _employee?.manager?.fullName,
                      ),
                      SizedBox(height: 70),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
