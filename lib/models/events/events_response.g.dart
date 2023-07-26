// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventsResponse _$EventsResponseFromJson(Map<String, dynamic> json) =>
    EventsResponse()
      ..birthdays = (json['birthdays'] as List<dynamic>?)
          ?.map((e) => BirthdaysResponse.fromJson(e as Map<String, dynamic>))
          .toList()
      ..publicHolidayDates = (json['publicHolidayDates'] as List<dynamic>?)
          ?.map(
              (e) => PublicHolidaysResponse.fromJson(e as Map<String, dynamic>))
          .toList()
      ..calenderNotes = (json['calenderNotes'] as List<dynamic>?)
          ?.map((e) => CalenderNotes.fromJson(e as Map<String, dynamic>))
          .toList()
      ..leaves = (json['leaves'] as List<dynamic>?)
          ?.map((e) => LeaveResponse.fromJson(e as Map<String, dynamic>))
          .toList()
      ..daysOfEvents = json['daysOfEvents'] == null
          ? null
          : DaysOfEvents.fromJson(json['daysOfEvents'] as Map<String, dynamic>);

Map<String, dynamic> _$EventsResponseToJson(EventsResponse instance) =>
    <String, dynamic>{
      'birthdays': instance.birthdays,
      'publicHolidayDates': instance.publicHolidayDates,
      'calenderNotes': instance.calenderNotes,
      'leaves': instance.leaves,
      'daysOfEvents': instance.daysOfEvents,
    };

DaysOfEvents _$DaysOfEventsFromJson(Map<String, dynamic> json) => DaysOfEvents()
  ..notes = (json['notes'] as List<dynamic>?)
      ?.map((e) => DateTime.parse(e as String))
      .toList()
  ..leaves = (json['leaves'] as List<dynamic>?)
      ?.map((e) => DateTime.parse(e as String))
      .toList()
  ..birthdays = (json['birthdays'] as List<dynamic>?)
      ?.map((e) => DateTime.parse(e as String))
      .toList()
  ..publicHolidays = (json['public holidays'] as List<dynamic>?)
      ?.map((e) => DateTime.parse(e as String))
      .toList();

Map<String, dynamic> _$DaysOfEventsToJson(DaysOfEvents instance) =>
    <String, dynamic>{
      'notes': instance.notes?.map((e) => e.toIso8601String()).toList(),
      'leaves': instance.leaves?.map((e) => e.toIso8601String()).toList(),
      'birthdays': instance.birthdays?.map((e) => e.toIso8601String()).toList(),
      'public holidays':
          instance.publicHolidays?.map((e) => e.toIso8601String()).toList(),
    };
