import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke2,
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            _body(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: TitleStacked(context.appStrings!.supportContact, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _body(BuildContext context) {
    return CustomFutureBuilder<BaseResponse<SupportContacts>>(
      initFuture: () => ApiRepo().getSupportContacts(),
      onSuccess: (context, snapshot) {
        SupportContacts? supportInfo = snapshot.data!.result;
        return supportInfo == null
            ? Container()
            : ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  if (supportInfo.phone?.isNotEmpty ?? false)
                    _contactWidget(
                      context,
                      VPayIcons.contacts_call,
                      context.appStrings!.callUs,
                      supportInfo?.workingHours,
                      context.appStrings!.callNow,
                      () => saveCall(
                        context,
                        supportInfo.phone,
                        recipient: Caller(
                          name:
                              "${context.read<EmployeeProvider>().employee!.employeesGroup!.name} ${context.appStrings!.support}",
                        ),
                      ),
                    ),
                  SizedBox(height: 30),
                  if (supportInfo.email?.isNotEmpty ?? false)
                    _contactWidget(
                      context,
                      VPayIcons.contacts_email,
                      context.appStrings!.emailUs,
                      context.appStrings!.youWillHearBackUsFromWithinTwentyFourHrs,
                      context.appStrings!.sendAnEmail,
                      () => showEmailBottomSheet(
                        context: context,
                        toRecipients: [supportInfo.email],
                        recipientType: RecipientType.emp,
                      ),
                    ),
                ],
              );
      },
    );
  }

  Widget _contactWidget(BuildContext context, String icon, title, desc, buttonTitle, Function ontap) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 6,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset(icon),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              desc ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(fontWeight: FontWeight.normal, color: DefaultThemeColors.nepal),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomElevatedButton(
              text: buttonTitle.toUpperCase(),
              onPressed: ontap as void Function()?,
            ),
          ),
        ],
      ),
    );
  }
}
