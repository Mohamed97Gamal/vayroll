import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/utils/utils.dart' as utl;
import 'package:vayroll/widgets/title_stack.dart';

class CalenderItem extends StatefulWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final List<DateTime> daysWithEvents;
  final PageController calendarController;
  final void Function(DateTime, DateTime)? onDaySelected;
  final void Function(DateTime)? onPageChanged;
  CalenderItem(this.focusedDay, this.selectedDay, this.onDaySelected, this.daysWithEvents, this.calendarController,
      {this.onPageChanged});
  @override
  State<StatefulWidget> createState() => CalenderItemState();
}

class CalenderItemState extends State<CalenderItem> {
   DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleStacked(context.appStrings!.calender, Theme.of(context).primaryColor),
                Spacer(),
                InkWell(
                  onTap: () {
                    showMonthPicker(
                      context: context,
                      initialDate: selectedDate ?? widget.selectedDay,
                      locale: Locale("en"),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                         // widget.calendarController.setSelectedDay(selectedDate);
                         // widget.calendarController.setFocusedDay(selectedDate);
                        });
                      }
                    });
                  },
                  child: Text(
                    DateFormat("MMMM, y").format(widget.selectedDay).toString(),
                    style:
                        Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ],
            ),
          ),
        ),
        TableCalendar(
          onPageChanged: widget.onPageChanged,
          onCalendarCreated: (pageController){

          },
          calendarFormat: CalendarFormat.month,
          firstDay: DateTime(1800,1,1),
          focusedDay: widget?.selectedDay ?? DateTime.now(),
          lastDay: DateTime(2300,12,1),
          availableGestures: AvailableGestures.horizontalSwipe,
          // startDay: DateTime(DateTime.now().year),
          // endDay: DateTime(DateTime.now().year + 1),
          headerVisible: false,
          availableCalendarFormats: {CalendarFormat.month: 'Month'},
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              return Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(day.day.toString(),
                        style:
                            Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
                    Visibility(
                      visible: widget.daysWithEvents.contains(DateTime(day.year, day.month, day.day)),
                      child: SvgPicture.asset(VPayIcons.star),
                    ),
                    Visibility(
                      visible: !widget.daysWithEvents.contains(DateTime(day.year, day.month, day.day)),
                      child: SizedBox(height: 8),
                    ),
                  ],
                ),
              );
            },
            todayBuilder: (context, day, focusedDay) {
              return todayhighlited(day);
            },
            selectedBuilder: (context, day, focusedDay) {
              return isSameDay(DateTime.now(), day) ? todayhighlited(day) : selectedDay(day);
            },
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            leftChevronVisible: false,
            rightChevronVisible: false,
            titleCentered: true,
            titleTextStyle: Theme.of(context).textTheme.subtitle1!,
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: Theme.of(context)
                .textTheme
                .subtitle2
                !.copyWith(fontWeight: FontWeight.normal, fontSize: 13, color: Theme.of(context).colorScheme.secondary),
            weekendStyle: Theme.of(context)
                .textTheme
                .subtitle2
                !.copyWith(fontWeight: FontWeight.normal, fontSize: 13, color: Theme.of(context).colorScheme.secondary),
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
           // highlightToday: true,
          ),
          onDaySelected: widget.onDaySelected,
       //   onVisibleDaysChanged: widget.onPageChanged,
          rowHeight: 50,
       //   calendarController: widget.calendarController,
        ),
      ],
    );
  }

  Widget todayhighlited(DateTime day) {
    return Center(
      child: Container(
        width: 35,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(25)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                day.day.toString(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    !.copyWith(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white, height: 0.9),
              ),
              Visibility(
                visible: widget.daysWithEvents.contains(DateTime(day?.year??2023, day?.month??8, day?.day??1)),
                child: SvgPicture.asset(
                  VPayIcons.star,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectedDay(DateTime day) {
    return Center(
      child: Container(
        width: 35,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                day.day.toString(),
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary,
                    height: 0.9),
              ),
              Visibility(
                visible: widget.daysWithEvents.contains(
                    DateTime(widget?.selectedDay.year??2023, widget?.selectedDay!.month??8, widget?.selectedDay!.day??1)),
                child: SvgPicture.asset(
                  VPayIcons.star,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
