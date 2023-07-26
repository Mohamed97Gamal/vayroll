import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class DocumentRequestsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DocumentRequestsPageState();
}

class DocumentRequestsPageState extends State<DocumentRequestsPage> {
  String? _status;
  bool _filterVisiable = false;

  int? documentsLength;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultThemeColors.whiteSmoke2,
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: DefaultThemeColors.whiteSmoke2,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [_header(context), _list(context)],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: TitleStacked(
          context.appStrings!.requests, DefaultThemeColors.prussianBlue),
    );
  }

  Widget _list(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            FilterRequestsWidget(
              filterVisiable: _filterVisiable,
              status: _status,
              ontap: () => setState(() => _filterVisiable = !_filterVisiable),
              onStatusChange: (value) => setState(() {
                _status = value;
                context
                    .read<KeyProvider>()
                    .documentRequestrefreshableKey!
                    .currentState!
                    .refresh();
              }),
            ),
            Expanded(
              child: Refreshable(
                key: context.read<KeyProvider>().documentRequestrefreshableKey,
                child: CustomPagedListView<MyRequestsResponseDTO>(
                  initPageFuture: (pageKey) async {
                    var requestResult = await ApiRepo().getActiveRequests(
                      RequestKind.ducoment,
                      pageIndex: pageKey,
                      pageSize: pageSize,
                      requestStatus: _status?.isNotEmpty == true &&
                              _status!.toUpperCase() != "ALL"
                          ? [_status!.toUpperCase()]
                          : [],
                    );
                    documentsLength = (documentsLength ?? 0) +
                        (requestResult.result?.records?.length ?? 0);
                    return requestResult.result!.toPagedList();
                  },
                  itemBuilder: (context, item, index) {
                    return Column(
                      children: [
                        ProfileRequestCard(
                          profileRequestInfo: item,
                          refreshableKey: context
                              .read<KeyProvider>()
                              .documentRequestrefreshableKey,
                          removeSubString: true,
                        ),
                        if (documentsLength != index + 1)
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
            ),
          ],
        ),
      ),
    );
  }
}
