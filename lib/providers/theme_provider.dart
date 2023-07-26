import 'package:flutter/material.dart';
import 'package:vayroll/theme/app_themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData? _theme;

  ThemeProvider() {
    _theme = AppThemes.defaultTheme;
  }

  ThemeData? get theme => _theme;

  set theme(ThemeData? value) {
    if (_theme != value) {
      _theme = value;
      notifyListeners();
    }
  }

  void setTheme(int themeId) {
    switch (themeId) {
      case 0:
        theme = AppThemes.defaultTheme;
        break;
      case 1:
        theme = AppThemes.theme1;
        break;
      default:
        theme = AppThemes.defaultTheme;
    }
  }
}
