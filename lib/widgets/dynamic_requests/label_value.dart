import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/bottom_sheet.dart';

class LabelValueWidget extends StatelessWidget {
  final String? label;
  final String? value;
  final Attachment? attach;

  const LabelValueWidget({
    Key? key,
    required this.label,
    required this.value,
    this.attach,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label ?? "",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: attach != null
                  ? () async {
                      if (imageExtensions.contains(attach?.extension) || (attach?.extension == 'pdf')) {
                        Navigation.navToViewCertificate(context, (attach));
                        return;
                      } else if (fileExtensions.contains(attach?.extension)) {
                        final response = await ApiRepo().getFile(attach?.id);
                        final String dir = (await getApplicationDocumentsDirectory()).path;
                        final String path = '$dir/${attach?.name}';
                        final File file = File(path);
                        file.writeAsBytesSync(base64Decode(response.result!));
                        await OpenFile.open("$path").then((value) async {
                          if (value.type == ResultType.noAppToOpen)
                            //setState(() {
                            await showCustomModalBottomSheet(
                              context: context,
                              desc: value.message.substring(0, value.message.length - 1),
                            );
                          // });
                        });
                      }
                    }
                  : null,
              child: Text(
                attach?.name ?? value ?? "",
                style: attach?.name?.isNotEmpty == true
                    ? Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          decoration: TextDecoration.underline,
                        )
                    : Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
