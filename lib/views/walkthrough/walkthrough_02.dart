import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/custom_elevated_button.dart';
import 'package:vayroll/widgets/dot_indicator.dart';
import 'package:vayroll/utils/utils.dart';

class WalkThrough02 extends StatelessWidget {
  final int pageCount;

  WalkThrough02({required this.pageCount}) : assert(pageCount != null);

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
            child: SvgPicture.asset(VPayImages.walkthrough_02, fit: BoxFit.contain),
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
                          context.appStrings!.trackAttendanceAndManageShifts,
                          style: Theme.of(context).textTheme.headline4,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          context.appStrings!.manageEmployeeShiftsAndAccessTheirWeeklyOrMonthlyAttendanceReports,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: DefaultThemeColors.nepal),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        DotIndicator(
                          height: 12,
                          currentIndex: 1,
                          pageCount: pageCount,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              isPortrait? Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right:64.0,bottom: 8),
                  child: SizedBox(
                    width: 137,
                    child: CustomElevatedButton(
                      text: context.appStrings!.done,
                      onPressed: () => Navigation.navToHome(context),
                    ),
                  ),
                ),
              ):Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: 137,
                  child: CustomElevatedButton(
                    text: context.appStrings!.done,
                    onPressed: () => Navigation.navToHome(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
