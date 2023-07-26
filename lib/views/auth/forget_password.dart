import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/logos.dart';
import 'package:vayroll/models/api_responses/base_response.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/utils/validation.dart';
import 'package:vayroll/widgets/widgets.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  ForgetPasswordPageState createState() => ForgetPasswordPageState();
}

class ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final formKey = GlobalKey<FormState>();
  late String email;

  Future _resetPass() async {
    final FormState form = formKey.currentState!;
    if (form.validate()) {
      form.save();

      final resetPassResponse =
          (await showFutureProgressDialog<BaseResponse<String>>(
        context: context,
        initFuture: () => ApiRepo().resetPassword(email.trim()),
      ))!;

      if (resetPassResponse.status!) {
        await Navigation.navToCheckMail(
            context,
            email.trim(),
            context.appStrings!.weHaveSentPasswordRecoverInstructionsToYourEmail,
            false);
      } else {
        await showCustomModalBottomSheet(
          context: context,
          desc: resetPassResponse?.message ?? " ",
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
        elevation: 0,
      ),
      body: SafeArea(child: forgetPassForm()),
    );
  }

  Widget forgetPassForm() {
    final screenSize = MediaQuery.of(context).size;
    bool landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          SizedBox(height: 15),
          landscape
              ? SizedBox(
                  height: screenSize.height * 0.2,
                  child: SvgPicture.asset(
                    VPayLogos.logo_with_text,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: SvgPicture.asset(
                    VPayLogos.logo_with_text,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
          landscape ? SizedBox(height: 16) : SizedBox(height: 50),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleStacked(context.appStrings!.forgotPassword,
                  Theme.of(context).primaryColor),
              SizedBox(height: screenSize.height * 0.06),
               Text(
                      context.appStrings!
                          .newPasswordWillBeSentToEmployeesEmailAddressWithoutSlashN,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
              SizedBox(height: screenSize.height * 0.03),
              CommonTextField(
                label: context.appStrings!.email,
                textStyle: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Theme.of(context).primaryColor),
                labelStyle: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Theme.of(context).primaryColor),
                suffixIcon: SvgPicture.asset(
                  VPayIcons.envelope,
                  fit: BoxFit.none,
                ),
                fillColor: Colors.transparent,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: DefaultThemeColors.nepal),
                ),
                inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                onSaved: (value) => email = value?.trim() ?? "",
                validator: (val) => Validation().checkEmail(val??"", context),
              ),
              SizedBox(height: screenSize.height * 0.03),
              landscape
                  ? Center(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: CustomElevatedButton(
                            text: context.appStrings!.send,
                            onPressed: () => _resetPass(),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CustomElevatedButton(
                        text: context.appStrings!.send,
                        onPressed: () => _resetPass(),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
