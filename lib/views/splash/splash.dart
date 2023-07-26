import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/assets/logos.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/disk/disk_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';

import '../../firebase_remote_config.dart';

class SplashPage extends StatefulWidget {

  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() async {
      await Future.delayed(Duration(seconds: 2));
     await FirebaseRemoteConfigService().initialize();
     Urls.baseUrl= FirebaseRemoteConfigService().remoteConfig.getString("base_api_url");

      bool? firstTimeLogin = await DiskRepo().getFirstTimeLogin();
      final accessToken = (await DiskRepo().getTokens()).first;
      if (firstTimeLogin == null && accessToken == null)
        Navigation.navToFirstTimeLoginAndRemoveUntil(context);
      else
        Navigation.navToLoginAndRemoveUntil(context);
    });
  }
// Future<void> fetchFirebaseConfig()async{
//     await FirebaseRemoteConfigService().remoteConfig.ensureInitialized();
//   await FirebaseRemoteConfigService().remoteConfig.setConfigSettings(RemoteConfigSettings(
//     fetchTimeout: const Duration(seconds: 10),
//     minimumFetchInterval: Duration.zero,
//   ));
//   await FirebaseRemoteConfigService().remoteConfig.fetchAndActivate();
// }
  @override
  Widget build(BuildContext context) {
    bool landscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: landscape
            ? Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:32.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 13,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 25,
                  child: CircleAvatar(
                    backgroundColor: DefaultThemeColors.allports,
                    radius: 8,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              VPayLogos.logo_with_text_dark,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 32),
                            Text(
                              context.appStrings!.splash_text,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: SvgPicture.asset(
                          VPayImages.splach_Image,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
            : Stack(
                children: [
                  Positioned(
                    top: 50,
                    left: 20,
                    child: CircleAvatar(
                      backgroundColor: DefaultThemeColors.allports,
                      radius: 8,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: -7,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 13,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FractionallySizedBox(
                            widthFactor: 0.7,
                            child: SvgPicture.asset(
                              VPayLogos.logo_with_text_dark,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 32.0),
                          Text(
                            context.appStrings!.splash_text,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white, fontSize: 20),
                          ),
                          Expanded(
                            child: SvgPicture.asset(
                              VPayImages.splach_Image,
                              fit: BoxFit.contain,
                              width:double.infinity,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}