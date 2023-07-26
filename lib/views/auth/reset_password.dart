import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/api_responses/base_response.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/utils/validation.dart';
import 'package:vayroll/widgets/bottom_sheet.dart';
import 'package:vayroll/widgets/common_text_field.dart';
import 'package:vayroll/widgets/custom_elevated_button.dart';
import 'package:vayroll/widgets/future_dialog.dart';
import 'package:vayroll/widgets/title_stack.dart';
import 'package:vayroll/widgets/widgets.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ResetPasswordPage> {
  final formKey = GlobalKey<FormState>();

  //final newPasswordKey = GlobalKey<FormFieldState>();
  bool showPassword = false;
  bool showPasswordConfirm = false;

  String? password;
  String? confirPassword;

  Future _changePass() async {
    final FormState form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      final changePassResponse = (await showFutureProgressDialog<BaseResponse<String>>(
        context: context,
        initFuture: () => ApiRepo().newPassword(password),
      ))!;

      if (changePassResponse.status!) {
        await showCustomModalBottomSheet(
          context: context,
          isDismissible: false,
          desc: context.appStrings!.passwordChangedSuccessfully,
        );
        Navigation.navToLoginAndRemoveUntil(context);
      } else {
        await showCustomModalBottomSheet(
          context: context,
          desc: changePassResponse.message ?? " ",
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              TitleStacked(context.appStrings!.createNewPassword, Theme.of(context).primaryColor),
              SizedBox(height: 32),
              Text(
                "Password must contain 8 to 20 characters with at least one digit, one lowercase character, one uppercase character and one special character.",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(height: 1),
              ),
              SizedBox(height: 50),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    context.appStrings!.newPassword,
                    style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal),
                  )),
              CommonTextField(
                //key: newPasswordKey,
                hintText: context.appStrings!.typeHere,
                // label: "New Password",
                textStyle: Theme.of(context).textTheme.caption!.copyWith(color: Theme.of(context).primaryColor),
                labelStyle: Theme.of(context).textTheme.caption!.copyWith(color: Theme.of(context).primaryColor),
                hintStyle: Theme.of(context).textTheme.caption!.copyWith(color: Theme.of(context).primaryColor),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  child: SvgPicture.asset(
                    showPassword ? VPayIcons.visibility_on : VPayIcons.visibility_off,
                    fit: BoxFit.none,
                  ),
                ),
                textInputAction: TextInputAction.next,
                obscureText: !showPassword,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: DefaultThemeColors.nepal),
                ),
                inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                fillColor: Colors.transparent,
                onchanged: (value) => password = value,
                //onSubmit: (value) => newPasswordKey.currentState.validate(),
                validator: (value) => Validation().checkPassword(value, context),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(context.appStrings!.confirmPassword,
                    style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
              ),
              CommonTextField(
                hintText: context.appStrings!.typeHere,
                // label: "Confirm Password",
                labelStyle: Theme.of(context).textTheme.caption!.copyWith(color: Theme.of(context).primaryColor),
                textStyle: Theme.of(context).textTheme.caption!.copyWith(color: Theme.of(context).primaryColor),
                hintStyle: Theme.of(context).textTheme.caption!.copyWith(color: Theme.of(context).primaryColor),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      showPasswordConfirm = !showPasswordConfirm;
                    });
                  },
                  child: SvgPicture.asset(
                    showPasswordConfirm ? VPayIcons.visibility_on : VPayIcons.visibility_off,
                    fit: BoxFit.none,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: DefaultThemeColors.nepal),
                ),
                fillColor: Colors.transparent,
                onchanged: (value) => confirPassword = value,
                inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                obscureText: !showPasswordConfirm,
                validator: (value) => value?.isEmpty ?? true
                    ? context.appStrings!.requiredField
                    : confirPassword == password
                        ? null
                        : context.appStrings!.passwordDoNotMatch,
              ),
              SizedBox(height: 32),
              isPortrait
                  ? Center(
                      child: Container(
                        width: 315,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: CustomElevatedButton(
                            text: context.appStrings!.resetPassword.toUpperCase(),
                            onPressed: _changePass,
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CustomElevatedButton(
                        text: context.appStrings!.resetPassword.toUpperCase(),
                        onPressed: _changePass,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
