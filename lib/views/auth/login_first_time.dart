import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/api_responses/base_response.dart';
import 'package:vayroll/models/employee.dart';
import 'package:vayroll/models/user/user_DTO.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/repo/disk/disk_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class LoginFirstTimePage extends StatefulWidget {
  @override
  LoginFirstTimePageState createState() => LoginFirstTimePageState();
}

class LoginFirstTimePageState extends State<LoginFirstTimePage> {
  final formKey = GlobalKey<FormState>();

  late String userName;
  late String password;

  bool showPassword = false;

  Future _login() async {
    String? loginResponseMessage;
    BaseResponse<UserDTO>? userResponseInfo;

    final FormState form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      String passwordEncoded = base64.encode(utf8.encode(password));

      var success = (await showFutureProgressDialog<bool>(
        context: context,
        initFuture: () async {
          var loginResponse = await ApiRepo().login(userName.trim(), passwordEncoded);
          loginResponseMessage = loginResponse.message;
          if (loginResponse.result != null) {
            await DiskRepo().saveTokens(
              loginResponse.result!.accessToken!,
              loginResponse.result!.refreshToken!,
            );

            final userResponse = await ApiRepo().getUser();

            userResponseInfo = userResponse;

            if (userResponse.result != null) {
              // context.read<ThemeProvider>().theme = AppThemes.defaultTheme.copyWith(
              //     //primaryColor: userResponse?.result?.colors

              //     );

              await DiskRepo().saveUserId(userResponse.result!.id!);
              await DiskRepo().saveFirstTimeLogin(userResponse.result!.isFirstLogin!);
              await DiskRepo().saveDataConsentAccept((userResponseInfo!.result!.acceptedDataConsent ?? false));

              return true;
            }
          }
          return false;
        },
      ))!;

      if (!success) {
        await showCustomModalBottomSheet(
          context: context,
          desc: loginResponseMessage ?? userResponseInfo?.message ?? " ",
          icon: loginResponseMessage == "Internal Server Error" || userResponseInfo?.message == "Internal Server Error"
              ? ""
              : VPayIcons.blockUser,
        );
        return;
      }

      //------------------------------------ FCM Token -----------------------------------
      var fcmResponse = (await showFutureProgressDialog<BaseResponse<dynamic>>(
        context: context,
        initFuture: () => updateFCMTokenIfNeeded(),
      ))!;

      if (!fcmResponse.status!) {
        await showCustomModalBottomSheet(
          context: context,
          desc: fcmResponse.message ?? "",
          icon: VPayIcons.blockUser,
        );
        return;
      }
      //------------------------------------ Employee ------------------------------------
      var employee = await getEmployee();
      if (employee == null) return;

      await FirebaseCrashlytics.instance.setUserIdentifier(employee.id!);
      await FirebaseCrashlytics.instance.setCustomKey("group_id", employee.employeesGroup!.id!);
      await FirebaseCrashlytics.instance.setCustomKey("country_id", employee.employeesGroup?.country?.id ?? "");
      await FirebaseCrashlytics.instance.setCustomKey("sector_id", employee.employeesGroup?.sector?.id ?? "");
      await FirebaseCrashlytics.instance
          .setCustomKey("organization_id", employee.employeesGroup?.organization?.id ?? "");

      await FirebaseAnalytics.instance.setUserId(id: employee.id);
      await FirebaseAnalytics.instance.setUserProperty(name: "group_id", value: employee.employeesGroup?.id ?? "");
      await FirebaseAnalytics.instance.setUserProperty(name: "country_id", value: employee.employeesGroup?.country?.id ?? "");
      await FirebaseAnalytics.instance.setUserProperty(name: "sector_id", value: employee.employeesGroup?.sector?.id ?? "");
      await FirebaseAnalytics.instance
          .setUserProperty(name: "organization_id", value: employee.employeesGroup?.organization?.id ?? "");

      if (employee.confirmed!) {
        context.read<HomeTabIndexProvider>().index = 2;
        context.read<HomeTabIndexProvider>().hideBarItems = false;
      } else {
        context.read<HomeTabIndexProvider>().index = 0;
        context.read<HomeTabIndexProvider>().hideBarItems = true;
      }
      //----------------------------------------------------------------------------------

      context.read<DashboardWidgetsProvider>().init();

      if (userResponseInfo!.result!.changePasswordAtNextLogon!)
        Navigation.navToResetPassword(context);
      else if (userResponseInfo!.result!.isFirstLogin!)
        Navigation.navToSendVerificationOTP(context, userResponseInfo!.result!.email);
      else if (!(userResponseInfo!.result!.acceptedDataConsent ?? false))
        Navigation.navToDataConsent(context);
      else
        Navigation.navToHome(context);
    }
  }

  Future<Employee?> getEmployee() async {
    var response = (await showFutureProgressDialog<BaseResponse<Employee>>(
      context: context,
      initFuture: () => context.read<EmployeeProvider>().get(force: true),
    ))!;

    if (response.status! && response.result != null) return response.result;

    await showCustomModalBottomSheet(
      context: context,
      desc: response.message ?? " ",
      icon: VPayIcons.blockUser,
    );
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.landscape;
    return isPortrait
        ? Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          TitleStacked(context.appStrings!.login, Theme.of(context).primaryColor),
                          SvgPicture.asset(
                            VPayImages.login_Image,
                            fit: BoxFit.scaleDown,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: ListView(
                            children: [
                              SizedBox(height: 16),
                              Text(
                                context.appStrings!.fillYourDetailsProvidedByAdminOnYourEmailWithoutSlashN,
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: DefaultThemeColors.nepal),
                              ),
                              SizedBox(height: 24),
                              loginForm(),
                              SizedBox(height: 16),
                              forgetPassword(),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: CustomElevatedButton(
                                  text: context.appStrings!.signIn,
                                  onPressed: _login,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: SafeArea(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    width: size.width,
                    height: size.height * 0.38,
                    color: Colors.white,
                    child: SvgPicture.asset(
                      VPayImages.login_Image,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 30,
                        color: Colors.white,
                      ),
                      Container(
                        height: 31,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TitleStacked(context.appStrings!.login, Colors.white),
                            SizedBox(height: 24),
                            Text(
                              context.appStrings!.fillYourDetailsProvidedByAdminOnYourEmailWithoutSlashN,
                              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: DefaultThemeColors.nepal),
                            ),
                            SizedBox(height: 24),
                            loginForm(),
                            SizedBox(height: 16),
                            forgetPassword(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: CustomElevatedButton(
                                text: context.appStrings!.signIn,
                                onPressed: _login,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget forgetPassword() {
    return InkWell(
      onTap: () => Navigation.navToForgetPassword(context),
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          context.appStrings!.forgotPassword,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CommonTextField(
            label: context.appStrings!.email,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.white,
            textStyle: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
            hintStyle: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
            labelStyle: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            fillColor: Colors.transparent,
            suffixIcon: SvgPicture.asset(
              VPayIcons.account,
              fit: BoxFit.none,
              color: Colors.white,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            textInputAction: TextInputAction.next,
            inputFormatters: [FilteringTextInputFormatter.deny(' ')],
            onSaved: (String? value) => userName = value?.trim() ?? "",
            validator: (val) => Validation().checkEmail(val ?? "", context),
          ),
          SizedBox(height: 16),
          RequiredTextField(
            label: context.appStrings!.password,
            cursorColor: Colors.white,
            textStyle: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
            hintStyle: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
            labelStyle: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            fillColor: Colors.transparent,
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              child: SvgPicture.asset(
                showPassword ? VPayIcons.visibility_on : VPayIcons.visibility_off,
                fit: BoxFit.none,
                color: Colors.white,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            inputFormatters: [FilteringTextInputFormatter.deny(' ')],
            obscureText: !showPassword,
            onSaved: (value) => password = value ?? "",
          ),
        ],
      ),
    );
  }
}
