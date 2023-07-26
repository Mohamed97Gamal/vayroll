import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final formKey = GlobalKey<FormState>();
  FocusNode? newPassFocusNode, confirmPassFocusNode;

  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  String? currentPassword;
  String? newPassword;

  @override
  void initState() {
    super.initState();
    newPassFocusNode = FocusNode();
    confirmPassFocusNode = FocusNode();
  }

  void _changePassword() async {
    final FormState form = formKey.currentState!;
    if (!form.validate()) return;

    form.save();
    final response = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().changePassword(currentPassword, newPassword),
    ))!;

    if (response.status!) {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc:
            response.message ?? context.appStrings!.passwordChangedSuccessfully,
      );
      Navigator.of(context).popUntil((route) => route.isFirst == true);
    } else {
      await showCustomModalBottomSheet(
        context: context,
        desc: response.message ?? context.appStrings!.changePasswordFailed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          _form(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 15, bottom: 15),
        child: TitleStacked(
            context.appStrings!.changePassword, DefaultThemeColors.prussianBlue),
      );

  Widget _form(BuildContext context) => Expanded(
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            children: [
              InnerTextFormField(
                label: context.appStrings!.currentPassword,
                hintText: "••••••••",
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      showCurrentPassword = !showCurrentPassword;
                    });
                  },
                  child: SvgPicture.asset(
                    showCurrentPassword
                        ? VPayIcons.visibility_on
                        : VPayIcons.visibility_off,
                    color: Theme.of(context).primaryColor,
                    fit: BoxFit.none,
                  ),
                ),
                textInputAction: TextInputAction.next,
                obscureText: !showCurrentPassword,
                inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                onFieldSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(newPassFocusNode),
                onChanged: (value) => currentPassword = value,
                validator: (value) =>
                    Validation().checkPassword(value, context),
              ),
              SizedBox(height: 24),
              InnerTextFormField(
                label: context.appStrings!.newPassword,
                hintText: "••••••••",
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      showNewPassword = !showNewPassword;
                    });
                  },
                  child: SvgPicture.asset(
                    showNewPassword
                        ? VPayIcons.visibility_on
                        : VPayIcons.visibility_off,
                    color: Theme.of(context).primaryColor,
                    fit: BoxFit.none,
                  ),
                ),
                textInputAction: TextInputAction.next,
                obscureText: !showNewPassword,
                inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                focusNode: newPassFocusNode,
                onFieldSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(confirmPassFocusNode),
                onChanged: (value) => newPassword = value,
                validator: (value) {
                  var result = Validation().checkPassword(value, context);
                  if (result != null) return result;
                  if (currentPassword == newPassword)
                    return context.appStrings!.newPasswordValidation;
                  return null;
                },
              ),
              SizedBox(height: 24),
              InnerTextFormField(
                label: context.appStrings!.confirmPassword,
                hintText: "••••••••",
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      showConfirmPassword = !showConfirmPassword;
                    });
                  },
                  child: SvgPicture.asset(
                    showConfirmPassword
                        ? VPayIcons.visibility_on
                        : VPayIcons.visibility_off,
                    color: Theme.of(context).primaryColor,
                    fit: BoxFit.none,
                  ),
                ),
                textInputAction: TextInputAction.done,
                obscureText: !showConfirmPassword,
                inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                focusNode: confirmPassFocusNode,
                validator: (value) => value!.isEmpty
                    ? context.appStrings!.requiredField
                    : value != newPassword
                        ? context.appStrings!.passwordDoNotMatch
                        : null,
              ),
              SizedBox(height: 48),
              CustomElevatedButton(
                  text: context.appStrings!.submit, onPressed: _changePassword,),
            ],
          ),
        ),
      );
}
