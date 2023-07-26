import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/dot_indicator.dart';
import 'package:vayroll/utils/utils.dart';

class WalkThrough01 extends StatelessWidget {
  final int pageCount;
  WalkThrough01({required this.pageCount}) : assert(pageCount != null);

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.landscape;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 465,
          child: Container(
            padding: EdgeInsets.only(top: 30, bottom: 20),
            child: SvgPicture.asset(VPayImages.walkthrough_01, fit: BoxFit.scaleDown),
          ),
        ),
        Expanded(
          flex: 347,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          context.appStrings!.instantlyCheckInOrCheckOut,
                          style: Theme.of(context).textTheme.headline4,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          context.appStrings!.markTheStartAndEndOfYourWorkdayWithJustATap,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: DefaultThemeColors.nepal),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        DotIndicator(
                          height: 12,
                          currentIndex: 0,
                          pageCount: pageCount,
                        ),
                        // Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),
              ),
              isPortrait?
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right:16.0,bottom: 8),
                      child: TextButton(
                        child: Text(context.appStrings!.skip.toUpperCase(),
                            textAlign: TextAlign.center, style: Theme.of(context).textTheme.caption),
                        onPressed: () => Navigation.navToHome(context),
                      ),
                    ),
                  )
                  :Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  child: Text(context.appStrings!.skip.toUpperCase(),
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.caption),
                  onPressed: () => Navigation.navToHome(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
