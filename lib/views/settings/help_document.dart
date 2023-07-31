import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/common.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/pagination/custom_paged_list_view.dart';
import 'package:vayroll/widgets/widgets.dart';

class HelpDucomentsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HelpDucomentsPageState();
}

class HelpDucomentsPageState extends State<HelpDucomentsPage> {
  int? helpDocumentsLength;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke3,
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: DefaultThemeColors.whiteSmoke3,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _header(),
          _ducomentList(),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: TitleStacked(
        context.appStrings!.helpDocuments,
        Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _ducomentList() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: CustomPagedListView<Attachment>(
          initPageFuture: (pageKey) async {
            var documentsResponse = await ApiRepo().getHelpdocuments(
              pageIndex: pageKey,
              pageSize: pageSize,
            );
            helpDocumentsLength = (helpDocumentsLength ?? 0) +
                (documentsResponse.result?.records?.length ?? 0);
            return documentsResponse.result!.toPagedList();
          },
          itemBuilder: (context, item, index) {
            return Column(
              children: [
                _decomentCard(item),
                if (helpDocumentsLength != index + 1)
                  Divider(
                    height: 10,
                    thickness: 1,
                    indent: 60,
                    color: DefaultThemeColors.whiteSmoke1,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _decomentCard(Attachment attach) {
    return ListTile(
      onTap: () async {
        if (imageExtensions.contains(attach.extension) ||
            attach.extension == 'pdf') {
          Navigation.navToViewDocument(context, attach);
          return;
        } else if (fileExtensions.contains(attach.extension)) {
          var response =
              (await showFutureProgressDialog<BaseResponse<List<int>>>(
            context: context,
            initFuture: () => ApiRepo().getHelpDocumentAttachment(attach.id),
          ))!;

          if (response.status!) {
            final String dir = (await getApplicationDocumentsDirectory()).path;
            final String path = '$dir/${attach.name}+.${attach.extension}';
            final File file = File(path);
            file.writeAsBytesSync(response.result!);
            OpenFile.open("$path").then((value) async {
              if (value.type == ResultType.noAppToOpen)
                setState(() async {
                  await showCustomModalBottomSheet(
                    context: context,
                    desc: value.message.substring(0, value.message.length - 1),
                  );
                });
            });
          } else {
            await showCustomModalBottomSheet(
              context: context,
              desc: response.message,
            );
            return;
          }
        } else {
          Navigation.navToViewDocument(context, attach);
        }
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child:
            SvgPicture.asset(getDecomentIcon(attach.extension?.toLowerCase())),
      ),
      title: Text(
        attach.name ?? "",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.normal,
            ),
      ),
    );
  }
}
