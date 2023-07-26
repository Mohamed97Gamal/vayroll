import 'dart:convert';
import 'package:vayroll/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/widgets.dart';

class AboutCompanyDescPage extends StatefulWidget {
  final Company? companyInfo;

  const AboutCompanyDescPage({Key? key, this.companyInfo}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AboutCompanyDescPageState();
}

class AboutCompanyDescPageState extends State<AboutCompanyDescPage> {
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          companyCard(),
          desc(),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: TitleStacked(context.appStrings!.aboutCompany, Theme.of(context).primaryColor),
    );
  }

  Widget companyCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: AvatarFutureBuilder<BaseResponse<String>>(
              initFuture: () => ApiRepo().getFile(widget?.companyInfo?.logo?.id),
              onSuccess: (context, snapshot) {
                String? photo = snapshot?.data?.result;
                return _profilePhoto(photo);
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxHeight: 30),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget?.companyInfo?.companyEmail ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontSize: 16, color: DefaultThemeColors.nepal, height: 1.2),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "${widget?.companyInfo?.address ?? ""} ",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 18, height: 1.2),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  constraints: BoxConstraints(maxHeight: 30),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget?.companyInfo?.phone ?? "",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 18, height: 1.2),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _profilePhoto(String? photo) {
    return CircleAvatar(
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
    );
  }

  Widget desc() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 200),
              child: Text(
                "${context.appStrings!.about} ${widget?.companyInfo?.name}",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            SizedBox(height: 12),
            Text(
              widget?.companyInfo?.aboutEntity ?? "",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
