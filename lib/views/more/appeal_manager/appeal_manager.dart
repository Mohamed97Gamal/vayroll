import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/common.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/widgets/widgets.dart';

class EmployeeWithImage {
  final EmployeeInfo? employee;
  final Uint8List? image;

  EmployeeWithImage(this.employee, this.image);
}

class AppealManagerPage extends StatefulWidget {
  final int tabIndex;

  const AppealManagerPage({Key? key, this.tabIndex = 0}) : super(key: key);

  @override
  State<AppealManagerPage> createState() => _AppealManagerPageState();
}

class _AppealManagerPageState extends State<AppealManagerPage> with SingleTickerProviderStateMixin {
  var lock = new Lock();
  HashMap<String?, EmployeeWithImage> employeeCache = new HashMap();

  TabController? _tabController;

  int? appealRequestsLength;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.tabIndex != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tabController!.animateTo(widget.tabIndex));
    }
    Future.microtask(() => context.read<HomeTabIndexProvider>().appealManagerIcon = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: DefaultThemeColors.whiteSmoke2,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _header(context),
          _list(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: TitleStacked(context.appStrings!.appealRequests, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _list(BuildContext context) {
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
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: context.appStrings!.leave),
                  Tab(text: context.appStrings!.expense),
                  Tab(text: context.appStrings!.payslips),
                ],
                indicatorColor: Theme.of(context).colorScheme.secondary,
                indicatorWeight: 3,
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
                    _appealManagerBody(RequestCategory.leave),
                    _appealManagerBody(RequestCategory.expenseClaim),
                    _appealManagerBody(RequestCategory.payroll)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _appealManagerBody(String category) {
    return CustomPagedListView<Appeal>(
      initPageFuture: (pageKey) async {
        var appealResponse = await ApiRepo().getAppealRequests(
          pageSize: pageSize,
          pageIndex: pageKey,
          submitter: false,
          category: category,
        );
        appealRequestsLength = (appealRequestsLength ?? 0) + (appealResponse.result?.records?.length ?? 0);
        return appealResponse.result!.toPagedList();
      },
      itemBuilder: (context, item, index) {
        if (employeeCache.containsKey(item.submitterId)) {
          return _appealItem(context, item, employeeCache[item.submitterId]!, index);
        }
        return CustomFutureBuilder<EmployeeWithImage?>(
          initFuture: () async {
            return await lock.synchronized(() async {
              if (employeeCache.containsKey(item.submitterId)) {
                return employeeCache[item.submitterId];
              }

              var employeeInfo = await ApiRepo().getEmployeeInfo(userId: item.submitterId);
              String? image;
              if (employeeInfo.result!.photo != null && employeeInfo.result!.photo!.id != null) {
                image = (await ApiRepo().getFile(employeeInfo.result?.photo?.id)).result;
              }
              var ewi = EmployeeWithImage(
                employeeInfo.result,
                image == null ? null : base64Decode(image),
              );
              employeeCache.putIfAbsent(item.submitterId, () => ewi);
              return ewi;
            });
          },
          onSuccess: (context, employeeSnapshot) {
            var employeeWithImage = employeeSnapshot.data!;
            return _appealItem(context, item, employeeWithImage, index);
          },
        );
      },
    );
  }

  Column _appealItem(
    BuildContext context,
    Appeal item,
    EmployeeWithImage employeeWithImage,
    int index,
  ) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigation.navToAppealRequestDetails(
            context,
            item.id,
            employee: employeeWithImage.employee,
            lock: lock,
            employeeCache: employeeCache,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                empImage(employeeWithImage.image),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              employeeWithImage.employee?.fullName ?? "",
                              style: Theme.of(context).textTheme.bodyText1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.categoryDisplayName ?? "",
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              item.entityReferenceNumber ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontSize: 14, color: DefaultThemeColors.nepal),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: Text(
                              dateFormat.format(item.submissionDate!) ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontSize: 14, color: DefaultThemeColors.nepal),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (appealRequestsLength != index + 1)
          Divider(
            height: 10,
            thickness: 1,
            indent: 20,
            color: DefaultThemeColors.whiteSmoke1,
          ),
      ],
    );
  }

  Widget empImage(Uint8List? bytes) {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: new Border.all(
          color: Colors.white,
          width: 2.0,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: (bytes != null ? MemoryImage(bytes) : AssetImage(VPayImages.avatar)) as ImageProvider<Object>?,
      ),
    );
  }
}
