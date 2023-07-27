import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/employee.dart';

import '../../models/api_responses/base_response.dart';
import '../../models/events/calender_notes.dart';
import '../../models/events/events_response.dart';
import '../../providers/key_provider.dart';
import '../../repo/api/api_repo.dart';
import '../../theme/app_themes.dart';
import '../../utils/common.dart'as util;
import '../../widgets/back_button.dart';
import '../../widgets/bottom_sheet.dart';
import '../../widgets/calendar/birthday_card.dart';
import '../../widgets/calendar/calender_item.dart';
import '../../widgets/calendar/holiday_card.dart';
import '../../widgets/calendar/leaves_card.dart';
import '../../widgets/confirmation_bottom_sheet.dart';
import '../../widgets/future_builder.dart';
import '../../widgets/future_dialog.dart';
import '../../widgets/refreshable.dart';
import '../../widgets/splash_art.dart';
import '../../widgets/toolip_shape.dart';
import 'add_note_sheet.dart';

class CalenderPage extends StatefulWidget {
  final Employee employeeInfo;

  CalenderPage({required this.employeeInfo});

  @override
  State<StatefulWidget> createState() => CalenderPageState();
}

class CalenderPageState extends State<CalenderPage> {
  final _refreshableKey = GlobalKey<RefreshableState>();
  final _monthRefreshableKey = GlobalKey<RefreshableState>();

