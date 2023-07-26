import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/assets/logos.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/repo/disk/disk_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/bottom_sheet.dart';
import 'package:vayroll/widgets/common_text_field.dart';
import 'package:vayroll/widgets/custom_elevated_button.dart';
import 'package:vayroll/widgets/future_dialog.dart';
import 'package:vayroll/widgets/title_stack.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  late String userName;
  late String password;

  bool showPassword = false;
  bool showFingerPrint = false;

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await auth.authenticate(
        localizedReason:
            context.appStrings!.pleaseAuthenticateWithFingerprintToAccessTheApp,
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      await showCustomModalBottomSheet(
        context: context,
        desc: e.message ?? e.toString(),
        icon: VPayIcons.blockUser,
      );
    }

    if (!mounted) return;

    if (!isAuthenticated) return;

    var userResponse = (await showFutureProgressDialog<BaseResponse<UserDTO>>(
      context: context,
      initFuture: () => ApiRepo().getUser(),
    ))!;

    if (!userResponse.status! || userResponse.result == null) {
      setState(() {});
      await showCustomModalBottomSheet(
        context: context,
        desc: userResponse.message ?? "Something Went Wrong",
        icon: VPayIcons.blockUser,
      );

      return;
    }

    await DiskRepo().saveUserId(userResponse.result!.id!);
    await DiskRepo().saveFirstTimeLogin(userResponse.result!.isFirstLogin!);
    await DiskRepo().saveDataConsentAccept(
        (userResponse.result!.acceptedDataConsent ?? false));

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
    if (employee.confirmed!) {
      context.read<HomeTabIndexProvider>().index = 2;
      context.read<HomeTabIndexProvider>().hideBarItems = false;
    } else {
      context.read<HomeTabIndexProvider>().index = 0;
      context.read<HomeTabIndexProvider>().hideBarItems = true;
    }
    //----------------------------------------------------------------------------------

    if (userResponse.result!.changePasswordAtNextLogon!)
      Navigation.navToResetPassword(context);
    else if (!(userResponse.result!.acceptedDataConsent ?? false))
      Navigation.navToDataConsent(context);
    else
      Navigation.navToHome(context);
  }

  Future<Employee?> getEmployee() async {
    var response = (await showFutureProgressDialog<BaseResponse<Employee>>(
      context: context,
      initFuture: () => context.read<EmployeeProvider>().get(force: true),
    ).timeout(Duration(seconds: 10)))!;

    if (response.status! && response.result != null) return response.result;

    await showCustomModalBottomSheet(
      context: context,
      desc: response.message ?? " ",
      icon: VPayIcons.blockUser,
    );
    return null;
  }

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
          try {
            var loginResponse =
                await ApiRepo().login(userName.trim(), passwordEncoded);
            loginResponseMessage = loginResponse.message;
            if (loginResponse.result != null) {
              await DiskRepo().saveTokens(
                loginResponse.result!.accessToken!,
                loginResponse.result!.refreshToken!,
              );

              final userResponse = await ApiRepo().getUser();

              userResponseInfo = userResponse;

              if (userResponse.result != null) {
                context.read<ThemeProvider>().theme =
                    AppThemes.defaultTheme.copyWith(
                        //primaryColor: userResponse?.result?.colors

                        );

                await DiskRepo().saveUserId(userResponse.result!.id!);
                await DiskRepo()
                    .saveFirstTimeLogin(userResponse.result!.isFirstLogin!);
                await DiskRepo().saveDataConsentAccept(
                    (userResponseInfo!.result!.acceptedDataConsent ?? false));
                return true;
              }
            }
            return false;
          } catch (e) {
            return false;
          }
        },
      ))!;

      if (!success) {
        await showCustomModalBottomSheet(
          context: context,
          desc: loginResponseMessage ??
              userResponseInfo?.message ??
              "Sorry but we are facing issue authenticating you with biometric , please use your credentials to log you in",
          icon: loginResponseMessage == "Internal Server Error" ||
                  userResponseInfo?.message == "Internal Server Error"
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
      await FirebaseCrashlytics.instance
          .setCustomKey("group_id", employee.employeesGroup!.id!);
      await FirebaseCrashlytics.instance.setCustomKey(
          "country_id", employee.employeesGroup?.country?.id ?? "");
      await FirebaseCrashlytics.instance.setCustomKey(
          "sector_id", employee.employeesGroup?.sector?.id ?? "");
      await FirebaseCrashlytics.instance.setCustomKey(
          "organization_id", employee.employeesGroup?.organization?.id ?? "");

      await FirebaseAnalytics.instance.setUserId(id: employee.id);
      await FirebaseAnalytics.instance.setUserProperty(
          name: "group_id", value: employee.employeesGroup?.id ?? "");
      await FirebaseAnalytics.instance.setUserProperty(
          name: "country_id",
          value: employee.employeesGroup?.country?.id ?? "");
      await FirebaseAnalytics.instance.setUserProperty(
          name: "sector_id", value: employee.employeesGroup?.sector?.id ?? "");
      await FirebaseAnalytics.instance.setUserProperty(
          name: "organization_id",
          value: employee.employeesGroup?.organization?.id ?? "");

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
        Navigation.navToSendVerificationOTP(
            context, userResponseInfo!.result!.email);
      else if (!(userResponseInfo!.result!.acceptedDataConsent ?? false))
        Navigation.navToDataConsent(context);
      else
        Navigation.navToHome(context);
    }
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      bool firstTimeLogin = (await DiskRepo().getFirstTimeLogin())!;
      final accessToken = (await DiskRepo().getTokens()).first;
      if (!firstTimeLogin &&
          (accessToken ?? "").isNotEmpty &&
          await auth.canCheckBiometrics) {
        setState(() {
          showFingerPrint = true;
          _authenticateUser();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: SafeArea(
          child: landscape ? loginPageLandScape() : loginPage(),
        ),
      ),
    );
  }

  Widget loginPage() {
    final screenSize = MediaQuery.of(context).size;

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SvgPicture.asset(
            VPayLogos.logo_with_text,
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        ),
        SizedBox(height: 8.0),
        TitleStacked(
            context.appStrings!.loginToAccount, Theme.of(context).primaryColor),
        SizedBox(height: screenSize.height * 0.06),
        Text(
          context.appStrings!
              .fillYourDetailsProvidedByAdminOnYourEmailWithoutSlashN,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: screenSize.height * 0.03),
        CommonTextField(
          label: context.appStrings!.email,
          // initialValue: Credentials().userName,
          keyboardType: TextInputType.emailAddress,
          textStyle: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: Theme.of(context).primaryColor),
          labelStyle: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: Theme.of(context).primaryColor),
          suffixIcon: SvgPicture.asset(
            VPayIcons.account,
            fit: BoxFit.none,
            color: Theme.of(context).primaryColor,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: DefaultThemeColors.nepal),
          ),
          textInputAction: TextInputAction.next,
          fillColor: Colors.transparent,
          inputFormatters: [FilteringTextInputFormatter.deny(' ')],
          onSaved: (String? value) => userName = value?.trim() ?? "",
          validator: (val) => Validation().checkEmail(val ?? "", context),
        ),
        SizedBox(height: screenSize.height * 0.03),
        RequiredTextField(
          label: context.appStrings!.password,
          // initialValue: Credentials().password,
          textStyle: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: Theme.of(context).primaryColor),
          labelStyle: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: Theme.of(context).primaryColor),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: DefaultThemeColors.nepal),
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
              color: Theme.of(context).primaryColor,
            ),
          ),
          inputFormatters: [FilteringTextInputFormatter.deny(' ')],
          obscureText: !showPassword,
          onSaved: (value) => password = value ?? "",
        ),
        SizedBox(height: screenSize.height * 0.01),
        _forgetPasswordLayout(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: CustomElevatedButton(
            text: context.appStrings!.connectToAccount,
            onPressed: _login,
          ),
        ),
        if (showFingerPrint) _fingerPrintLayout(),
      ],
    );
  }

  Widget loginPageLandScape() {
    final screenSize = MediaQuery.of(context).size;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, bottom: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenSize.height * 0.2,
              child: SvgPicture.asset(
                VPayLogos.logo_with_text,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(height: 24.0),
            TitleStacked(context.appStrings!.loginToAccount,
                Theme.of(context).primaryColor),
            SizedBox(height: screenSize.height * 0.06),
            Text(
              context.appStrings!
                  .fillYourDetailsProvidedByAdminOnYourEmailWithoutSlashN,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: screenSize.height * 0.03),
            CommonTextField(
              label: context.appStrings!.email,
              // initialValue: Credentials().userName,
              keyboardType: TextInputType.emailAddress,
              textStyle: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Theme.of(context).primaryColor),
              labelStyle: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Theme.of(context).primaryColor),
              suffixIcon: SvgPicture.asset(
                VPayIcons.account,
                fit: BoxFit.none,
                color: Theme.of(context).primaryColor,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: DefaultThemeColors.nepal),
              ),
              textInputAction: TextInputAction.next,
              fillColor: Colors.transparent,
              inputFormatters: [FilteringTextInputFormatter.deny(' ')],
              onSaved: (String? value) => userName = value?.trim() ?? "",
              validator: (val) => Validation().checkEmail(val??"", context),
            ),
            SizedBox(height: screenSize.height * 0.03),
            RequiredTextField(
              label: context.appStrings!.password,
              // initialValue: Credentials().password,
              textStyle: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Theme.of(context).primaryColor),
              labelStyle: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Theme.of(context).primaryColor),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: DefaultThemeColors.nepal),
              ),
              fillColor: Colors.transparent,
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                child: SvgPicture.asset(
                  showPassword
                      ? VPayIcons.visibility_on
                      : VPayIcons.visibility_off,
                  fit: BoxFit.none,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              inputFormatters: [FilteringTextInputFormatter.deny(' ')],
              obscureText: !showPassword,
              onSaved: (value) => password = value ?? "",
            ),
            SizedBox(height: screenSize.height * 0.01),
            _forgetPasswordLayout(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: isPortrait
                  ? Center(
                      child: CustomElevatedButton(
                        text: context.appStrings!.connectToAccount,
                        onPressed: _login,
                      ),
                    )
                  : CustomElevatedButton(
                      text: context.appStrings!.connectToAccount,
                      onPressed: _login,
                    ),
            ),
            if (showFingerPrint) _fingerPrintLayout(),
          ],
        ),
      ),
    );
  }

  Column _fingerPrintLayout() {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Center(
          child: Text(context.appStrings!.youCanLoginViaFingerPrint,
              style: Theme.of(context).textTheme.subtitle1),
        ),
        SizedBox(height: screenSize.height * 0.04),
        InkWell(
          onTap: () async {
            if (await auth.canCheckBiometrics) {
              await _authenticateUser();
            } else {
              await showCustomModalBottomSheet(
                context: context,
                desc: context.appStrings!.biometricIsNotSupported,
              );
            }
          },
          child: SvgPicture.asset(VPayImages.fingerprint_block),
        ),
      ],
    );
  }

  Widget _forgetPasswordLayout() {
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
}
