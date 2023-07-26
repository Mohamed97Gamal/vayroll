import 'package:flutter/material.dart';

class HomeTabIndexProvider extends ChangeNotifier {
  int? _index;
  bool? _hideBarItems;
  bool? _appealManagerIcon;

  HomeTabIndexProvider() {
    _index = 2;
    _hideBarItems = false;
    _appealManagerIcon = false;
  }

  int? get index => _index;

  set index(int? value) {
    if (_index != value) {
      _index = value;
      notifyListeners();
    }
  }

  bool? get hideBarItems => _hideBarItems;
  set hideBarItems(bool? value) {
    if (_hideBarItems != value) {
      _hideBarItems = value;
      notifyListeners();
    }
  }

  bool? get appealManagerIcon => _appealManagerIcon;

  set appealManagerIcon(bool? value) {
    if (_appealManagerIcon != value) {
      _appealManagerIcon = value;
      notifyListeners();
    }
  }
}
