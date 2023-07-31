import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/views/more/appeal_manager/appeal_manager.dart';
import 'package:vayroll/widgets/widgets.dart';

import 'avatar_future_builder.dart';

class AppealNoteListTile extends StatelessWidget {
  final Lock? lock;
  final HashMap<String?, EmployeeWithImage>? employeeCache;
  final AppealNote? note;
  final String? currentUserId;
  final Uint8List? currentUserPhotoBytes;
  final Function? onUserNoteLongPress;
  final EmployeeInfo? employee;

  const AppealNoteListTile({
    Key? key,
    this.lock,
    this.employeeCache,
    this.note,
    this.currentUserId,
    this.currentUserPhotoBytes,
    this.onUserNoteLongPress,
    this.employee,
  }) : super(key: key);

  _onAttachmentTapped(BuildContext context) async {
    var response = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().getFile(note!.attachment!.id),
    ))!;

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/${note!.attachment!.name}';
    final File file = File(path);
    file.writeAsBytesSync(base64Decode(response.result!));
    await OpenFile.open("$path").then((value) async {
      if (value.type == ResultType.noAppToOpen)
        await showCustomModalBottomSheet(
          context: context,
          desc: value.message.substring(0, value.message.length - 1),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == note!.submitterId) {
      return _userNote(context, note!, currentUserPhotoBytes);
    }

    return _othersNote(context, note!);
  }

  Widget _userNote(BuildContext context, AppealNote appealNote, Uint8List? photoBytes) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacer(),
        GestureDetector(
          onLongPress: onUserNoteLongPress as void Function()?,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 120),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DefaultThemeColors.aliceBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(1),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      appealNote.note!,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  if (appealNote.attachment != null) ...[
                    SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        _onAttachmentTapped(context);
                      },
                      child: Tooltip(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        preferBelow: false,
                        message: appealNote.attachment!.name,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Transform.rotate(
                            angle: -pi / 4,
                            child: Icon(
                              Icons.attachment,
                              color: DefaultThemeColors.prussianBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.transparent,
          backgroundImage: (photoBytes != null ? MemoryImage(photoBytes) : AssetImage(VPayImages.avatar)) as ImageProvider<Object>?,
        )
      ],
    );
  }

  Widget _othersNote(BuildContext context, AppealNote appealNote) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (appealNote?.submitterPhotoId?.isNotEmpty ?? false) ...[
          AvatarFutureBuilder<Uint8List?>(
            initFuture: () async {
              if (employeeCache!.containsKey(appealNote.submitterId)) {
                return employeeCache![appealNote.submitterId]!.image;
              }
              return await lock!.synchronized(() async {
                if (employeeCache!.containsKey(appealNote.submitterId)) {
                  return employeeCache![appealNote.submitterId]!.image;
                }
                var baseInfo = await ApiRepo().getEmployeeInfo(userId: appealNote?.submitterId);
                var image = await ApiRepo().getFile(appealNote?.submitterPhotoId);
                var bytes = base64Decode(image.result!);
                employeeCache!.putIfAbsent(
                  appealNote.submitterId,
                  () => EmployeeWithImage(baseInfo.result, bytes),
                );
                return bytes;
              });
            },
            onSuccess: (context, snapshot) {
              final photoBytes = snapshot.data;
              return Tooltip(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                preferBelow: false,
                message: appealNote.submitterName,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.transparent,
                  backgroundImage: (photoBytes != null ? MemoryImage(photoBytes) : AssetImage(VPayImages.avatar)) as ImageProvider<Object>?,
                ),
              );
            },
          ),
        ] else
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(VPayImages.avatar),
          ),
        SizedBox(width: 12),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 120),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DefaultThemeColors.aliceBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(1),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    appealNote.note!,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                if (appealNote.attachment != null) ...[
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      _onAttachmentTapped(context);
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Transform.rotate(
                        angle: -pi / 4,
                        child: Icon(
                          Icons.attachment,
                          color: DefaultThemeColors.prussianBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
