import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/employee_provider.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class ContactsTab extends StatefulWidget {
  const ContactsTab({Key? key}) : super(key: key);

  @override
  _ContactsTabState createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  Employee? _employee;

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<BaseResponse<Employee>>(
      initFuture: () async => context.read<EmployeeProvider>().get(force: true),
      onSuccess: (context, snapshot) {
        _employee = snapshot.data!.result;
        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: CustomElevatedButton(
              text: context.appStrings!.raiseRequest,
              onPressed: () async {
                final contactsResponse = (await showFutureProgressDialog(
                  context: context,
                  initFuture: () => ApiRepo().getEmergencyContacts(
                    context.read<EmployeeProvider>().employee?.id,
                    0,
                    1000,
                  ),
                ))!;
                showContactsRequestBottomSheet(
                  context: context,
                  employee: _employee,
                  emergencyContacts: contactsResponse.result!.records,
                );
              },
            ),
          ),
          body: CustomScrollView(
            key: PageStorageKey<String>("contactsScrollKey"),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    PersonalInfoListTile(
                      leadingIconSvg: VPayIcons.contacts_call,
                      title: context.appStrings!.contactNumber,
                      data: _employee?.contactNumber,
                    ),
                    ListDivider(),
                    PersonalInfoListTile(
                      leadingIconSvg: VPayIcons.contacts_email,
                      title: context.appStrings!.email,
                      data: _employee?.email,
                    ),
                    ListDivider(),
                    PersonalInfoListTile(
                      leadingIconSvg: VPayIcons.contacts_home,
                      title: context.appStrings!.address,
                      data: _employee?.address,
                    ),
                    ListDivider(),
                  ],
                ),
              ),
              CustomPagedSliverListView<EmergencyContact>(
                initPageFuture: (pageKey) async {
                  var emergencyContacts =
                      await ApiRepo().getEmergencyContacts(context.read<EmployeeProvider>().employee?.id, pageKey, 7);
                  return emergencyContacts.result!.toPagedList();
                },
                emptyBuilder: (context) => Container(),
                itemBuilder: (context, item, index) {
                  return PersonalInfoListTile(
                    leadingIconSvg: VPayIcons.contacts_emergency,
                    title: 'Emergency Contacts',
                    child: Column(
                      children: [
                        EmergencyContactListTile(emergencyContact: item),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 70),
              ),
            ],
          ),
        );
      },
    );
  }
}
