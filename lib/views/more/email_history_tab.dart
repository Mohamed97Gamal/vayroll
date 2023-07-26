import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/logos.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/common.dart';
import 'package:vayroll/widgets/widgets.dart';

class EmailHistoryTab extends StatefulWidget {
  const EmailHistoryTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EmailHistoryTabState();
}

class EmailHistoryTabState extends State<EmailHistoryTab> {
  int? emailLength;

  @override
  Widget build(BuildContext context) {
    return _emaillist();
  }

  Widget _emaillist() {
    return CustomPagedListView<EmailDTO>(
      initPageFuture: (pageKey) async {
        var emailResult = await ApiRepo().getEmails(
          context.read<EmployeeProvider>().employee!.id,
          ["SENT"],
          pageIndex: pageKey,
          pageSize: pageSize,
        );
        emailLength = (emailLength ?? 0) + (emailResult.result?.records?.length ?? 0);
        return emailResult.result!.toPagedList();
      },
      itemBuilder: (context, item, index) {
        return Column(
          children: [
            _emailCard(item),
            if (emailLength != index + 1)
              Divider(
                height: 10,
                thickness: 1,
                indent: 60,
                color: DefaultThemeColors.whiteSmoke1,
              ),
          ],
        );
      },
    );
  }

  Widget _emailCard(EmailDTO emailInfo) {
    return ListTile(
      onTap: () => Navigation.navToEmailDetails(context, emailInfo),
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: DefaultThemeColors.whiteSmoke3,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 18,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(VPayLogos.logo),
          ),
        ),
      ),
      title: Container(
        constraints: BoxConstraints(maxHeight: 30),
        child: Text(
          emailInfo.recipients![0].name!.length > 20
              ? "${context.appStrings!.to}: ${emailInfo.recipients![0].name?.substring(0, 20) ?? ""}..."
              : "${context.appStrings!.to}: ${emailInfo.recipients![0].name ?? ""}",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Container(
        constraints: BoxConstraints(maxWidth: 200, maxHeight: 30),
        child: Text(
          emailInfo.subject ?? "",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Text(
        dateFormat.format(emailInfo.sentDate!) ?? "",
        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
      ),
    );
  }
}
