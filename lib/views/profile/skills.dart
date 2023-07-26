import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class SkillsTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SkillsTabState();
}

class SkillsTabState extends State<SkillsTab> {
  final _refreshableKey = GlobalKey<RefreshableState>();
  List<SkillsResponseDTO>? skills;
  Employee? _employee;

  Future _deleteSkill(SkillsResponseDTO skill) async {
    skill.action = "DELETE";

    final deleteSkillResponse = (await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().addUpdateDeleteSkill(_employee!.id, skill),
    ))!;
    if (deleteSkillResponse.status!) {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: false,
        desc: deleteSkillResponse.message ?? " ",
      );
      _refreshableKey.currentState!.refresh();
    } else {
      await showCustomModalBottomSheet(
        context: context,
        desc: deleteSkillResponse.message ?? " ",
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
                onPressed: () => showSkillRequestBottomSheet(context: context, employee: _employee),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              body: CustomScrollView(
                key: PageStorageKey<String>("SkillsScrollKey"),
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  CustomPagedSliverListView<SkillsResponseDTO>(
                    initPageFuture: (pageKey) async {
                      var dataResponse =
                          await ApiRepo().getSkills(context.read<EmployeeProvider>().employee?.id, pageKey, 7);
                      skills = dataResponse.result!.toPagedList().records;
                      return (dataResponse.result!.toPagedList() ?? []) as FutureOr<PagedList<SkillsResponseDTO>>;
                    },
                    itemBuilder: (context, item, index) {
                      return SkillCard(
                        skillInfo: item,
                        updateSkill: () =>
                            showSkillRequestBottomSheet(context: context, employee: _employee, skillInfo: item),
                        deleteSkill: () => showConfirmationBottomSheet(
                          context: context,
                          desc: context.appStrings!.areYouSureYouWantToDeleteThisSkill,
                          isDismissible: false,
                          onConfirm: () async {
                            Navigator.of(context).pop();
                            await _deleteSkill(item);
                          },
                        ),
                      );
                    },
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 70),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
} /* */
