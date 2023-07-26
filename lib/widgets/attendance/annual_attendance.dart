import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/utils/utils.dart';

class AnnualAttendanceWidget extends StatelessWidget {
  final String? employeeId;

  const AnnualAttendanceWidget({Key? key, required this.employeeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<BaseResponse<AnnualAttendance>>(
      initFuture: () => ApiRepo().getAnnualAttendance(employeeId),
      onSuccess: (context, snapshot) {
        int totalWorkingDays = snapshot.data?.result?.numberOfCompanyWorkingDays?.round() ?? 0;
        int presentDays = snapshot.data?.result?.numberOfEmployeeWorkingDays?.round() ?? 0;
        double progress = 0;
        double arcWidth = MediaQuery.of(context).size.width - 16 - 30 - 13 - 11 - 10 - 32 - 10 - 127;
        if (presentDays != 0 && totalWorkingDays != 0) progress = presentDays / totalWorkingDays;
        return Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.appStrings!.attendance, style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 22)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 13),
                        Container(
                          height: 11,
                          width: 11,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 32,
                          child: Text(
                            '$totalWorkingDays',
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Total Working Days',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 13),
                        Container(
                          height: 11,
                          width: 11,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 32,
                          child: Text(
                            '$presentDays',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'No. of Present Days',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ConstrainedBox(
                      constraints:BoxConstraints(maxWidth: 96),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: Size(arcWidth, arcWidth),
                            painter: GradientArcPainter(
                                progress: progress < 1 ? progress : 1,
                                startColor: DefaultThemeColors.pink,
                                middleColor: DefaultThemeColors.amaranth,
                                endColor: Theme.of(context).colorScheme.secondary,
                                backgroundColor: Theme.of(context).primaryColor,
                                width: 8),
                          ),
                          Text(
                            '${(progress * 100).round()}%',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Theme.of(context).colorScheme.secondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
