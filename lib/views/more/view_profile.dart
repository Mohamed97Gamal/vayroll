import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class ViewProfilePage extends StatefulWidget {
  final Employee? employee;
  final bool? approverOrManager;
  final Department? departments;

  ViewProfilePage(
      {Key? key, this.employee, this.approverOrManager, this.departments})
      : super(key: key);

  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool manager = false;

  int? requestsLength;

  @override
  void initState() {
    super.initState();
    manager = context?.read<EmployeeProvider>().employee?.id ==
        widget?.departments?.manager?.id;
    print(widget?.departments?.manager?.name ?? "w7w7");
    // manager = widget?.employee?.manager?.id == context?.read<EmployeeProvider>()?.employee?.id;
    _tabController = TabController(length: manager ? 2 : 1, vsync: this);
  }

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
          Center(
            child: Column(
              children: [
                widget?.employee?.photo?.id?.isNotEmpty == true
                    ? AvatarFutureBuilder<BaseResponse<String>>(
                        initFuture: () async =>
                            ApiRepo().getFile(widget?.employee?.photo?.id),
                        onSuccess: (context, snapshot) {
                          String? _photo = snapshot?.data?.result;
                          return _profilePhoto(_photo);
                        },
                      )
                    : _profilePhoto(widget?.employee?.photo?.id),
                SizedBox(height: 8),
                Text(
                  widget?.employee?.fullName ?? "",
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget?.employee?.position?.name ?? "",
                  style: Theme.of(context).textTheme.bodyText2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          _list(context),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: TitleStacked(context.appStrings!.viewEmployeeProfile,
          Theme.of(context).primaryColor),
    );
  }

  Widget _profilePhoto(String? photo) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 52,
      child: ClipOval(
        child: photo != null
            ? Image.memory(
                base64Decode(photo),
                fit: BoxFit.cover,
                width: 104.0,
                height: 104.0,
              )
            : Image.asset(
                VPayImages.avatar,
                fit: BoxFit.cover,
                width: 104.0,
                height: 104.0,
              ),
      ),
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
              if (manager) ...[
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: context.appStrings!.profile),
                    if (manager) Tab(text: context.appStrings!.requests),
                  ],
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  indicatorWeight: 3,
                  labelColor: Theme.of(context).colorScheme.secondary,
                  unselectedLabelColor: Theme.of(context).primaryColor,
                  labelStyle: _width > 320
                      ? Theme.of(context).textTheme.subtitle1
                      : Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontSize: 16),
                ),
                Divider(
                    height: 1,
                    thickness: 1,
                    color: DefaultThemeColors.whiteSmoke1),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      _profileDetails(context),
                      _requestDetails(),
                    ],
                  ),
                ),
              ] else ...[
                Expanded(
                  child: _profileDetails(context),
                )
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _requestDetails() {
    return CustomPagedListView<MyRequestsResponseDTO>(
      initPageFuture: (pageKey) async {
        var requestResult = await ApiRepo().getAllRequests(
            subject: [widget?.employee?.id],
            manager: true,
            department: true,
            pageIndex: pageKey,
            pageSize: pageSize);
        requestsLength = (requestsLength ?? 0) +
            (requestResult?.result?.records?.length ?? 0);
        return requestResult.result!.toPagedList();
      },
      itemBuilder: (context, item, index) {
        return Column(
          children: [
            RequestCard(
              requestInfo: item,
              showStatus: true,
              index: index,
              total: requestsLength,
            ),
            // if (requestsLength != index + 1)
            //   Divider(
            //     height: 10,
            //     thickness: 1,
            //     indent: 60,
            //     color: DefaultThemeColors.whiteSmoke1,
            //   ),
          ],
        );
      },
    );
  }

  Widget _profileDetails(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 8),
      children: [
        if (widget?.employee?.contactNumber?.isNotEmpty == true) ...[
          profileCardItem(
            context.appStrings!.contactNumber,
            widget?.employee?.contactNumber,
            svg: VPayIcons.contacts_call,
            colorIcon: Theme.of(context).primaryColor,
          ),
          ListDivider(),
        ],
        if (widget?.employee?.email?.isNotEmpty == true) ...[
          profileCardItem(
            context.appStrings!.email,
            widget?.employee?.email,
            svg: VPayIcons.contacts_email,
            colorIcon: Theme.of(context).primaryColor,
          ),
          ListDivider(),
        ],
        if (widget?.employee?.address?.isNotEmpty == true) ...[
          profileCardItem(
            context.appStrings!.address,
            widget?.employee?.address,
            svg: VPayIcons.contacts_home,
            colorIcon: Theme.of(context).primaryColor,
          ),
          ListDivider(),
        ],
        if (widget?.employee?.gender?.isNotEmpty == true) ...[
          profileCardItem(
            context.appStrings!.gender,
            widget?.employee?.gender,
            svg: VPayIcons.profile_gender,
            colorIcon: Theme.of(context).primaryColor,
          ),
          ListDivider(),
        ],
        if (widget.employee?.birthDate?.toString().isNotEmpty == true) ...[
          profileCardItem(
            context.appStrings!.birthdate,
            dateFormat.format(
              widget.employee!.birthDate!,
            ),
            svg: VPayIcons.birthday,
            colorIcon: Theme.of(context).primaryColor,
          ),
          ListDivider(),
        ],
        if (widget.employee?.religion?.isNotEmpty == true) ...[
          profileCardItem(
            context.appStrings!.religion,
            widget.employee?.religion,
            icon: Icons.menu_book_outlined,
            colorIcon: Theme.of(context).primaryColor,
          ),
          ListDivider(),
        ],
        if (widget?.employee?.department?.name?.isNotEmpty == true) ...[
          profileCardItem(
            context.appStrings!.department,
            widget?.employee?.department?.name,
            svg: VPayIcons.profile_department,
            colorIcon: Theme.of(context).primaryColor,
          ),
          ListDivider(),
        ],
        if (widget.employee?.hireDate?.toString().isNotEmpty == true) ...[
          profileCardItem(
            context.appStrings!.hireDate,
            dateFormat.format(widget.employee!.hireDate!),
            icon: Icons.badge_outlined,
            colorIcon: Theme.of(context).primaryColor,
          ),
          ListDivider(),
        ],
        if (widget.employee?.currency?.name?.isNotEmpty == true) ...[
          profileCardItem(
            context.appStrings!.currency,
            widget.employee?.currency?.name,
            svg: VPayIcons.profile_currency,
            colorIcon: Theme.of(context).primaryColor,
          ),
          ListDivider(),
        ],
        if (widget?.employee?.manager?.fullName?.isNotEmpty == true) ...[
          profileCardItem(
            context.appStrings!.reportingManager,
            widget?.employee?.manager?.fullName,
            svg: VPayIcons.profile_manager,
            colorIcon: Theme.of(context).primaryColor,
          ),
          ListDivider(),
        ],
      ],
    );
  }

  Widget profileCardItem(String title, String? value,
      {String? svg, IconData? icon, Color? colorIcon}) {
    return ListTile(
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xffE1E1E1).withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: svg?.isNotEmpty == true
                ? SvgPicture.asset(
                    svg!,
                    color: colorIcon,
                  )
                : Icon(
                    icon,
                    size: 18,
                    color: colorIcon,
                  ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: DefaultThemeColors.nepal),
          ),
          SizedBox(height: 6),
          Text(
            value ?? "",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
