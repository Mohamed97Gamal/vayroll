import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/custom_elevated_button.dart';
import 'package:vayroll/widgets/title_stack.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/utils/utils.dart';

class ChangeLanguagePage extends StatefulWidget {
  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  final List<String> languages = ['English'];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          _languagesLayout(context),
          _updateButton(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: TitleStacked(context.appStrings!.changeLanguage, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _languagesLayout(BuildContext context) {
    var availableHeight = MediaQuery.of(context).size.height * 0.65;
    var listHeight = languages.length * 70.0 + 30;
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? Center(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: 600, maxHeight: listHeight > availableHeight ? availableHeight : listHeight),
              child: _list(context),
            ),
          )
        : Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: _list(context),
              ),
            ),
          );
  }

  Widget _list(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: languages.length,
      itemBuilder: (context, index) {
        bool itemSelected = selectedIndex == index;
        return Container(
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                color: itemSelected ? Theme.of(context).colorScheme.secondary : Theme.of(context).primaryColor),
          ),
          child: ListTile(
            onTap: () {
              setState(() => selectedIndex = index);
            },
            dense: true,
            title: Text(
              languages[index],
              style: itemSelected
                  ? Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).colorScheme.secondary)
                  : Theme.of(context).textTheme.subtitle1,
            ),
            trailing: itemSelected ? SvgPicture.asset(VPayIcons.tick) : null,
          ),
        );
      },
    );
  }

  Widget _updateButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: CustomElevatedButton(
            text: context.appStrings!.update,
            textStyle: TextStyle(color: DefaultThemeColors.nepal),
            onPressed: null,
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(DefaultThemeColors.Gray92)),
          ),
        ),
      ),
    );
  }
}
