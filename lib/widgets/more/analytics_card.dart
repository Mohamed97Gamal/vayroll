import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var employeesDepartmentId = context.read<EmployeeProvider>().employee!.department!.id;
    var employeesGroupId = context.read<EmployeeProvider>().employee!.employeesGroup!.id;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.appStrings!.employeesAnalytics,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Spacer(),
              InkWell(
                onTap: () => Navigation.navToAnalytics(context),
                child: Text(
                  context.appStrings!.viewAll,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
              )
            ],
          ),
          SizedBox(height: 12),
          CustomFutureBuilder<BaseResponse<List<Contract>>>(
            initFuture: () => ApiRepo().getContracts(null, employeesGroupId),
            onSuccess: (context, snapshot) {
              var contracts = snapshot.data!.result;
              if (contracts != null && contracts.isNotEmpty)
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.appStrings!.employeesGroupedby("Contracts"),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16),
                      ),
                      SizedBox(
                        height: 126,
                        width: MediaQuery.of(context).size.width,
                        child: PieChart(
                          PieChartData(
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 0,
                            centerSpaceRadius: 50,
                            startDegreeOffset: 270,
                            sections: _createChartSections(contracts),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              else
                return CustomFutureBuilder<BaseResponse<List<PositionGender>>>(
                  refreshOnRebuild: true,
                  initFuture: () => ApiRepo().getPositionsAndGenders([], employeesGroupId),
                  onSuccess: (context, snapshot) {
                    var positions = snapshot.data!.result;
                    if (positions != null && positions.isNotEmpty)
                      return Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(11)),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.appStrings!.employeesGroupedby("Experience"),
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16),
                            ),
                            SizedBox(
                              height: 250.0,
                              width: MediaQuery.of(context).size.width,
                              child: PositionGenderChart(
                                positions: positions,
                              ),
                            ),
                          ],
                        ),
                      );
                    else
                      return CustomFutureBuilder<BaseResponse<List<Experience>>>(
                        refreshOnRebuild: true,
                        initFuture: () => ApiRepo().getExperience([], employeesGroupId),
                        onSuccess: (context, snapshot) {
                          var experiences = snapshot.data!.result;
                          if (experiences != null && experiences.isNotEmpty)
                            return Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(11)),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 200.0,
                                      child: ExperienceChart(
                                        experience: experiences,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      context.appStrings!.employeesGroupedby("Position And Gender"),
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14),
                                    ),
                                  )
                                ],
                              ),
                            );
                          else
                            return CustomFutureBuilder<BaseResponse<List<Contract>>>(
                              initFuture: () => ApiRepo().getContracts([employeesDepartmentId], employeesGroupId),
                              onSuccess: (context, snapshot) {
                                var contracts = snapshot.data!.result;
                                if (contracts != null && contracts.isNotEmpty)
                                  return Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(11)),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 126,
                                            width: 126,
                                            child: PieChart(
                                              PieChartData(
                                                borderData: FlBorderData(show: false),
                                                sectionsSpace: 0,
                                                centerSpaceRadius: 50,
                                                startDegreeOffset: 270,
                                                sections: _createChartSections(contracts),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            context.appStrings!.employeesGroupedby("Contracts"),
                                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                else
                                  return CustomFutureBuilder<BaseResponse<List<PositionGender>>>(
                                    refreshOnRebuild: true,
                                    initFuture: () =>
                                        ApiRepo().getPositionsAndGenders([employeesDepartmentId], employeesGroupId),
                                    onSuccess: (context, snapshot) {
                                      var positions = snapshot.data!.result;
                                      if (positions != null && positions.isNotEmpty)
                                        return Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(11)),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 250.0,
                                                  child: PositionGenderChart(
                                                    positions: positions,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  context.appStrings!.employeesGroupedby("Experience"),
                                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      else
                                        return CustomFutureBuilder<BaseResponse<List<Experience>>>(
                                          refreshOnRebuild: true,
                                          initFuture: () =>
                                              ApiRepo().getExperience([employeesDepartmentId], employeesGroupId),
                                          onSuccess: (context, snapshot) {
                                            var experiences = snapshot.data!.result;
                                            if (experiences != null && experiences.isNotEmpty)
                                              return Container(
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(11)),
                                                  color: Colors.white,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 200.0,
                                                        child: ExperienceChart(
                                                          experience: experiences,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        context.appStrings!.employeesGroupedby("Position And Gender"),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(fontSize: 14),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            else
                                              return Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(11)),
                                                  color: Colors.white,
                                                ),
                                                child: Text(
                                                  context.appStrings!.thereIsNoCharsForYouNow(""),
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context).textTheme.subtitle1,
                                                ),
                                              );
                                          },
                                        );
                                    },
                                  );
                              },
                            );
                        },
                      );
                  },
                );
            },
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _createChartSections(List<Contract> contractsData) {
    return List.generate(
      contractsData.length,
      (i) {
        var radius = 15.0;
        List<PieChartSectionData> data = contractsData
            .map(
              (contract) => PieChartSectionData(
                showTitle: false,
                color: contract.color,
                value: contract.count!.toDouble(),
                radius: radius,
              ),
            )
            .toList();
        return data[i];
      },
    );
  }
}
