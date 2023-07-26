import 'dart:io';
import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/common.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/widgets/widgets.dart';

class ContractsWidget extends StatefulWidget {
  final List<String>? departmentIds;
  final String? employeesGroupId;

  const ContractsWidget({Key? key, this.departmentIds, this.employeesGroupId}) : super(key: key);

  @override
  State<ContractsWidget> createState() => _ContractsWidgetState();
}

class _ContractsWidgetState extends State<ContractsWidget> {
  int touchedIndex = -1;

  Future<String> _saveFile(String fileName, Uint8List bytes) async {
    var tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final String path = '$tempPath/$fileName';
    final File file = File(path);
    await file.writeAsBytes(bytes);
    printIfDebug(path);
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Refreshable(
      key: context.read<KeyProvider>().contactsCharts,
      child: CustomFutureBuilder<BaseResponse<List<Contract>>>(
        //refreshOnRebuild: true,
        initFuture: () => ApiRepo().getContracts(widget.departmentIds, widget.employeesGroupId),
        onSuccess: (context, snapshot) {
          var contracts = snapshot.data!.result;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.appStrings!.employeesGroupedby("Contracts"),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  if (!(contracts == null || contracts.isEmpty))
                    IconButton(
                        onPressed: () async {
                          await showFutureProgressDialog(
                            context: context,
                            initFuture: () async {
                              ScreenshotController screenshotController = ScreenshotController();
                              var bytes = await screenshotController.captureFromWidget(
                                Material(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: _buildChart(contracts, context, true),
                                  ),
                                ),
                                context: context,
                                pixelRatio: 8.0,
                                delay: Duration(seconds: 2),
                              );
                              var path = await _saveFile("exported_chart.jpg", bytes);
                              await Share.shareFiles([path]);
                            },
                          );
                        },
                        icon: Icon(Icons.share_outlined, color: Theme.of(context).primaryColor)),
                ],
              ),
              SizedBox(height: 24),
              if (contracts == null || contracts.isEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                    color: Colors.white,
                  ),
                  child: Text(
                    context.appStrings!.thereIsNoCharsForYouNow("contracts"),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ] else
                _buildChart(contracts, context, false),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChart(List<Contract> contracts, BuildContext context, bool forScreenShot) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 146,
          width: 146,
          child: Stack(
            children: [
              Center(
                child: Text(
                  touchedIndex != -1 ? contracts[touchedIndex].count!.toStringAsFixed(0) : "",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              PieChart(
                PieChartData(
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 58,
                  startDegreeOffset: 270,
                  sections: _createChartSections(contracts),
                  pieTouchData: PieTouchData(
                    touchCallback: (touchEvent, pieTouchResponse) {
                      setState(() {
                        if (touchEvent.runtimeType == FlTapUpEvent &&
                            pieTouchResponse?.touchedSection?.touchedSection != null) {
                          touchedIndex = pieTouchResponse!.touchedSection!.touchedSectionIndex;
                          return;
                        }
                        touchedIndex = -1;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 32),
        GridView.count(
          primary: false,
          shrinkWrap: true,
          childAspectRatio: 7,
          mainAxisSpacing: 8.0,
          crossAxisCount: 2,
          children: _createChartIndicators(contracts, forScreenShot),
        ),
      ],
    );
  }

  List<PieChartSectionData> _createChartSections(List<Contract> contractsData) {
    return List.generate(
      contractsData.length,
      (i) {
        final isTouched = i == touchedIndex;
        var radius = isTouched ? 20.0 : 15.0;
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

  List<Widget> _createChartIndicators(List<Contract> contractsData, bool forScreenshot) {
    return List.generate(
      contractsData.length,
      (i) {
        final isTouched = i == touchedIndex;
        return forScreenshot
            ? InkWell(
                onTap: () => setState(() {
                  if (isTouched) {
                    touchedIndex = -1;
                  } else {
                    touchedIndex = i;
                  }
                }),
                child: ContractChartIndicator(
                  text: contractsData[i].name,
                  color: colorBallet[i],
                  fontWeight: isTouched ? FontWeight.w500 : FontWeight.normal,
                ),
              )
            : Tooltip(
                message: contractsData[i].name,
                verticalOffset: -50,
                child: InkWell(
                  onTap: () => setState(() {
                    if (isTouched) {
                      touchedIndex = -1;
                    } else {
                      touchedIndex = i;
                    }
                  }),
                  child: ContractChartIndicator(
                    text: contractsData[i].name,
                    color: colorBallet[i],
                    fontWeight: isTouched ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              );
      },
    );
  }
}
