import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';

class StartEndDateProvider extends ChangeNotifier {
  DateTime? _startDate=DateTime.now().getDay(dayOfWeek: 0);
  DateTime? _endDate=DateTime.now().getDay(dayOfWeek: 6);
  EventsResponse? _allEvents;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  EventsResponse? get allEvents => _allEvents;

  set startDate(DateTime? value) {
    _startDate = value;
    notifyListeners();
  }

  set endDate(DateTime? value) {
    _endDate = value;
    notifyListeners();
  }

  set allEvents(EventsResponse? value) {
    _allEvents = value;
    notifyListeners();
  }
}
extension DateUtils on DateTime {
  DateTime getDay({required int dayOfWeek}) {
    return subtract(Duration(days: weekday - dayOfWeek));
  }
}
