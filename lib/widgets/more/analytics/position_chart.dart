import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/chart_utils.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class PositionChartWidget extends StatelessWidget {
  final List<String>? departmentIds;
  final String? employeesGroupId;

  Future<String> _saveFile(String fileName, Uint8List bytes) async {
    var tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final String path = '$tempPath/$fileName';
    final File file = File(path);
    await file.writeAsBytes(bytes);
    printIfDebug(path);
    return path;
  }

  const PositionChartWidget({Key? key, this.departmentIds, this.employeesGroupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Refreshable(
      key: context.read<KeyProvider>().posisionCharts,
      child: CustomFutureBuilder<BaseResponse<List<PositionGender>>>(
        refreshOnRebuild: true,
        initFuture: () => ApiRepo().getPositionsAndGenders(departmentIds, employeesGroupId),
        onSuccess: (context, snapshot) {
          var positions = snapshot.data!.result;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.appStrings!.employeesGroupedby("Position and Gender"),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  if (!(positions == null || positions.isEmpty))
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
                                    child: SizedBox(
                                      height: 250.0,
                                      child: PositionGenderChart(
                                        positions: positions,
                                        forScreenshot: true,
                                      ),
                                    ),
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
                        icon: Icon(Icons.share_outlined, color: Theme.of(context).primaryColor))
                ],
              ),
              SizedBox(height: 16),
              if (positions == null || positions.isEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                    color: Colors.white,
                  ),
                  child: Text(
                    context.appStrings!.thereIsNoCharsForYouNow("position and gender"),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ] else
                SizedBox(
                  height: 250.0,
                  child: PositionGenderChart(
                    positions: positions,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class PositionGenderChart extends StatefulWidget {
  final bool forScreenshot;
  final List<PositionGender>? positions;

  const PositionGenderChart({
    Key? key,
    this.positions,
    this.forScreenshot = false,
  }) : super(key: key);

  @override
  State<PositionGenderChart> createState() => _PositionGenderChartState();
}

class _PositionGenderChartState extends State<PositionGenderChart> {
  static const chartHeight = 200.0;
  int? highestNumber;

  @override
  void initState() {
    super.initState();
    highestNumber = _highestNumber();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SizedBox(
      height: chartHeight,
      child: Row(
        children: [
          yTitles(highestNumber!, context),
          SizedBox(width: 8),
          for (final position in widget.positions!)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final employeesPerGender in position.employeesPerGender!)
                          chartLine(
                            employeesPerGender.numberOfEmployees!,
                            highestNumber!,
                            chartHeight,
                            widget.forScreenshot,
                            index: position.employeesPerGender!.indexOf(employeesPerGender),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: widget.forScreenshot ? null : 50.0,
                    child: widget.forScreenshot
                        ? Text(
                            position.position!,
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Tooltip(
                            message: position.position,
                            child: Text(
                              position.position!,
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
        ],
      ),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _createChartIndicators(widget.positions![0].employeesPerGender!),
        ),
        SizedBox(height: 28),
        Expanded(
          child: widget.forScreenshot
              ? FittedBox(
                  child: content,
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: content,
                ),
        ),
      ],
    );
  }

  List<Widget> _createChartIndicators(List<GenderEmployees> genders) {
    return List.generate(genders.length, (i) {
      return PositionsChartIndicator(
        gender: genders[i]?.gender ?? "",
        color: colorBallet[i],
      );
    });
  }

  int? _highestNumber() {
    List<int> allNumbers = [];
    widget.positions!.forEach((element) {
      element.employeesPerGender!.forEach((ele) {
        allNumbers.add(ele.numberOfEmployees!);
      });
    });
    return allNumbers.reduce(max);
  }
}
