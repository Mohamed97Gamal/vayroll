import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

class WorkExperienceTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WorkExperienceTabState();
}

class WorkExperienceTabState extends State<WorkExperienceTab> {
  final _refreshableKey = GlobalKey<RefreshableState>();
  Employee? _employee;

  Future _deleteExperience(ExperiencesResponseDTO experienceInfo) async {
    experienceInfo.action = "DELETE";

    final deleteExperienceResponse = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().addUpdateDeleteExperience(_employee!.id, experienceInfo),
    ))!;
    if (deleteExperienceResponse.status!) {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc: deleteExperienceResponse.message ?? " ",
      );
      _refreshableKey.currentState!.refresh();
    } else {
      await showCustomModalBottomSheet(
        context: context,
        desc: deleteExperienceResponse.message ?? " ",
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
                onPressed: () async => showWorkExpernceRequestBottomSheet(context: context, employee: _employee),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              body: CustomScrollView(
                key: PageStorageKey<String>("WorkExperienceScrollKey"),
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  CustomPagedSliverListView<ExperiencesResponseDTO>(
                    initPageFuture: (pageKey) async {
                      var dataResponse =
                          await ApiRepo().getExperiences(context.read<EmployeeProvider>().employee?.id, pageKey, 7);
                      return (dataResponse.result!.toPagedList() ?? []) as FutureOr<PagedList<ExperiencesResponseDTO>>;
                    },
                    itemBuilder: (context, item, index) {
                      return WorkExperinceCard(
                        experienceInfo: item,
                        updateExperince: () => showWorkExpernceRequestBottomSheet(
                            context: context, employee: _employee, experienceInfo: item, update: true),
                        deleteExperince: () => showConfirmationBottomSheet(
                          context: context,
                          desc: context.appStrings!.areYouSureYouWantToDeleteThisWorkExperience,
                          isDismissible: false,
                          onConfirm: () async {
                            Navigator.of(context).pop();
                            await _deleteExperience(item);
                          },
                        ),
                        viewCertificate: () async {
                          if (imageExtensions.contains(item.experienceCertificate?.extension) ||
                              item.experienceCertificate?.extension == 'pdf') {
                            Navigation.navToViewCertificate(context, item.experienceCertificate);
                            return;
                          } else if (fileExtensions.contains(item.experienceCertificate?.extension)) {
                            final response = await ApiRepo().getFile(item.experienceCertificate?.id);
                            final String dir = (await getApplicationDocumentsDirectory()).path;
                            final String path = '$dir/${item.experienceCertificate?.name}';
                            final File file = File(path);
                            file.writeAsBytesSync(base64Decode(response.result!));
                            OpenFile.open("$path").then((value) async {
                              if (value.type == ResultType.noAppToOpen)
                                setState(() async {
                                  await showCustomModalBottomSheet(
                                    context: context,
                                    desc: value.message.substring(0, value.message.length - 1),
                                  );
                                });
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
