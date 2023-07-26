import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/decidable_request/decidable_request_card.dart';
import 'package:vayroll/widgets/widgets.dart';

class DecidableRequestProfileTab extends StatefulWidget {
  @override
  _DecidableRequestProfileTabState createState() => _DecidableRequestProfileTabState();
}

class _DecidableRequestProfileTabState extends State<DecidableRequestProfileTab> {
  late DateTime fromDate;
  late DateTime toDate;
  bool showFilter = false;

  int? profileDecidable;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    fromDate = DateTime(now.year, now.month-1, now.day);
    toDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: SizedBox(
              height: 48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (showFilter) ...[
                    Expanded(
                      flex: 3,
                      child: InnerTextFormField(
                        hintText: context.appStrings!.from,
                        textAlignVertical: TextAlignVertical.bottom,
                        controller: TextEditingController(text: dateFormat.format(fromDate)),
                        readOnly: true,
                        suffixIcon: SvgPicture.asset(
                          VPayIcons.calendar,
                          fit: BoxFit.none,
                          alignment: Alignment.center,
                        ),
                        onTap: () async {
                          final result = await showDatePicker(
                              context: context,
                              initialDate: fromDate,
                              firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
                              lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light().copyWith(
                                      primary: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  child: child!,
                                );
                              });
                          if (result == null) return;
                          setState(() {
                            fromDate = result;
                            if (result.isAfter(toDate))
                              toDate = DateTime(result.year, result.month, result.day, 23, 59, 59);
                          });
                          context.read<KeyProvider>().decidableProfileKey!.currentState!.refresh();
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: InnerTextFormField(
                        hintText: context.appStrings!.to,
                        textAlignVertical: TextAlignVertical.bottom,
                        controller: TextEditingController(text: dateFormat.format(toDate)),
                        readOnly: true,
                        suffixIcon: SvgPicture.asset(
                          VPayIcons.calendar,
                          fit: BoxFit.none,
                          alignment: Alignment.center,
                        ),
                        onTap: () async {
                          final result = await showDatePicker(
                              context: context,
                              initialDate: toDate,
                              firstDate: fromDate,
                              lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light().copyWith(
                                      primary: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  child: child!,
                                );
                              });
                          if (result == null) return;
                          setState(() => toDate = DateTime(result.year, result.month, result.day, 23, 59, 59));
                          context.read<KeyProvider>().decidableProfileKey!.currentState!.refresh();
                        },
                      ),
                    ),
                  ],
                  Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => showFilter = !showFilter),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: showFilter ? DefaultThemeColors.lightCyan : Colors.transparent,
                      ),
                      child: SvgPicture.asset(
                        VPayIcons.filter,
                        fit: BoxFit.none,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Refreshable(
              key: context.read<KeyProvider>().decidableProfileKey,
              child: CustomPagedListView<MyRequestsResponseDTO>(
                initPageFuture: (pageKey) async {
                  var decidableResult = await ApiRepo().getDecidableRequests(
                    approver: true,
                    requestKind: [RequestKind.profileUpdate],
                    requestStatus: [RequestStatus.statusSubmitted],
                    fromSubmissionDate: fromDate.toString(),
                    toSubmissionDate: toDate.toString(),
                    pageIndex: pageKey,
                    pageSize: pageSize,
                  );
                  profileDecidable = (profileDecidable ?? 0) + (decidableResult?.result?.records?.length ?? 0);
                  return decidableResult.result!.toPagedList();
                },
                itemBuilder: (context, item, index) {
                  return DecidableRequestCard(
                    myRequestsResponseDTO: item,
                    refreshableKey: context.read<KeyProvider>().decidableProfileKey,
                    totalLength: profileDecidable,
                    index: index,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
