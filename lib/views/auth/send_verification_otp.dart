import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/logos.dart';
import 'package:vayroll/models/api_responses/base_response.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class SendVerificationOTPPage extends StatefulWidget {
  final String? email;

  SendVerificationOTPPage(this.email);

  @override
  SendVerificationOTPPageState createState() => SendVerificationOTPPageState();
}

class SendVerificationOTPPageState extends State<SendVerificationOTPPage> {
  final formKey = GlobalKey<FormState>();
  String? phone;

  String? mobileOrEmail = "email";

  String? countryCode = "+20";

  bool phoneNumberNotValid = false;

  Future _verify() async {
    final FormState form = formKey.currentState!;
    if (form.validate()) {
      form.save();

      String channel = mobileOrEmail == "mobile" ? "SMS" : "EMAIL";

      final verifyResponse = (await showFutureProgressDialog<BaseResponse<bool>>(
        context: context,
        initFuture: () async => ApiRepo().sendOtp(
            channel,
            mobileOrEmail == "mobile"
                ? "$countryCode$phone"
                : widget.email!.trim()),
      ))!;

      if (verifyResponse.status!) {
        if (channel == "EMAIL") {
          await showCustomModalBottomSheet(
            context: context,
            desc: context.appStrings!.theVerificationCodeSentSuccessfully,
          );
          Navigation.navToCheckMail(
              context,
              widget.email,
              context.appStrings!
                  .weHaveSentVerificationCodeToYourRegisteredEmailAddress,
              true);
        } else {
          await showCustomModalBottomSheet(
            context: context,
            desc: context.appStrings!.theVerificationCodeSentSuccessfully,
          );
          Navigation.navToVerificationOTP(context, "$countryCode$phone");
        }
      } else {
        await showCustomModalBottomSheet(
          context: context,
          desc: verifyResponse.message ?? " ",
        );
        return;
      }
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
      body: SafeArea(
        child: Form(
          key: formKey,
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    bool landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          landscape
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: SvgPicture.asset(
                    VPayLogos.logo_with_text,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: SvgPicture.asset(
                      VPayLogos.logo_with_text,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
          landscape ? SizedBox(height: 16) : SizedBox(height: 50),
          TitleStacked(context.appStrings!.verificationProcess,
              Theme.of(context).primaryColor),
          SizedBox(height: 20),
          Text(
            context.appStrings!
                .verificationCodeWillBeSentToYourRegisteredEmailOrMobileNumber,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Radio(
                value: "email",
                groupValue: mobileOrEmail,
                onChanged: (dynamic value) {
                  setState(() {
                    phoneNumberNotValid = false;
                    mobileOrEmail = value;
                  });
                },
              ),
              Expanded(
                child: Text(
                  widget.email!.substring(0, 2) +
                      "*" * widget.email!.split("@")[0].length +
                      '@' +
                      widget.email!.split("@")[1],
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(height: 1.20),
                ),
              ),
              // Container(
              //   constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 180),
              //   child: Text(
              //     widget.email.substring(0, 2) +
              //         "*" * widget.email.split("@")[0].length +
              //         '@' +
              //         widget.email.split("@")[1],
              //     style: Theme.of(context).textTheme.subtitle1.copyWith(height: 1.20),
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Radio(
                value: "mobile",
                groupValue: mobileOrEmail,
                onChanged: (dynamic value) {
                  setState(() {
                    mobileOrEmail = value;
                  });
                },
              ),
              Text(
                context.appStrings!.mobileNumber,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
          Visibility(
            visible: mobileOrEmail == "mobile",
            child: mobileVerify(),
          ),
          SizedBox(height: 20),
          landscape
              ? Center(
                  child: CustomElevatedButton(
                    text: context.appStrings!.send,
                    onPressed: _verify,
                  ),
                )
              : CustomElevatedButton(
                  text: context.appStrings!.send,
                  onPressed: _verify,
                ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Row mobileVerify() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: phoneNumberNotValid ? 15 : 0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: CountryCodePicker(
              onChanged: (value) {
                setState(() {
                  countryCode = value.dialCode;
                });
              },
              initialSelection: 'EG',
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
              textStyle: TextStyle(color: Colors.black, fontSize: 16),
              dialogTextStyle: TextStyle(color: Colors.black, fontSize: 16),
              padding: EdgeInsets.zero,
              searchDecoration:
                  InputDecoration(hintText: context.appStrings!.countryName),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Container(
            child: CommonTextField(
              keyboardType: TextInputType.phone,
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
              onSaved: (value) => phone = value,
              inputFormatters: [FilteringTextInputFormatter.deny(RegExp('^0'))],
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  setState(() {
                    phoneNumberNotValid = true;
                  });
                  return context.appStrings!.requiredField;
                } else {
                  if (value!.length >= 9) {
                    setState(() {
                      phoneNumberNotValid = false;
                    });
                    return null;
                  } else {
                    setState(() {
                      phoneNumberNotValid = true;
                    });
                    return context.appStrings!.mobileIsNotValid;
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
