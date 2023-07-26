import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/bottom_sheet.dart';
import 'package:vayroll/widgets/custom_elevated_button.dart';
import 'package:vayroll/widgets/widgets.dart';

class CheckMail extends StatelessWidget {
  final String? email;
  final String desc;
  final bool forgetPassOrVerficition;

  CheckMail(this.email, this.desc, this.forgetPassOrVerficition);

  Future<String?> _checkCanLaunchEmailApp() async {
    if (Platform.isAndroid) {
      if (email!.endsWith("gmail.com")) {
        // if (await canLaunch(AppScheme.gmailAndroid))
        return AppScheme.gmailAndroid;
      } else {
        //if (await canLaunch(AppScheme.outlookAndroidIos))
        return AppScheme.outlookAndroidIos;
      }
    } else if (Platform.isIOS) {
      if (email!.endsWith("gmail.com")) {
        //if (await canLaunch(AppScheme.gmailIos))
        return AppScheme.gmailIos;
      } else {
        //  if (await canLaunch(AppScheme.outlookAndroidIos))
        return AppScheme.outlookAndroidIos;
      }
      //if (await canLaunch(AppScheme.mailAppIos))
      // return AppScheme.mailAppIos;
    }
    return null;
  }

  Future<void> openEmail(BuildContext context) async {
    var emailAppScheme = await _checkCanLaunchEmailApp();

    if (forgetPassOrVerficition) {
      if (emailAppScheme != null) {
        Navigation.navToVerificationOTPReplacment(context, email);
        launch(emailAppScheme);
      } else {
        await showCustomModalBottomSheet(
          context: context,
          desc: context.appStrings!.couldNotFindEmailApp,
          isDismissible: false,
        );
        Navigation.navToVerificationOTPReplacment(context, email);
      }
    } else {
      if (emailAppScheme != null) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        launch(emailAppScheme);
      } else {
        await showCustomModalBottomSheet(
          context: context,
          desc: context.appStrings!.couldNotFindEmailApp,
          isDismissible: false,
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        leading: forgetPassOrVerficition ? Container() : CustomBackButton(),
        actions: [
          forgetPassOrVerficition
              ? RotatedBox(
                  quarterTurns: 2,
                  child: IconButton(
                    onPressed: () => Navigation.navToVerificationOTPReplacment(
                        context, email),
                    icon: SvgPicture.asset(
                      VPayIcons.left_arrow,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : Container(),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: isPortrait
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(VPayImages.check_Mail),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            context.appStrings!.checkYourMail,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(
                                    color: DefaultThemeColors.prussianBlue),
                          ),
                          SizedBox(height: 12),
                          Text(
                            context.appStrings!
                                .weHaveSentPasswordRecoverInstructionsToYourEmailWithoutSlash,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: DefaultThemeColors.nepal),
                          ),
                          SizedBox(height: 32),
                          Center(
                            child: Container(
                              width: 315,
                              child: CustomElevatedButton(
                                text: context.appStrings!.openEmailApp
                                    .toUpperCase(),
                                onPressed: () => openEmail(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Center(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          SvgPicture.asset(VPayImages.check_Mail),
                          SizedBox(height: 12),
                          Text(
                            context.appStrings!.checkYourMail,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(
                                    color: DefaultThemeColors.prussianBlue),
                          ),
                          SizedBox(height: 12),
                          Text(
                            desc,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: DefaultThemeColors.nepal),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 30),
                    child: CustomElevatedButton(
                      text: context.appStrings!.openEmailApp.toUpperCase(),
                      onPressed: () => openEmail(context),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
