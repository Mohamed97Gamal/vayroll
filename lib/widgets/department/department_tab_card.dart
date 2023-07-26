import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';

class DepartmentTabCard extends StatelessWidget {
  final int? present;
  final int? leave;
  final int? total;

  const DepartmentTabCard({Key? key, this.present, this.leave, this.total}) : super(key: key);

  String getNumber(int number) {
    if (number >= 1 && number <= 9)
      return "0${number.toString()}";
    else {
      return "${number.toString()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 16.0, right: 16.0),
      child: SizedBox(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: DefaultThemeColors.whiteSmoke2,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getNumber(present!) ?? "",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 17,
                              fontFamily: Fonts.hKGrotesk,
                              fontWeight: FontWeight.w500,
                              color: DefaultThemeColors.limeGreen,
                            ),
                      ),
                      Text(
                        context.appStrings!.present,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 17,
                              fontFamily: Fonts.hKGrotesk,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 3, 8, 0),
                  child: SizedBox(
                    height: 25,
                    width: 1,
                    child: Container(
                      color: DefaultThemeColors.nepal,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getNumber(leave!) ?? "",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: 17,
                            fontFamily: Fonts.hKGrotesk,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      Text(
                        context.appStrings!.leave,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 17,
                              fontFamily: Fonts.hKGrotesk,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 3, 8, 0),
                  child: SizedBox(
                    height: 25,
                    width: 1,
                    child: Container(
                      color: DefaultThemeColors.nepal,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getNumber(total!) ?? "",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 17,
                              fontFamily: Fonts.hKGrotesk,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Text(
                        context.appStrings!.total,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 17,
                              fontFamily: Fonts.hKGrotesk,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
