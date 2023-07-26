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

class DepartmentEmployeesPage extends StatefulWidget {
  const DepartmentEmployeesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DepartmentEmployeesPageState();
}

class DepartmentEmployeesPageState extends State<DepartmentEmployeesPage> {
  final TextEditingController _controller = new TextEditingController();
  final _refreshableKey = GlobalKey<RefreshableState>();

  String? searchEmpName;

  int? employeeLength;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke3,
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: DefaultThemeColors.whiteSmoke3,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _header(),
          Expanded(child: _empList()),
        ],
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
          Text(
            context.read<EmployeeProvider>().employee!.department!.name ?? "",
            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
          ),
        ],
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
                controller: _controller,
                hintText: context.appStrings!.searchByEmployeeName,
                textStyle: Theme.of(context).textTheme.bodyText2,
                onSaved: (String? value) => searchEmpName = value?.trim() ??"",
                onChanged: (value) {
                  searchEmpName = value;
                  _refreshableKey.currentState!.refresh();
                },
              ),
            ),
            SizedBox(width: 8),
            InkWell(
                onTap: () => setState(() {
                      _controller.clear();
                      searchEmpName = null;
                      _refreshableKey.currentState!.refresh();
                    }),
                child: SvgPicture.asset(VPayIcons.close)),
          ],
        ),
      ),
    );
  }

  Widget _empList() {
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
              key: _refreshableKey,
              child: Padding(
                padding: EdgeInsets.only(left: 8, bottom: 12, right: 8),
                child: CustomPagedListView<Employee>(
                  initPageFuture: (pageKey) async {
                    var departmentDetailsResponse = await ApiRepo().getDepartmentEmployess(
                      context.read<EmployeeProvider>().employee?.department?.id,
                      context.read<EmployeeProvider>().employee?.employeesGroup?.id,
                      context.read<EmployeeProvider>().employee?.id,
                      pageIndex: pageKey,
                      pageSize: pageSize,
                    );
                    employeeLength = (employeeLength ?? 0) + (departmentDetailsResponse.result?.records?.length ?? 0);
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
        ],
      ),
    );
  }

  Widget empCard(Employee? empInfo) {
    return InkWell(
      onTap: () => Navigation.navToViewProfilePage(context, empInfo, false,
          departments: context.read<EmployeeProvider>().employee?.department),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  empInfo?.fullName ?? "",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
                Text(
                  empInfo?.position?.name ?? "",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14, color: DefaultThemeColors.nepal),
                ),
              ],
            ),
            Spacer(),
            Row(
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
          ],
        ),
      ),
    );
  }
}
