import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/api_responses/base_response.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/repo/disk/disk_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  static Future<void> logout(BuildContext? context) async {
    if (context != null) {
      await showFutureProgressDialog<BaseResponse<dynamic>>(
        context: context,
        initFuture: () async {
          var fcmResponse = await removeFCMToken();
          if (!fcmResponse.status!) return fcmResponse;
          return await ApiRepo().logout();
        },
      );
    }

    await FirebaseCrashlytics.instance.setUserIdentifier("");
    await FirebaseAnalytics.instance.resetAnalyticsData();

    await DiskRepo().saveTokens("", "");
    await DiskRepo().saveUserId("");
    await DiskRepo().saveFirstTimeLogin(true);
    await DiskRepo().saveOrgChartShowcaseDisplayed(false);

    if (context != null) {
      Navigation.navToLoginAndRemoveUntil(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke2,
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [_header(context), _list(context), _footer(context)],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: TitleStacked(context.appStrings!.settings, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _list(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: ListView(
          children: [
            SizedBox(height: 10),
            SettingsListTile(
              leadingIconSvg: VPayIcons.language,
              title: context.appStrings!.changeLanguage,
              onTap: () => Navigation.navToChangeLanguage(context),
            ),
            ListDivider(),
            SettingsListTile(
              leadingIconSvg: VPayIcons.key,
              title: context.appStrings!.changePassword,
              onTap: () => Navigation.navToChangePassword(context),
            ),
            ListDivider(),
            SettingsListTile(
              leadingIconSvg: VPayIcons.messaging,
              title: context.appStrings!.feedback,
              onTap: () => Navigation.navToFeedback(context),
            ),
            ListDivider(),
            SettingsListTile(
              leadingIconSvg: VPayIcons.support,
              title: context.appStrings!.support,
              onTap: () => Navigation.navToSupport(context),
            ),
            ListDivider(),
            SettingsListTile(
              leadingIconSvg: VPayIcons.several,
              title: context.appStrings!.helpDocuments,
              onTap: () => Navigation.navToHelpDocument(context),
            ),
            ListDivider(),
            SettingsListTile(
              leadingIconSvg: VPayIcons.protected,
              title: context.appStrings!.privacyPolicies,
              onTap: () => Navigation.navToPrivacyPolicy(context),
            ),
            ListDivider(),
            SettingsListTile(
              leadingIconSvg: VPayIcons.protected,
              title: context.appStrings!.termsAndConditions,
              onTap: () => Navigation.navToTerms(context),
            ),
            ListDivider(),
          ],
        ),
      ),
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, bottom: 30),
      color: Colors.white,
      child: Row(
        children: [
          SvgPicture.asset(
            VPayIcons.logout,
            fit: BoxFit.none,
          ),
          SizedBox(width: 10),
          InkWell(
            onTap: () => {
              showConfirmationBottomSheet(
                context: context,
                desc: context.appStrings!.pleaseConfirmToLogoutFromTheVPayApplication,
                cancelText: context.appStrings!.cancel,
                confirmText: context.appStrings!.logout,
                onConfirm: () {
                  Navigator.of(context).pop();
                  logout(context);
                },
              ),
            },
            child: Text(
              context.appStrings!.logout,
              style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
