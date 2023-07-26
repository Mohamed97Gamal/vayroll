import 'package:json_annotation/json_annotation.dart';
import 'package:vayroll/models/models.dart';

part 'events_response.g.dart';

@JsonSerializable()
class EventsResponse {
  List<BirthdaysResponse>? birthdays;
  List<PublicHolidaysResponse>? publicHolidayDates;
  List<CalenderNotes>? calenderNotes;
  List<LeaveResponse>? leaves;
  DaysOfEvents? daysOfEvents;

  factory EventsResponse.fromJson(Map<String, dynamic> json) => _$EventsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventsResponseToJson(this);

  EventsResponse();
}

@JsonSerializable()
class DaysOfEvents {
  List<DateTime>? notes;
  List<DateTime>? leaves;
  List<DateTime>? birthdays;
  @JsonKey(name: 'public holidays')
  List<DateTime>? publicHolidays;

  factory DaysOfEvents.fromJson(Map<String, dynamic> json) => _$DaysOfEventsFromJson(json);

  Map<String, dynamic> toJson() => _$DaysOfEventsToJson(this);

  DaysOfEvents();
}
