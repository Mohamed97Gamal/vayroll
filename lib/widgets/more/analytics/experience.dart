import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/chart_utils.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/single_tap_tooltip.dart';
import 'package:vayroll/widgets/widgets.dart';

class ExperienceWidget extends StatelessWidget {
  final List<String>? departmentIds;
  final String? employeesGroupId;

  const ExperienceWidget({Key? key, this.departmentIds, this.employeesGroupId}) : super(key: key);

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
      key: context.read<KeyProvider>().experneceCharts,
      child: CustomFutureBuilder<BaseResponse<List<Experience>>>(
        refreshOnRebuild: true,
        initFuture: () => ApiRepo().getExperience(departmentIds, employeesGroupId),
        onSuccess: (context, snapshot) {
          var experiences = snapshot.data!.result;
          if (experiences != null) experiences.sort((a, b) => int.parse(a.name!).compareTo(int.parse(b.name!)));
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.appStrings!.employeesGroupedby("Years of Experience (Rounded)"),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  if (!(experiences == null || experiences.isEmpty))
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
                                    height: 250.0 - 12.0 - 12.0,
                                    child: ExperienceChart(
                                      experience: experiences,
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
                      icon: Icon(Icons.share_outlined, color: Theme.of(context).primaryColor),
                    ),
                ],
              ),
              SizedBox(height: 16),
              if (experiences == null || experiences.isEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                    color: Colors.white,
                  ),
                  child: Text(
                    context.appStrings!.thereIsNoCharsForYouNow("experience"),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ] else
                SizedBox(
                  height: 250.0 - 12.0 - 12.0,
                  child: ExperienceChart(
                    experience: experiences,
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}

class ExperienceChart extends StatefulWidget {
  final bool forScreenshot;
  final List<Experience>? experience;

  const ExperienceChart({
    Key? key,
    this.experience,
    this.forScreenshot = false,
  }) : super(key: key);

  @override
  State<ExperienceChart> createState() => _ExperienceChartState();
}

class _ExperienceChartState extends State<ExperienceChart> {
  int? highestNumber;

  @override
  void initState() {
    super.initState();
    highestNumber = _highestNumber();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SizedBox(
      height: 226.0,
      child: Row(
        children: [
          yTitles(highestNumber!, context, 26.0),
          SizedBox(width: 8),
          for (final experience in widget.experience!)
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _chartLine(
                    experience.count!,
                    highestNumber,
                    200,
                    widget.forScreenshot,
                    index: 0,
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 14,
                    width: widget.forScreenshot ? null : 50.0,
                    child: widget.forScreenshot
                        ? Text(
                            experience.name! + "Y",
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Tooltip(
                            message: experience.name! + " Years",
                            child: Text(
                              experience.name! + "Y",
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ),
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

  int? _highestNumber() {
    List<int> allNumbers = [];
    widget.experience!.forEach((element) {
      allNumbers.add(element.count!);
    });
    return allNumbers.reduce(max);
  }

  Widget _chartLine(int value, int? highestNumber, double chartHeight, bool forScreenshot, {int? index}) {
    var newHighest = 8;
    if (value > 8) {
      newHighest = getNewHighest(highestNumber!);
    }

    return SingleTapTooltip(
      message: forScreenshot ? null : value.toString(),
      verticalOffset: -120.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          height: max(((value / (value > 8 ? newHighest : highestNumber!)) * (chartHeight)), 8.0),
          width: 8,
          decoration: BoxDecoration(
            color: colorBallet[index ?? 0],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
