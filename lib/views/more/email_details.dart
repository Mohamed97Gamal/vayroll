import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/common.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/widgets/widgets.dart';

class EmailDetailsPage extends StatefulWidget {
  final EmailDTO? emailInfo;

  const EmailDetailsPage({Key? key, this.emailInfo}) : super(key: key);

  @override
  EmailDetailsPageState createState() => EmailDetailsPageState();
}

class EmailDetailsPageState extends State<EmailDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke2,
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_header(), _body(context)],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: TitleStacked(context.appStrings!.emailDetail, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _body(BuildContext context) {
    return CustomFutureBuilder<BaseResponse<EmailDTO>>(
      initFuture: () => ApiRepo().getEmailDetails(context.read<EmployeeProvider>().employee!.id, widget.emailInfo?.id),
      onSuccess: (context, snapshot) {
        EmailDTO? emailDetails = snapshot.data?.result;
        return Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.appStrings!.to,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontSize: 16, color: DefaultThemeColors.nepal),
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: 300, maxHeight: 30),
                          child: Text(
                            emailDetails?.recipients![0].name ?? "",
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Container(
                      constraints: BoxConstraints(maxWidth: 300, maxHeight: 30),
                      child: Text(
                        emailDetails?.recipients![0].email ?? "",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
                      ),
                    ),
                    trailing: Text(
                      dateFormat.format(widget.emailInfo!.sentDate!) ?? "",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(
                    height: 10,
                    thickness: 1,
                    color: DefaultThemeColors.whiteSmoke1,
                  ),
                  SizedBox(height: 16),
                  Text(
                    context.appStrings!.subject,
                    style:
                        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16, color: DefaultThemeColors.nepal),
                  ),
                  SizedBox(height: 8),
                  Text(
                    emailDetails?.subject ?? "",
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Divider(
                    height: 10,
                    thickness: 1,
                    color: DefaultThemeColors.whiteSmoke1,
                  ),
                  SizedBox(height: 16),
                  Text(
                    context.appStrings!.details,
                    style:
                        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16, color: DefaultThemeColors.nepal),
                  ),
                  Text(
                    emailDetails?.body ?? "",
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
                  ),
                  if (widget.emailInfo!.hasAttachment!) ...[
                    SizedBox(height: 16),
                    Divider(
                      height: 10,
                      thickness: 1,
                      color: DefaultThemeColors.whiteSmoke1,
                    ),
                    SizedBox(height: 16),
                    CustomFutureBuilder<BaseResponse<String>>(
                      initFuture: () => ApiRepo().getEmailFile(emailDetails?.attachment?.id),
                      onSuccess: (context, snapshot) {
                        String? photo = snapshot.data?.result;
                        emailDetails!.attachment!.content = photo;
                        return InkWell(
                          onTap: () async {
                            if (imageExtensions.contains(emailDetails.attachment?.extension) ||
                                emailDetails.attachment?.extension == 'pdf') {
                              Navigation.navToViewEmailAttach(context, emailDetails.attachment);
                              return;
                            } else if (fileExtensions.contains(emailDetails.attachment?.extension)) {
                              final response = await ApiRepo().getEmailFile(emailDetails.attachment?.id);
                              final String dir = (await getApplicationDocumentsDirectory()).path;
                              final String path = '$dir/${emailDetails.attachment?.name}';
                              final File file = File(path);
                              file.writeAsBytesSync(base64Decode(response.result!));
                              OpenFile.open("$path").then((value) async {
                                if (value.type == ResultType.noAppToOpen) {
                                  await showCustomModalBottomSheet(
                                    context: context,
                                    desc: value.message.substring(0, value.message.length - 1),
                                  );
                                }
                              });
                            } else {
                              Navigation.navToViewEmailAttach(context, emailDetails.attachment);
                            }
                          },
                          child: Text(
                            emailDetails.attachment!.name!,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption!.copyWith(decoration: TextDecoration.underline),
                          ),
                        );
                      },
                    )
                  ]
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
