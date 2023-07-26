import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vayroll/assets/logos.dart';
import 'package:vayroll/models/api_responses/base_response.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/repo/disk/disk_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/bottom_sheet.dart';
import 'package:vayroll/widgets/future_dialog.dart';
import 'package:vayroll/widgets/title_stack.dart';
import 'package:vayroll/widgets/widgets.dart';

class VerificationOTPPage extends StatefulWidget {
  final String? emailOrPhone;

  VerificationOTPPage(this.emailOrPhone);

  @override
  VerificationOTPPageState createState() => VerificationOTPPageState();
}

class VerificationOTPPageState extends State<VerificationOTPPage> {
  String appSignature = "";
  String otpCode = "";

  Future<void> resendCode(BuildContext context) async {
    String channel = widget.emailOrPhone!.startsWith("+") ? "SMS" : "EMAIL";
    // ignore: unused_local_variable
    final verifyResponse = await showFutureProgressDialog<BaseResponse<bool>>(
      context: context,
      initFuture: () async => ApiRepo().sendOtp(channel, widget.emailOrPhone),
    );
    await showCustomModalBottomSheet(
      context: context,
      desc: verifyResponse?.message ?? context.appStrings!.theVerificationCodeSentSuccessfully,
    );
    return;
  }

  Future<void> verifyCode(BuildContext context) async {
    final verifyOTPResponse = (await showFutureProgressDialog<BaseResponse<bool>>(
      context: context,
      initFuture: () async => ApiRepo().verifyOtp(otpCode, widget.emailOrPhone),
    ))!;

    if (verifyOTPResponse.status!) {
      await DiskRepo().saveFirstTimeLogin(false);
      await showCustomModalBottomSheet(
        context: context,
        desc: verifyOTPResponse.message ?? context.appStrings!.yourDeviceHasBeenSuccessfullyVerified,
        isDismissible: false,
      );
      if ((await DiskRepo().getDataConsent())!)
        Navigation.navToWalkthrough(context);
      else
        Navigation.navToDataConsent(context);
    } else {
      await showCustomModalBottomSheet(
        context: context,
        desc: verifyOTPResponse?.message ?? context.appStrings!.errorVerifyingYourCode,
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    bool landscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return landscape
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: SvgPicture.asset(
                        VPayLogos.logo_with_text,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    SizedBox(height: 16),
                    TitleStacked(context.appStrings!.verificationCode, Theme.of(context).primaryColor),
                    SizedBox(height: 20),
                    Text(
                      context.appStrings!.pleaseTypeTheVerificationCodeSentTo,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(
                      widget.emailOrPhone!.startsWith("+")
                          ? widget.emailOrPhone!
                          : widget.emailOrPhone!.substring(0, 2) +
                              "*" * widget.emailOrPhone!.split("@")[0].length +
                              '@' +
                              widget.emailOrPhone!.split("@")[1],
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 384,
                      child: PinCodeTextField(
                        appContext: context,
                        textStyle: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 26),
                        length: 6,
                        onChanged: (value) {
                          setState(() {
                            otpCode = value;
                          });
                        },
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s|-|\.|,"))],
                        enableActiveFill: true,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.underline,
                          fieldHeight: 45,
                          //fieldWidth: 40,
                          activeFillColor: Colors.transparent,
                          activeColor: DefaultThemeColors.nepal,
                          inactiveColor: DefaultThemeColors.gainsboro,
                          inactiveFillColor: Colors.transparent,
                          selectedColor: Theme.of(context).primaryColor,
                          selectedFillColor: Colors.transparent,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: 315,
                      child: CustomElevatedButton(
                        text: context.appStrings!.verifyNow.toUpperCase(),
                        onPressed: () => verifyCode(context),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          context.appStrings!.didNotReceiveACode,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: DefaultThemeColors.nepal, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(width: 100),
                        InkWell(
                          child: Text(
                            context.appStrings!.resendCode,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          onTap: () => resendCode(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        : ListView(
            padding: EdgeInsets.zero,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: SvgPicture.asset(
                          VPayLogos.logo_with_text,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    TitleStacked(context.appStrings!.verificationCode, Theme.of(context).primaryColor),
                    SizedBox(height: 20),
                    Text(
                      context.appStrings!.pleaseTypeTheVerificationCodeSentTo,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(
                      widget.emailOrPhone!.startsWith("+")
                          ? widget.emailOrPhone!
                          : widget.emailOrPhone!.substring(0, 2) +
                              "*" * widget.emailOrPhone!.split("@")[0].length +
                              '@' +
                              widget.emailOrPhone!.split("@")[1],
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(height: 30),
                    PinCodeTextField(
                      appContext: context,
                      textStyle: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 26),
                      length: 6,
                      onChanged: (value) {
                        setState(() {
                          otpCode = value;
                        });
                      },
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s|-|\.|,"))],
                      enableActiveFill: true,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        fieldHeight: 45,
                        //fieldWidth: 40,
                        activeFillColor: Colors.transparent,
                        activeColor: DefaultThemeColors.nepal,
                        inactiveColor: DefaultThemeColors.gainsboro,
                        inactiveFillColor: Colors.transparent,
                        selectedColor: Theme.of(context).primaryColor,
                        selectedFillColor: Colors.transparent,
                      ),
                    ),
                    SizedBox(height: 5),
                    CustomElevatedButton(
                      text: context.appStrings!.verifyNow.toUpperCase(),
                      onPressed: () => verifyCode(context),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            context.appStrings!.didNotReceiveACode,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: DefaultThemeColors.nepal, fontWeight: FontWeight.normal),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            child: Text(
                              context.appStrings!.resendCode,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            onTap: () => resendCode(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
