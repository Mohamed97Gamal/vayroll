import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/common.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:provider/provider.dart';

class CallHistoryTab extends StatefulWidget {
  const CallHistoryTab({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => CallHistoryTabState();
}

class CallHistoryTabState extends State<CallHistoryTab> {
  int? callLength;

  @override
  Widget build(BuildContext context) {
    return _callist();
  }

  Widget _callist() {
    return CustomPagedListView<Call>(
      initPageFuture: (pageKey) async {
        var callResult = await ApiRepo().callHistory(
          context.read<EmployeeProvider>().employee!.id,
          pageIndex: pageKey,
          pageSize: pageSize,
        );
        callLength = (callLength ?? 0) + (callResult?.result?.records?.length ?? 0);
        return callResult.result!.toPagedList();
      },
      itemBuilder: (context, item, index) {
        return Column(
          children: [
            _callCard(item),
            if (callLength != index + 1)
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

  Widget _callCard(Call callInfo) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      leading: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(150),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(VPayIcons.ongoingCalls),
        ),
      ),
      title: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 120, maxHeight: 30),
        child: Text(
          callInfo?.recipient?.name ?? callInfo.phoneNumber!,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18),
        ),
      ),
      subtitle: Container(
        constraints: BoxConstraints(maxWidth: 200, maxHeight: 30),
        child: Text(
          dateFormat.format(callInfo.startedAt!),
          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
        ),
      ),
      trailing: Container(
        width: 80,
        constraints: BoxConstraints(maxWidth: 80, maxHeight: 30),
        child: Text(
          timeFormat.format(callInfo.startedAt!),
          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
        ),
      ),
    );
  }
}
