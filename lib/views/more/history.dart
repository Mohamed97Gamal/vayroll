import 'package:flutter/material.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/utils/utils.dart';
import 'call_history_tab.dart';
import 'email_history_tab.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke2,
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_header(), _body()],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: TitleStacked(context.appStrings!.history, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _body() {
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
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: context.appStrings!.callHistory),
                    Tab(text: context.appStrings!.emailHistory),
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
                    children: <Widget>[
                      CallHistoryTab(),
                      EmailHistoryTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
