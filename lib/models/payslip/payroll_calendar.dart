import 'package:json_annotation/json_annotation.dart';

part 'payroll_calendar.g.dart';

@JsonSerializable()
class PayrollCalendar {
  DateTime? endDate;

  PayrollCalendar({
    this.endDate,
  });

  factory PayrollCalendar.fromJson(Map<String, dynamic> json) => _$PayrollCalendarFromJson(json);

  Map<String, dynamic> toJson() => _$PayrollCalendarToJson(this);
}
