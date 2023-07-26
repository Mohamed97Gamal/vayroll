import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/models/announcement/notificationModel.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class NotificationDetailsPage extends StatefulWidget {
  final NotificationModel? notification;
  final bool isDeepLinking;

  const NotificationDetailsPage({Key? key, this.notification, this.isDeepLinking = false}) : super(key: key);

  @override
  _NotificationDetailsPageState createState() => _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  String? _employeeId;

  void _markNotificationAsRead(String? employeeId) {
    ApiRepo().markNotificationAsRead(notificationId: widget.notification!.id, employeeId: employeeId);
  }

  @override
  void initState() {
    super.initState();
    _employeeId = context.read<EmployeeProvider>().employee?.id;
    _markNotificationAsRead(_employeeId);
    Future.microtask(
      () {
        context.read<KeyProvider>().homeNotificationsNotifier.refresh();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(
          onPressed: widget.isDeepLinking
              ? () async {
                  context.read<KeyProvider>().notificationListKey!.currentState!.refresh();
                  Navigator.pop(context);
                }
              : null,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_header(context), _list(context, widget.notification!)],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: TitleStacked(context.appStrings!.notification, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _list(BuildContext context, NotificationModel notification) {
    late var bytes;
    if (notification.image != null) {
      bytes = Uint8List.fromList(notification.image!.content!);
    }
    Map? content;
    Map valueMap = json.decode(notification.data!);
    String? contentString = valueMap['content'];
    if (contentString != null && contentString.isNotEmpty) {
      content = json.decode(contentString);
    }
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    notification.title!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 16),
                  if (notification.image != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                        bytes,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (notification.imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        notification.imageUrl!,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  SizedBox(height: 16),
                  contentString != null && contentString.isNotEmpty
                      ? Table(
                          border: TableBorder(
                              horizontalInside: BorderSide(
                                  width: 2, color: DefaultThemeColors.whiteSmoke1, style: BorderStyle.solid)),
                          children: [
                            for (int i = 0; i < content!.length; i++)
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        content.keys.elementAt(i),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(color: DefaultThemeColors.nepal),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        content.values.elementAt(i),
                                        style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                          ],
                        )
                      : Text(
                          notification.body!,
                          style: notification.isRead!
                              ? TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: Fonts.brandon,
                                  color: DefaultThemeColors.nepal,
                                )
                              : TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: Fonts.brandon,
                                  color: DefaultThemeColors.nepal,
                                ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                  contentString != null && contentString.isNotEmpty
                      ? Divider(height: 1, thickness: 2, color: DefaultThemeColors.whiteSmoke1)
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/*Table(
                          border: TableBorder(
                              horizontalInside: BorderSide(
                                  width: 2, color: DefaultThemeColors.whiteSmoke1, style: BorderStyle.solid)),
                          children: [
                            for (int i = 0; i < content.length; i++)
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        content.keys.elementAt(i),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(color: DefaultThemeColors.nepal),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        content.values.elementAt(i),
                                        style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                          ],
                        ),*/
