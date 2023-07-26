import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/widgets.dart';

class AboutCompanyCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<BaseResponse<Company>>(
      initFuture: () => ApiRepo().getCompanyInfo(context.read<EmployeeProvider>().employee!.employeesGroup!.id),
      onSuccess: (context, snapshot) {
        Company? companyInfo = snapshot.data!.result;
        return companyInfo == null || companyInfo.name!.isEmpty
            ? Container()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 12),
                          AvatarFutureBuilder<BaseResponse<String>>(
                            initFuture: () => ApiRepo().getFile(companyInfo?.logo?.id),
                            onSuccess: (context, snapshot) {
                              String? photo = snapshot?.data?.result;
                              return _profilePhoto(photo);
                            },
                          ),
                          SizedBox(height: 8),
                          Container(
                            constraints: BoxConstraints(maxHeight: 30),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              companyInfo.name??"",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 22, height: 1.2),
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(maxHeight: 30),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              companyInfo?.companyEmail ?? "",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontSize: 16, color: DefaultThemeColors.nepal, height: 1.2),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            constraints: BoxConstraints(maxHeight: 90),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "${companyInfo?.address ?? ""} \n ${companyInfo?.phone ?? ""}",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 18, height: 1.2),
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  aboutCompanyDesc(companyInfo, context),
                ],
              );
      },
    );
  }

  Widget _profilePhoto(String? photo) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 52,
            child: ClipOval(
              child: photo != null
                  ? Image.memory(
                      base64Decode(photo),
                      fit: BoxFit.cover,
                      width: 104.0,
                      height: 104.0,
                    )
                  : Image.asset(
                      VPayImages.avatar,
                      fit: BoxFit.cover,
                      width: 104.0,
                      height: 104.0,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget aboutCompanyDesc(Company? companyInfo, BuildContext context) {
    return Card(
      elevation: 0,
      color: DefaultThemeColors.antiFlashWhite,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
      child: Container(
        // height: 100,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: DefaultThemeColors.antiFlashWhite,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Text(
                    "About ${companyInfo?.name} ",
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () => Navigation.navToAboutCompanyDesc(context, companyInfo),
                  child: Text(
                    "Read More",
                    style:
                        Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).colorScheme.secondary),
                  ),
                )
              ],
            ),
            SizedBox(height: 8),
            Container(
              constraints: BoxConstraints(maxHeight: 50),
              child: Text(
                companyInfo?.aboutEntity ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
