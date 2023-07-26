import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/widgets.dart';

class BirthdayHomeWidget extends StatefulWidget {
  final Employee? employee;

  BirthdayHomeWidget({Key? key, this.employee}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BirthdayHomeWidgetState();
}

class BirthdayHomeWidgetState extends State<BirthdayHomeWidget> {
  List<BirthdaysResponse> birthdays = [];

  Future<List<String>> getsDaysInWeak(DateTime first, DateTime last) async {
    final int daysToGenerate = last!.difference(first).inDays;

    List<String> days = List.generate(daysToGenerate + 1, (i) {
      return DateFormat("MM-dd").format(DateTime(first.year, first.month, first.day + (i)));
    });
    return days;
  }

  Future<List<BirthdaysResponse>> calculateBirthdays(DateTime first, DateTime last, EventsResponse? allEvents) async {
    birthdays = [];

    await getsDaysInWeak(first, last).then(
      (days) {
        allEvents!.birthdays!.forEach((element) {
          DateTime birthdate = DateFormat("yyyy-MM-dd").parse((element.birthDate!.split("T")[0]));

          if (DateTime.now().year == first.year) {
            if (days.contains(DateFormat("MM-dd").format(birthdate))) {
              if (birthdate.month == DateTime.now().month) {
                if (birthdate.day >= DateTime.now().day) {
                  birthdays.add(element);
                }
              } else {
                if (birthdate.month >= DateTime.now().month) {
                  birthdays.add(element);
                }
              }
            }
          } else if (DateTime.now().year < first.year) {
            if (days.contains(DateFormat("MM-dd").format(birthdate)) &&
                (birthdate.month == first.month || birthdate.month == last!.month)) {
              birthdays.add(element);
            }
          }
          if (birthdays.isNotEmpty == true) {
            birthdays.sort((a, b) {
              final DateTime birthdate = DateFormat("yyyy-MM-ddThh:mm:ss.SSS").parse(a.birthDate!);
              final DateTime birthdate2 = DateFormat("yyyy-MM-ddThh:mm:ss.SSS").parse(b.birthDate!);
              return birthdate.day.compareTo(birthdate2.day);
            });
          }
        });
      },
    );
    return birthdays;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                SvgPicture.asset(
                  VPayIcons.cake,
                  fit: BoxFit.none,
                ),
                SizedBox(width: 16),
                Text(
                  "Birthday",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Consumer<StartEndDateProvider>(
            builder: (context, startEndDateProvider, _) {
              return CustomFutureBuilder<List<BirthdaysResponse>>(
                loadingMessageColor: Colors.white,
                refreshOnRebuild: true,
                initFuture: () => calculateBirthdays(
                    startEndDateProvider.startDate!, startEndDateProvider.endDate!, startEndDateProvider.allEvents),
                onSuccess: (context, snapshot) {
                  List<BirthdaysResponse>? allbithdays = snapshot.data;
                  if (allbithdays == null) allbithdays = [];
                  return allbithdays.isNotEmpty == true
                      ? Container(
                          width: double.infinity,
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: allbithdays.length,
                            physics: ClampingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              late DateTime birthdate2;
                              final DateTime birthdate =
                                  DateFormat("yyyy-MM-ddThh:mm:ss.SSS").parse(allbithdays![index].birthDate!);
                              if (index != 0)
                                birthdate2 =
                                    DateFormat("yyyy-MM-ddThh:mm:ss.SSS").parse(allbithdays[index - 1].birthDate!);

                              return Row(
                                children: [
                                  if (index == 0)
                                    Container()
                                  else if (birthdate.day != birthdate2.day)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
                                      child: Container(
                                        color: DefaultThemeColors.Gray92,
                                        width: 1,
                                        height: 60,
                                      ),
                                    ),
                                  ProfileAvatar(
                                    birthdayInfo: allbithdays[index],
                                    employeeInfo: widget.employee,
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            "No upcoming birthdays in this week",
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                          ),
                        );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
