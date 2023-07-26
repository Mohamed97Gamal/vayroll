import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/common.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class DucomentsPage extends StatefulWidget {
  const DucomentsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DucomentsPageState();
}

class DucomentsPageState extends State<DucomentsPage> {
  late bool canViewDepartmentsDetails;
  late bool canViewAllDepartmentsDetails;
  late bool cLevel;

  @override
  void initState() {
    super.initState();
    canViewDepartmentsDetails = context.read<EmployeeProvider>().employee!.hasRole(Role.CanViewDepartmentsDetails);
    canViewAllDepartmentsDetails = context.read<EmployeeProvider>().employee!.hasRole(Role.CanViewAllDepartmentsDetails);
    cLevel = context.read<EmployeeProvider>().employee!.hasRole(Role.CLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: canViewDepartmentsDetails || (canViewAllDepartmentsDetails || cLevel)
          ? CustomFutureBuilder<BaseResponse<List<Department>>>(
              initFuture: () => cLevel || canViewAllDepartmentsDetails
                  ? ApiRepo().getDepartments(
                      employeeGroupId: context.read<EmployeeProvider>().employee!.employeesGroup!.id, accessible: false)
                  : ApiRepo()
                      .getDepartments(employeeId: context.read<EmployeeProvider>().employee!.id, accessible: true),
              onSuccess: (context, snapshot) {
                List<Department> departmentEmployees = snapshot.data!.result!;
                List<String?> departmentIds = [];
                List<String?> departmentNames = [];

                departmentEmployees.forEach((department) {
                  departmentIds.add(department.id);
                  departmentNames.add(department.name);
                });
                return DucomentsPageContent(
                  departmentsTabs: departmentIds.length,
                  departmentsId: departmentIds,
                  departmentsNames: departmentNames,
                  companyName: context.appStrings!.company,
                );
              },
            )
          : DucomentsPageContent(
              departmentsTabs: 1,
              departmentsId: [context.read<EmployeeProvider>().employee!.department!.id],
              departmentsNames: [context.read<EmployeeProvider>().employee!.department!.name],
              companyName: context.appStrings!.company,
            ),
    );
  }
}

class DucomentsPageContent extends StatefulWidget {
  final int? departmentsTabs;
  final List<String?>? departmentsId;
  final List<String?>? departmentsNames;
  final String? companyName;

  const DucomentsPageContent(
      {Key? key, this.departmentsTabs, this.departmentsId, this.departmentsNames, this.companyName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DucomentsPageContentState();
}

class DucomentsPageContentState extends State<DucomentsPageContent> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String?>? departmentsId;
  List<String?>? departmentsNames;

  int ducomentLength = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.departmentsTabs! + 1, vsync: this);
    departmentsId = widget.departmentsId;
    departmentsNames = widget.departmentsNames;
    departmentsNames!.insert(0, widget?.companyName);
    departmentsId!.insert(0, "0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke3,
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: DefaultThemeColors.whiteSmoke3,
        elevation: 0,
        actions: [
          if (context.read<EmployeeProvider>().employee!.hasRole(Role.CanUploadDocument) ||
              context.read<EmployeeProvider>().employee!.hasRole(Role.CLevel))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: InkWell(
                onTap: () => Navigation.navToDocumentRequestsPage(context),
                child: Row(
                  children: [
                    Text(context.appStrings!.requests,
                        style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 12)),
                    SizedBox(width: 12),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: SvgPicture.asset(VPayIcons.document),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _header(),
          _list(),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: TitleStacked(context.appStrings!.documents, Theme.of(context).primaryColor),
    );
  }

  Widget _list() {
    var _width = MediaQuery.of(context).size.width;

    return Expanded(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  for (var item in departmentsNames!) Tab(text: item),
                ],
                indicatorColor: Theme.of(context).colorScheme.secondary,
                indicatorWeight: 3,
                isScrollable: true,
                labelColor: Theme.of(context).colorScheme.secondary,
                unselectedLabelColor: Theme.of(context).primaryColor,
                labelStyle: _width > 320
                    ? Theme.of(context).textTheme.subtitle1
                    : Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16),
              ),
              Divider(height: 1, thickness: 1, color: DefaultThemeColors.whiteSmoke1),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    for (int i = 0; i < departmentsId!.length; i++)
                      _ducomentList(
                        employeesGroupId: context.read<EmployeeProvider>().employee!.employeesGroup!.id,
                        departmentId: departmentsId![i] == "0" ? null : departmentsId![i],
                      ),
                  ],
                ),
              ),
              if (context.read<EmployeeProvider>().employee!.hasRole(Role.CanUploadDocument) ||
                  context.read<EmployeeProvider>().employee!.hasRole(Role.CLevel))
                _footer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ducomentList({String? departmentId, String? employeesGroupId, bool showDepartment = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: CustomPagedListView<Document>(
        initPageFuture: (pageKey) async {
          var documentsResponse = await ApiRepo().getCompanydocuments(
            employeesGroupId: employeesGroupId?.isNotEmpty == true ? employeesGroupId : null,
            departmentId: departmentId,
            pageIndex: pageKey,
            pageSize: pageSize,
          );
          ducomentLength = (ducomentLength ?? 0) + (documentsResponse?.result?.records?.length ?? 0);
          return documentsResponse.result!.toPagedList();
        },
        itemBuilder: (context, item, index) {
          return Column(
            children: [
              decomentCard(item, showDepartment: showDepartment),
              if (ducomentLength != index + 1)
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
    );
  }

  Widget decomentCard(Document? document, {bool showDepartment = false}) {
    return ListTile(
      onTap: () async {
        if (imageExtensions.contains(document?.attachment?.extension) || document?.attachment?.extension == 'pdf') {
          Navigation.navToViewCertificate(context, document?.attachment);
          return;
        } else if (fileExtensions.contains(document?.attachment?.extension)) {
          var response = (await showFutureProgressDialog<BaseResponse<String>>(
            context: context,
            initFuture: () => ApiRepo().getFile(document?.attachment?.id),
          ))!;
          if (response.status!) {
            final String dir = (await getApplicationDocumentsDirectory()).path;
            final String path = '$dir/${document?.attachment?.name}';
            final File file = File(path);
            file.writeAsBytesSync(base64Decode(response.result!));
            OpenFile.open("$path").then((value) {
              if (value.type == ResultType.noAppToOpen)
                setState(() async {
                  await showCustomModalBottomSheet(
                    context: context,
                    desc: value.message.substring(0, value.message.length - 1),
                  );
                });
            });
          } else {
            await showCustomModalBottomSheet(
              context: context,
              desc: response.message,
            );
            return;
          }
        } else {
          Navigation.navToViewCertificate(context, document!.attachment);
        }
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: SvgPicture.asset(getDecomentIcon(document?.attachment?.extension?.toLowerCase())),
      ),
      title: Text(
        document?.name ?? "",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.normal,
            ),
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: CustomElevatedButton(
        textAlign: TextAlign.center,
        text: context.appStrings!.raiseARequestForDocument.toUpperCase(),
        onPressed: () => Navigation.navToSubmetRequest(
          context,
          RequestKind.ducoment,
          context.appStrings!.requestForDocument,
        ),
      ),
    );
  }
}
