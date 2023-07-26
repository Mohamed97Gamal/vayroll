import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class DepartmentEmpCradWidget extends StatelessWidget {
  final Employee? empInfo;

  const DepartmentEmpCradWidget({Key? key, this.empInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (empInfo?.photo?.id != null)
                AvatarFutureBuilder<BaseResponse<String>>(
                  initFuture: () => ApiRepo().getFile(empInfo?.photo?.id),
                  onLoading: (context) => CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary),
                  onSuccess: (context, snapshot) {
                    String? photo = snapshot?.data?.result;
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            (photo != null ? MemoryImage(base64Decode(photo)) : AssetImage(VPayImages.avatar)) as ImageProvider<Object>?,
                      ),
                    );
                  },
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(VPayImages.avatar),
                  ),
                ),
              Container(
                constraints: BoxConstraints(maxWidth: 150, maxHeight: 20),
                child: Text(
                  empInfo?.fullName ?? "",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14),
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 150, maxHeight: 20),
                child: Text(
                  empInfo?.position?.name ?? "",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 11, color: DefaultThemeColors.nepal),
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => saveCall(
                      context,
                      empInfo?.contactNumber,
                      recipient: Caller(
                        employeeId: empInfo?.id,
                        name: empInfo?.fullName,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: DefaultThemeColors.mayaBlue,
                      child: SvgPicture.asset(
                        VPayIcons.contacts_call,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  InkWell(
                    onTap: () => showEmailBottomSheet(
                      context: context,
                      toRecipients: [empInfo?.email],
                      recipientType: RecipientType.emp,
                    ),
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: SvgPicture.asset(
                        VPayIcons.Subscribe,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
