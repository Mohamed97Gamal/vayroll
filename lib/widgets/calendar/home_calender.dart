import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/employee.dart';
import 'package:vayroll/navigation/navigation.dart';
import 'package:vayroll/utils/utils.dart' as utl;

class HomeCalender extends StatefulWidget {
  final Employee employeeInfo;
  final DateTime selectedDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final List<DateTime> daysWithEvents;
  final List<String> daysWithEventsBirthdays;
  final void Function(DateTime)? onPageChanged;
  final void Function(PageController)? onCalendarCreated;
  final Function(DateTime)? selectedDayPredicate;
  HomeCalender(
    this.employeeInfo,
    this.selectedDay,
    this.daysWithEvents,
    this.daysWithEventsBirthdays, {
    this.selectedDayPredicate,
    this.onPageChanged,
        required this.firstDay,
   required this.lastDay,
    this.onCalendarCreated,
  });

  @override
  State<StatefulWidget> createState() => HomeCalenderState();
}

class HomeCalenderState extends State<HomeCalender> {
 // CalendarController _calendarController = CalendarController();
  int month = DateTime.now().month;

  double? startX;
  num? endX;

  @override
  void initState() {
    super.initState();
   // _calendarController = CalendarController();
  }

  @override
  void dispose() {
   // _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => Navigation.navTocalenderPage(
            context,
            widget.employeeInfo,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    widget?.firstDay?.month == widget?.lastDay?.month
                        ? DateFormat.yMMMM().format(widget?.firstDay ?? DateTime.now())
                        : DateFormat("MMM yyyy").format(widget?.firstDay ?? DateTime.now()) +
                            " - " +
                            DateFormat("MMM yyyy").format(widget?.lastDay ?? DateTime.now()),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SvgPicture.asset(
                      VPayIcons.calendar,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        TableCalendar(
          onPageChanged: widget.onPageChanged,
          focusedDay: widget.selectedDay,
          firstDay: widget.firstDay,
          lastDay: widget.lastDay,
          daysOfWeekVisible: false,
          calendarFormat: CalendarFormat.week,
          headerVisible: false,
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              return unselectedDay(day);
            },
            todayBuilder: (context, day, focusedDay) {
              return todayhighlited(day);
            },
            disabledBuilder:  (context, day, focusedDay) {
              return unselectedDay(day);
            },
            dowBuilder: (context,day){
              return unselectedDay(day);
            }
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            leftChevronVisible: false,
            rightChevronVisible: false,
            titleCentered: true,
            titleTextStyle: Theme.of(context).textTheme.subtitle1!,
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle:
                Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 10, color: Theme.of(context).primaryColor),
            weekendStyle:
                Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 10, color: Theme.of(context).primaryColor),
          ),
          availableGestures: AvailableGestures.horizontalSwipe,
          availableCalendarFormats: {CalendarFormat.week: "Week"},
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            holidayTextStyle: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
            todayTextStyle: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
            weekendTextStyle: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
            selectedTextStyle:
                Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
            //highlightToday: true,
          ),
         // enabledDayPredicate: widget.selectedDayPredicate,
         // onVisibleDaysChanged: widget.onPageChanged,
          onCalendarCreated: widget.onCalendarCreated,
          rowHeight: 80,
         // calendarController: _calendarController,
        ),
      ],
    );
  }

  Widget unselectedDay(DateTime day) {
    return Center(
      child: Container(
        height: 80,
        width: 35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text(DateFormat.E().format(day).toString().toUpperCase(),
                style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.normal, fontSize: 10)),
            Text(day.day.toString(),
                style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.normal)),
            SizedBox(height: 1),
            (widget.daysWithEvents.contains(DateTime(day.year, day.month, day.day))) ||
                    (widget.daysWithEventsBirthdays
                        .contains(DateFormat("MM-dd").format(DateTime(day.year, day.month, day.day))))
                ? SvgPicture.asset(VPayIcons.star)
                : SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget todayhighlited(DateTime day) {
    String formatedDay = DateFormat("MM-dd")
        .format(DateTime(widget.selectedDay.year, widget.selectedDay.month, widget.selectedDay.day));
    return Stack(
      children: [
        Center(
          child: Container(
            height: 80,
            width: 40,
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(19)),
          ),
        ),
        Center(
          child: Container(
            height: 80,
            width: 35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.daysWithEventsBirthdays.contains(formatedDay) &&
                    utl.isSameDayWithoutYear(DateTime.now(), widget.employeeInfo.birthDate))
                  Column(
                    children: [
                      SizedBox(height: 4),
                      SvgPicture.asset(
                        VPayIcons.cake,
                        color: Colors.white,
                        height: 12,
                      ),
                    ],
                  )
                else
                  SizedBox(height: 16),
                Text(DateFormat.E().format(day).toString().toUpperCase(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white, fontSize: 10)),

                Text(day.day.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        !.copyWith(color: Colors.white, fontWeight: FontWeight.normal)),

                Visibility(
                  visible: (widget.daysWithEvents.contains(
                          DateTime(widget.selectedDay.year??2023, widget.selectedDay.month??8, widget.selectedDay.day??1)) ||
                      (widget.daysWithEventsBirthdays.contains(formatedDay) &&
                          utl.isSameDayWithoutYear(DateTime.now(), widget.employeeInfo.birthDate))),
                  child: isSameDay(DateTime.now(), widget.employeeInfo.birthDate)
                      ? SizedBox()
                      : SvgPicture.asset(
                          VPayIcons.star,
                          color: Colors.white,
                        ),
                ),
                // SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
