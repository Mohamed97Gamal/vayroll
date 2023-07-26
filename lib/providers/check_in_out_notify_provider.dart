import 'package:flutter/foundation.dart';

class HomeCheckInNotifyProvider extends ChangeNotifier {
  HomeCheckInNotifyProvider();

  refresh() => notifyListeners();
}

class HomeCheckOutNotifyProvider extends ChangeNotifier {
  HomeCheckOutNotifyProvider();

  refresh() => notifyListeners();
}

class AttendanceCheckInNotifyProvider extends ChangeNotifier {
  AttendanceCheckInNotifyProvider();

  refresh() => notifyListeners();
}

class AttendanceCheckOutNotifyProvider extends ChangeNotifier {
  AttendanceCheckOutNotifyProvider();

  refresh() => notifyListeners();
}