  DateTime _focusedDay = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDay = DateTime.now();
  final _rangeLimit = DateTimeRange(
      end: DateTime(DateTime.now().year + 2, 1, 0),
      start: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        0,
        0,
      ));

  DateTime firstDay = DateTime.now();
  DateTime lastDay = DateTime.now();

  List<DateTime> daysWithEvents = [];
  PageController _calendarController = PageController();

  Future _deleteNote(CalenderNotes note) async {
    final deleteNoteResponse =
        await showFutureProgressDialog<BaseResponse<String>>(
      context: context,
      initFuture: () => ApiRepo().deleteNote(note.id),
    );
    if (deleteNoteResponse!.status!) {
      await showCustomModalBottomSheet(
        context: context,
        isDismissible: true,
        desc: deleteNoteResponse?.message ?? " ",
      );
      _refreshableKey.currentState?.refresh();
      context.read<KeyProvider>().homeCalendarNotifier.refresh();
    } else {
      await showCustomModalBottomSheet(
        context: context,
        desc: deleteNoteResponse?.message ?? " ",
      );
      _refreshableKey.currentState?.refresh();
      context.read<KeyProvider>().homeCalendarNotifier.refresh();
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final employeeInfo = widget.employeeInfo;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed:
            (_selectedDay.isBefore(_rangeLimit.end.add(Duration(days: 1))) &&
                    _selectedDay.isAfter(_rangeLimit.start))
                ? () => addNoteModalBottomSheet(
                    context: context,
                    refreshableKey: _refreshableKey,
                    selectedDate: _selectedDay)
                : null,
        backgroundColor:
            (_selectedDay.isBefore(_rangeLimit.end.add(Duration(days: 1))) &&
                    _selectedDay.isAfter(_rangeLimit.start))
                ? Theme.of(context).colorScheme.secondary
                : DefaultThemeColors.nobel,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        leading: CustomBackButton(onPressed: () => Navigator.of(context).pop()),
        backgroundColor: DefaultThemeColors.whiteSmoke2,
        elevation: 0,
      ),
      body: Refreshable(
        key: _refreshableKey,
        child: RefreshIndicator(
          onRefresh: () async => _refreshableKey.currentState?.refresh(),
          child: CustomFutureBuilder<BaseResponse<EventsResponse>>(
            onLoading: (context) => Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: const SplashArt(),
            ),
            initFuture: () async => await ApiRepo().getEvents(
              employeeInfo.id??"",
              employeeInfo.employeesGroup?.id??"",
              DateFormat('yyyy-MM-dd hh:mm:ss.SSS')
                  .format(DateTime(_selectedDay.year, _selectedDay.month))
                  .toString(),
              DateFormat('yyyy-MM-dd hh:mm:ss.SSS')
                  .format(DateTime(_selectedDay.year, _selectedDay.month + 1))
                  .toString(),
            ),
            onSuccess: (context, snapshot) {
              final allEvents = snapshot.data!.result;
              daysWithEvents = [];
              allEvents?.daysOfEvents?.birthdays?.forEach((element) {
                if (!daysWithEvents.contains(element))
                  daysWithEvents.add(
                      DateTime(_selectedDay.year, element.month, element.day));
              });
              allEvents?.daysOfEvents?.leaves?.forEach((element) {
                if (!daysWithEvents.contains(element))
                  daysWithEvents
                      .add(DateTime(element.year, element.month, element.day));
              });
              allEvents?.daysOfEvents?.notes?.forEach((element) {
                if (!daysWithEvents.contains(element))
                  daysWithEvents
                      .add(DateTime(element.year, element.month, element.day));
              });
              allEvents?.daysOfEvents?.publicHolidays?.forEach((element) {
                if (!daysWithEvents.contains(element))
                  daysWithEvents
                      .add(DateTime(element.year, element.month, element.day));
              });

              EventsResponse allEventsSelectedDay = new EventsResponse();
              allEventsSelectedDay?.birthdays = [];
              allEventsSelectedDay?.calenderNotes = [];
              allEventsSelectedDay?.leaves = [];
              allEventsSelectedDay?.publicHolidayDates = [];

              allEvents?.birthdays?.forEach((element) {
                final DateTime birthdate = DateFormat("yyyy-MM-dd")
                    .parse((element.birthDate!.split("T")[0]));
                if (util.isSameDayWithoutYear(_selectedDay, birthdate)) {
                  allEventsSelectedDay?.birthdays?.add(element);
                }
              });

              allEvents?.calenderNotes?.forEach((element) {
                final DateTime noteDate = DateFormat("yyyy-MM-dd")
                    .parse((element.noteDate!.split("T")[0]));
                if (isSameDay(_selectedDay, noteDate)) {
                  allEventsSelectedDay?.calenderNotes?.add(element);
                }
              });
              allEvents?.publicHolidayDates?.forEach((element) {
                final DateTime noteDate = DateFormat("yyyy-MM-dd")
                    .parse((element.date!.split("T")[0]));
                if (isSameDay(_selectedDay, noteDate)) {
                  allEventsSelectedDay?.publicHolidayDates?.add(element);
                }
              });
              allEvents?.leaves?.forEach((element) {
                element?.dates?.forEach((date) {
                  final DateTime noteDate =
                      DateFormat("yyyy-MM-dd").parse((date.split("T")[0]));
                  if (isSameDay(_selectedDay, noteDate)) {
                    allEventsSelectedDay?.leaves?.add(element);
                  }
                });
              });

              bool nullData =
                  ((allEventsSelectedDay?.calenderNotes?.isEmpty == true &&
                          allEventsSelectedDay?.publicHolidayDates?.isEmpty ==
                              true) &&
                      (allEventsSelectedDay?.birthdays?.isEmpty == true &&
                          allEventsSelectedDay?.leaves?.isEmpty == true));
              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    color: DefaultThemeColors.whiteSmoke2,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                      child: CalenderItem(
                        _focusedDay,
                        _selectedDay,
                        (selectedDay, day) {
                          setState(() {
                            _selectedDay = selectedDay;
                          });
                          _monthRefreshableKey.currentState?.refresh();
                        },
                        daysWithEvents,
                        _calendarController,
                        onPageChanged: (pageController) {
                          setState(() {
                             firstDay = pageController;
                             lastDay = DateTime(pageController.year,pageController.month,pageController.day+30);
                             _selectedDay = pageController;
                            _refreshableKey.currentState?.refresh();
                          });
                        },
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        color: DefaultThemeColors.whiteSmoke2,
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        height: 10,
                      ),
                    ],
                  ),
                  Refreshable(
                    key: _monthRefreshableKey,
                    child: RefreshIndicator(
                      onRefresh: () async =>
                          _monthRefreshableKey.currentState?.refresh(),
                      child: events(allEventsSelectedDay, nullData),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget events(EventsResponse allEvents, bool nullData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          if (nullData) ...[
            SizedBox(height: 16),
            Center(
              child: SvgPicture.asset(
                VPayImages.empty,
                height: 200,
              ),
            ),
            SizedBox(height: 16),
            Text(
              context.appStrings!.noDataToDisplay,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Color(0xff444053)),
            ),
          ],
          if (allEvents.calenderNotes?.isNotEmpty == true) ...[
            notes(allEvents.calenderNotes!),
            Padding(
                padding: const EdgeInsets.only(left: 50, right: 20),
                child: Divider()),
          ],
          if (allEvents.birthdays?.isNotEmpty == true) ...[
            BirthdayCard(birthdays: allEvents?.birthdays),
            Padding(
                padding: const EdgeInsets.only(left: 50, right: 20),
                child: Divider()),
          ],
          if (allEvents?.publicHolidayDates?.isNotEmpty == true) ...[
            HolidayCard(holidays: allEvents?.publicHolidayDates),
            Padding(
                padding: const EdgeInsets.only(left: 50, right: 20),
                child: Divider()),
          ],
          if (allEvents?.leaves?.isNotEmpty == true)
            LeavesCard(leaves: allEvents?.leaves),
        ],
      ),
    );
  }

  Widget notes(List<CalenderNotes> notes) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SvgPicture.asset(
           VPayIcons.notes,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      title: Text(
        context.appStrings!.note,
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
      subtitle: ListView.builder(
        itemCount: notes?.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        // ignore: missing_return
        itemBuilder: (context, index) {
          if (notes[index]?.title?.isNotEmpty == true &&
              notes[index]?.description?.isNotEmpty == true) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        children: [
                          Text(
                            notes[index]?.title ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 20,
                      child: PopupMenuButton(
                        color: Theme.of(context).primaryColor,
                        offset: Offset(-5, 10),
                        padding: EdgeInsets.zero,
                        shape: TooltipShape(),
                        icon: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).primaryColor,
                        ),
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(context.appStrings!.edit,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                              ),
                              value: "Edit"),
                          PopupMenuItem(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(context.appStrings!.delete,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                              ),
                              value: "Delete"),
                        ],
                        onSelected: (value) {
                          if (value == "Edit")
                            addNoteModalBottomSheet(
                                context: context,
                                note: notes[index],
                                refreshableKey: _refreshableKey);
                          else
                            showConfirmationBottomSheet(
                              context: context,
                              desc:
                                  'Are you sure you want to delete "${notes[index].title}" note?',
                              isDismissible: false,
                              onConfirm: () async {
                                Navigator.of(context).pop();
                                await _deleteNote(notes[index]);
                              },
                            );
                        },
                      ),
                    ),
                  ],
                ),
                Text(
                  util.dateFormat.format(DateFormat("yyyy-MM-dd")
                      .parse((notes[index].noteDate!.split("T")[0]))),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: DefaultThemeColors.nepal,
                      ),
                ),
                Text(
                  notes[index]?.description ?? "",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                ),
                if (index != notes.length - 1) Divider(),
              ],
            );
          }
        },
      ),
      dense: true,
    );
  }
}
