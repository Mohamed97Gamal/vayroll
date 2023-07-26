import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/custom_icons.dart';
import 'package:vayroll/providers/home_tab_index_provider.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/views/dashboard/dashboard.dart';
import 'package:vayroll/views/more/more.dart';
import 'package:vayroll/views/profile/profile.dart';
import 'package:vayroll/views/requests/requests.dart';
import 'package:vayroll/views/settings/settings.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _getCurrentPage(BuildContext context) {
    int? i = context.read<HomeTabIndexProvider>().index;
    bool hideItems = context.read<HomeTabIndexProvider>().hideBarItems!;



    if (hideItems) {
      switch (i) {
        case 0:
          return ProfilePage();
        case 1:
          return SettingsPage();
        default:
          return ProfilePage();
      }
    }

    switch (i) {
      case 0:
        return ProfilePage();
      case 1:
        return RequestsPage();
      case 2:
        return DashboardPage();
      case 3:
        return SettingsPage();
      case 4:
        return MorePage();
      default:
        return DashboardPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    var hideItems = context.watch<HomeTabIndexProvider>().hideBarItems!;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: _getCurrentPage(context),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            context.read<HomeTabIndexProvider>().index = index;
          },
          unselectedItemColor: Theme.of(context).primaryColor,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          type: BottomNavigationBarType.fixed,
          currentIndex: context.watch<HomeTabIndexProvider>().index!,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Icon(CustomIcons.profile),
              ),
              label: context.appStrings!.profile,
            ),
            if (!hideItems)
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Icon(CustomIcons.requests),
                ),
                label: context.appStrings!.requests,
              ),
            if (!hideItems)
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Icon(CustomIcons.dashboard),
                ),
                label: context.appStrings!.home,
              ),
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Icon(CustomIcons.settings),
              ),
              label: context.appStrings!.settings,
            ),
            if (!hideItems)
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.more_horiz),
                ),
                label: context.appStrings!.more,
              ),
          ],
        ),
      ),
    );
  }
}
