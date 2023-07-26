import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/appeal_request/avatar_future_builder.dart';

class HeaderNoteOther extends StatelessWidget {
  final Appeal? appealDetails;
  final String? employeePhotoId;

  const HeaderNoteOther({
    Key? key,
    this.appealDetails,
    this.employeePhotoId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((employeePhotoId)?.isNotEmpty == true) ...[
          AvatarFutureBuilder<BaseResponse<String>>(
            initFuture: () => ApiRepo().getFile(employeePhotoId),
            onSuccess: (context, snapshot) {
              var employeePhotoBase64 = snapshot.data!.result;
              return CircleAvatar(
                radius: 16,
                backgroundColor: Colors.transparent,
                backgroundImage: (employeePhotoBase64 != null
                    ? MemoryImage(base64Decode(employeePhotoBase64))
                    : AssetImage(VPayImages.avatar)) as ImageProvider<Object>?,
              );
            },
          ),
        ] else
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(VPayImages.avatar),
          ),
        SizedBox(width: 12),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 120),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DefaultThemeColors.whiteSmoke1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(1),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                appealDetails!.entityReferenceNumber ?? "",
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateFormat.format(appealDetails!.submissionDate!) ?? "",
                      style: Theme.of(context).textTheme.bodyText2),
                  Row(
                    children: [
                      Text(
                        'Submitted to HR Manager',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
                      ),
                      SizedBox(width: 8),
                      appealDetails!.submittedToHrManager!
                          ? Icon(Icons.check, color: DefaultThemeColors.mantis)
                          : Icon(Icons.close, color: DefaultThemeColors.red),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Submitted to Line Manager',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
                      ),
                      SizedBox(width: 8),
                      appealDetails!.submittedToLineManager!
                          ? Icon(Icons.check, color: DefaultThemeColors.mantis)
                          : Icon(Icons.close, color: DefaultThemeColors.red),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
