import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/api_responses/base_response.dart';
import 'package:vayroll/models/employee.dart';
import 'package:vayroll/models/events/events_response.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/calendar/home_calender.dart';
import 'package:vayroll/widgets/future_builder.dart';
import 'package:vayroll/widgets/widgets.dart';

class FullHomeCalanderWidget extends StatefulWidget {
  final Employee employeeInfo;
  FullHomeCalanderWidget({required this.employeeInfo});

  @override
  State<StatefulWidget> createState() => FullHomeCalanderWidgetState();
}

class FullHomeCalanderWidgetState extends State<FullHomeCalanderWidget> {
  DateTime _selectedDay = DateTime.now();

  List<DateTime> daysWithevent = [];
  List<String> daysWitheventBirthdays = [];

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<BaseResponse<EventsResponse>>(
      loadingMessageColor: Colors.white,
      initFuture: () async => await ApiRepo().getEvents(
        widget.employeeInfo.id ?? "",
        widget.employeeInfo.employeesGroup?.id ?? "",
        Jiffy.parse(DateTime(DateTime.now().year, 1, 1).toString()).subtract(years: 50).dateTime.toString(),
        Jiffy.parse(DateTime(DateTime.now().year, 12, 31).toString()).add(years: 50).dateTime.toString(),
      ),
      onSuccess: (context, snapshot) {
        final allEvents = snapshot.data!.result;
        allEvents?.daysOfEvents?.birthdays?.forEach((element) {
          if (!daysWitheventBirthdays.contains(element))
            daysWitheventBirthdays
                .add(DateFormat("MM-dd").format(DateTime(DateTime.now().year, element.month, element.day)));
        });
        allEvents?.daysOfEvents?.notes?.forEach((element) {
          if (!daysWithevent.contains(element)) daysWithevent.add(DateTime(element.year, element.month, element.day));
        });
        allEvents?.daysOfEvents?.leaves?.forEach((element) {
          if (!daysWithevent.contains(element)) daysWithevent.add(DateTime(element.year, element.month, element.day));
        });
        allEvents?.daysOfEvents?.publicHolidays?.forEach((element) {
          if (!daysWithevent.contains(element)) daysWithevent.add(DateTime(element.year, element.month, element.day));
        });

        return Center(
          child: HomeCalender(
            widget.employeeInfo,
            _selectedDay,
            daysWithevent,
            daysWitheventBirthdays,
            firstDay: context.read<StartEndDateProvider>().startDate!,
            lastDay: context.read<StartEndDateProvider>().endDate!,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onCalendarCreated: (first) {
              Future.microtask(() => setState(() {
                   // context.read<StartEndDateProvider>().startDate = first;
                    //context.read<StartEndDateProvider>().endDate = last;
                    context.read<StartEndDateProvider>().allEvents = allEvents;
                  }));
            },
            onPageChanged: (focusedDay) {
              Future.microtask(() => setState(() {
                    context.read<StartEndDateProvider>().startDate = focusedDay.getDay(dayOfWeek: 0);
                    context.read<StartEndDateProvider>().endDate = focusedDay.getDay(dayOfWeek: 6);
                    context.read<StartEndDateProvider>().allEvents = allEvents;
                    _selectedDay = focusedDay;
                  }));
            },
          ),
        );
      },
    );
  }
}
