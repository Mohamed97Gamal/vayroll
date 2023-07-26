import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:vayroll/delegates/profile_sliver_app_bar_delegate.dart';
import 'package:vayroll/providers/employee_provider.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';

import 'tabs.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: context.read<ProfileTabIndexProvider>().index!, length: 6, vsync: this);
    context.read<ProfileTabIndexProvider>().index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: MultiSliver(
                children: <Widget>[
                  SliverPersistentHeader(
                    pinned: true,
                    floating: false,
                    delegate: ProfileSliverAppBarDelegate(
                      employeePicUInt8List: context.watch<EmployeeProvider>().employee?.photoBase64 != null
                          ? base64Decode(context.watch<EmployeeProvider>().employee!.photoBase64!)
                          : null,
                      employeeName: context.watch<EmployeeProvider>().employee?.fullName,
                      employeeId: context.watch<EmployeeProvider>().employee?.employeeNumber,
                    ),
                  ),
                  SliverAppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    toolbarHeight: 49,
                    pinned: true,
                    floating: false,
                    flexibleSpace: TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(text: context.appStrings!.personalInformation),
                        Tab(text: context.appStrings!.contact),
                        Tab(text: context.appStrings!.education),
                        Tab(text: context.appStrings!.certifications),
                        Tab(text: context.appStrings!.skills),
                        Tab(text: context.appStrings!.workExperience),
                      ],
                      isScrollable: true,
                      indicatorColor: Theme.of(context).colorScheme.secondary,
                      indicatorWeight: 3,
                      labelColor: Theme.of(context).colorScheme.secondary,
                      unselectedLabelColor: Theme.of(context).primaryColor,
                      labelStyle: Theme.of(context).textTheme.bodyText2,
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(1),
                      child: Divider(height: 1, thickness: 1, color: DefaultThemeColors.gainsboro),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            PersonalInformationTab(),
            ContactsTab(),
            EducationTab(),
            CertificationsTab(),
            SkillsTab(),
            WorkExperienceTab(),
          ],
        ),
      ),
    );
  }
}
