import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/future_builder.dart';
import 'package:vayroll/widgets/widgets.dart';

class CertificationsTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CertificationsTabState();
}

class CertificationsTabState extends State<CertificationsTab> {
  final _refreshableKey = GlobalKey<RefreshableState>();
  Employee? _employee;

  Future _deleteCertificate(CertificateResponseDTO certificateInfo) async {
    certificateInfo.action = "DELETE";

    final deleteCertificateResponse = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().addUpdateDeleteCertificate(_employee!.id, certificateInfo),
    ))!;
    if (deleteCertificateResponse.status!) {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc: deleteCertificateResponse.message ?? " ",
      );
      _refreshableKey.currentState!.refresh();
    } else {
      await showCustomModalBottomSheet(
        context: context,
        desc: deleteCertificateResponse.message ?? " ",
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
                onPressed: () async => showCertificateRequestBottomSheet(context: context, employee: _employee),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              body: CustomScrollView(
                key: PageStorageKey<String>("CertificateScrollKey"),
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  CustomPagedSliverListView<CertificateResponseDTO>(
                    initPageFuture: (pageKey) async {
                      var dataResponse =
                          await ApiRepo().getCertificates(context.read<EmployeeProvider>().employee?.id, pageKey, 7);
                      return (dataResponse.result!.toPagedList() ?? []) as FutureOr<PagedList<CertificateResponseDTO>>;
                    },
                    itemBuilder: (context, item, index) {
                      return CertificateCard(
                        certificateInfo: item,
                        updateCertificate: () => showCertificateRequestBottomSheet(
                            context: context, employee: _employee, certificateInfo: item, update: true),
                        deleteCertificate: () => showConfirmationBottomSheet(
                          context: context,
                          desc: context.appStrings!.areYouSureYouWantToDeleteThisCertificate,
                          isDismissible: false,
                          onConfirm: () async {
                            Navigator.of(context).pop();
                            await _deleteCertificate(item);
                          },
                        ),
                        viewCertificate: () async {
                          if (imageExtensions.contains(item.attachment?.extension) ||
                              item.attachment?.extension == 'pdf') {
                            Navigation.navToViewCertificate(context, item.attachment);
                            return;
                          } else if (fileExtensions.contains(item.attachment?.extension)) {
                            final response = await ApiRepo().getFile(item.attachment?.id);
                            final String dir = (await getApplicationDocumentsDirectory()).path;
                            final String path = '$dir/${item.attachment?.name}';
                            final File file = File(path);
                            file.writeAsBytesSync(base64Decode(response.result!));
                            OpenFile.open("$path").then((value) async {
                              if (value.type == ResultType.noAppToOpen) setState(() {});
                              await showCustomModalBottomSheet(
                                context: context,
                                desc: value.message.substring(0, value.message.length - 1),
                              );
                            });
                          } else {
                            Navigation.navToViewCertificate(context, item.attachment);
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
