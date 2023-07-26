import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';

class HeaderNoteUser extends StatelessWidget {
  final Appeal? appealDetails;
  final Uint8List? employeePhotoBytes;

  const HeaderNoteUser({
    Key? key,
    this.appealDetails,
    this.employeePhotoBytes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacer(),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 120),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DefaultThemeColors.whiteSmoke1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(1),
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
        SizedBox(width: 12),
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.transparent,
          backgroundImage: (employeePhotoBytes != null ? MemoryImage(employeePhotoBytes!) : AssetImage(VPayImages.avatar)) as ImageProvider<Object>?,
        )
      ],
    );
  }
}
