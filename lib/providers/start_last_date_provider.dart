import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';

class StartEndDateProvider extends ChangeNotifier {
  DateTime? _startDate;
  DateTime? _endDate;
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
