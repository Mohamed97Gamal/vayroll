import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/logos.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class ContactHRPage extends StatelessWidget {
  const ContactHRPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [_header(context), _list(context)],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: TitleStacked(context.appStrings!.contactHR, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _list(BuildContext context) {
    bool landscape = MediaQuery.of(context).orientation == Orientation.landscape;
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
          shrinkWrap: true,
          children: [
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0),
              child: landscape
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height*0.25,
                    child: SvgPicture.asset(
                        VPayLogos.logo_with_text,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                  )
                  : SvgPicture.asset(
                      VPayLogos.logo_with_text,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                context.appStrings!.getInTouchIfYouNeedAnyHelp,
                style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
            SizedBox(height: 24),
            CustomFutureBuilder<BaseResponse<List<HRContact>>>(
              initFuture: () => ApiRepo().getHRContacts(context.read<EmployeeProvider>().employee!.employeesGroup!.id),
              onSuccess: (context, snapshot) {
                var contacts = snapshot.data!.result;
                return contacts == null || contacts.isEmpty
                    ? Center(child: Text(context.appStrings!.noHRContactsFound))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: contacts.length,
                        itemBuilder: (context, i) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(18.0),
                                bottomLeft: Radius.circular(18.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  blurRadius: 6,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contacts[i].name!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                                ),
                                Text(
                                  contacts[i].position!,
                                  style:
                                      Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
                                ),
                                Divider(color: DefaultThemeColors.whiteSmoke1),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: Text("${context.appStrings!.phone}:"),
                                    ),
                                    InkWell(
                                      onTap: () => saveCall(
                                        context,
                                        contacts[i].contactNumber,
                                        recipient: Caller(
                                          name: "${contacts[i]?.employeesGroup?.name} ${context.appStrings!.hr}",
                                        ),
                                      ),
                                      child: Text(
                                        contacts[i].contactNumber!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(decoration: TextDecoration.underline),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: Text("${context.appStrings!.email}:"),
                                    ),
                                    InkWell(
                                      onTap: () => showEmailBottomSheet(
                                        context: context,
                                        toRecipients: [contacts[i].email],
                                        recipientType: RecipientType.hr,
                                      ),
                                      child: Text(
                                        contacts[i].email!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(decoration: TextDecoration.underline),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}
