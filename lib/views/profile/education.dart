import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class EducationTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EducationTabState();
}

class EducationTabState extends State<EducationTab> {
  final _refreshableKey = GlobalKey<RefreshableState>();

  Employee? _employee;

  Future _deleteEducation(EducationResponseDTO educationInfo) async {
    educationInfo.action = "DELETE";

    final deleteEducationResponse = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().addUpdateDeleteEducation(_employee!.id, educationInfo),
    ))!;
    if (deleteEducationResponse.status!) {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc: deleteEducationResponse.message ?? " ",
      );
      _refreshableKey.currentState!.refresh();
    } else {
      await showCustomModalBottomSheet(
        context: context,
        desc: deleteEducationResponse.message ?? " ",
      );
      _refreshableKey.currentState!.refresh();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Refreshable(
      key: _refreshableKey,
      child: RefreshIndicator(
        onRefresh: () async => _refreshableKey.currentState!.refresh(),
        child: CustomFutureBuilder<BaseResponse<Employee>>(
          initFuture: () async => context.read<EmployeeProvider>().get(force: true),
          onSuccess: (context, snapshot) {
            _employee = snapshot.data!.result;
            return Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: FloatingActionButton(
                onPressed: () async => showEducationRequestBottomSheet(context: context, employee: _employee),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              body: CustomScrollView(
                key: PageStorageKey<String>("EducationsScrollKey"),
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  CustomPagedSliverListView<EducationResponseDTO>(
                    initPageFuture: (pageKey) async {
                      var dataResponse =
                          await ApiRepo().getEducations(context.read<EmployeeProvider>().employee?.id, pageKey, 7);
                      return (dataResponse.result?.toPagedList() ?? []) as FutureOr<PagedList<EducationResponseDTO>>;
                    },
                    //noItemMainAxis: MainAxisAlignment.start,
                    itemBuilder: (context, item, index) {
                      return EducationCard(
                        educationInfo: item,
                        updateEducation: () =>
                            showEducationRequestBottomSheet(context: context, employee: _employee, educationInfo: item),
                        deleteEducation: () => showConfirmationBottomSheet(
                          context: context,
                          desc: context.appStrings!.areYouSureYouWantToDeleteThisEducation,
                          isDismissible: false,
                          onConfirm: () async {
                            Navigator.of(context).pop();
                            await _deleteEducation(item);
                          },
                        ),
                        viewCertificate: () async {
                          if (imageExtensions.contains(item.certificateFile?.extension) ||
                              item.certificateFile?.extension == 'pdf') {
                            Navigation.navToViewCertificate(context, item.certificateFile);
                            return;
                          } else if (fileExtensions.contains(item.certificateFile?.extension)) {
                            final response = await ApiRepo().getFile(item.certificateFile?.id);
                            final String dir = (await getApplicationDocumentsDirectory()).path;
                            final String path = '$dir/${item.certificateFile?.name}';
                            final File file = File(path);
                            file.writeAsBytesSync(base64Decode(response.result!));
                            await OpenFile.open("$path").then((value) async {
                              if (value.type == ResultType.noAppToOpen) setState(() {});
                              await showCustomModalBottomSheet(
                                context: context,
                                desc: value.message.substring(0, value.message.length - 1),
                              );
                            });
                          }
                        },
                      );
                    },
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 70),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
