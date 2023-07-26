import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class AnnouncementsPage extends StatefulWidget {
  AnnouncementsPage({Key? key}) : super(key: key);

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  @override
  Widget build(BuildContext context) {
    return Refreshable(
      child: RefreshIndicator(
        onRefresh: () async => context.read<KeyProvider>().announcementsListKey!.currentState!.refresh(),
        child: Scaffold(
          backgroundColor: DefaultThemeColors.whiteSmoke2,
          appBar: AppBar(
            leading: CustomBackButton(),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.0),
              _header(context),
              Expanded(
                child: Refreshable(
                  key: context.read<KeyProvider>().announcementsListKey,
                  child: CustomPagedListView<Announcement>(
                    initPageFuture: (pageKey) async {
                      var notificationResult = await ApiRepo()
                          .getUserAnnouncements(context.read<EmployeeProvider>().employee!.id, pageKey, pageSize);
                      return notificationResult.result!.toPagedList();
                    },
                    itemBuilder: (context, item, index) {
                      late var bytes;
                      if (item.attachment != null) {
                        bytes = Uint8List.fromList(item.attachment!.content!);
                      }
                      return InkWell(
                        onTap: () async {
                          await Navigation.navToAnnouncementDetails(context, item.id);
                          if (!item.isRead!) {
                            setState(() {
                              item.isRead = true;
                            });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          height: 97,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                child: Container(
                                  width: 31,
                                  height: double.maxFinite,
                                  color:
                                      item.isRead! ? DefaultThemeColors.nepal : Theme.of(context).colorScheme.secondary,
                                  child: SvgPicture.asset(
                                    item.isRead! ? VPayIcons.eye : VPayIcons.announcement,
                                    fit: BoxFit.none,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        item.title ?? "",
                                        style: Theme.of(context).textTheme.subtitle1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        item.text ?? "",
                                        style: (item.isRead ?? false)
                                            ? TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: Fonts.brandon,
                                                color: DefaultThemeColors.nepal,
                                              )
                                            : TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: Fonts.brandon,
                                                color: DefaultThemeColors.nepal,
                                              ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              if (item.attachment != null) ...[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 97,
                                    height: 84,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: Image.memory(
                                      bytes,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: TitleStacked(context.appStrings!.announcements, DefaultThemeColors.prussianBlue),
    );
  }
}
