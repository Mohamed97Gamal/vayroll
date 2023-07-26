import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vayroll/assets/fonts.dart';

abstract class AppThemes {
  AppThemes._();

  static ThemeData get defaultTheme {
    const _primaryColor = Color(0xFF013C68);
    const _accentColor = Color(0xFFFD5675);

    return ThemeData.light().copyWith(
      colorScheme: ColorScheme.light(primary: _primaryColor, secondary: _accentColor),
      primaryColor: _primaryColor,
      appBarTheme: AppBarTheme(
          elevation: 0, color: Colors.transparent, systemOverlayStyle: SystemUiOverlayStyle.dark),
      textTheme: TextTheme(
        headline4: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          fontFamily: Fonts.brandon,
          color: DefaultThemeColors.prussianBlue,
        ),
        headline5: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          fontFamily: Fonts.brandon,
          color: Colors.white,
        ),
        headline6: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          fontFamily: Fonts.brandon,
          color: _primaryColor,
        ),
        subtitle1: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontFamily: Fonts.brandon,
          color: _primaryColor,
        ),
        subtitle2: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: Fonts.brandon,
          color: DefaultThemeColors.dimGray,
        ),
        bodyText1: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontFamily: Fonts.brandon,
          color: _primaryColor,
        ),
        bodyText2: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          fontFamily: Fonts.brandon,
          color: _primaryColor,
        ),
        caption: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          fontFamily: Fonts.brandon,
          color: _accentColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(_accentColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
          ),
          textStyle: MaterialStateProperty.all(
            TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: Fonts.brandon,
            ),
          ),
          minimumSize: MaterialStateProperty.all(Size(88, 45)),
        ),
      ),
    );
  }

  static ThemeData get theme1 {
    return defaultTheme.copyWith(
      primaryColor: Color(0xFF2e7d32),
      colorScheme: ColorScheme.light(primary: Color(0xFF2e7d32), secondary: Color(0xFF616161)),
    );
  }
}

class DefaultThemeColors {
  // Used in: Page Titles (headline4),
  static const prussianBlue = Color(0xFF012763);
  // Used in: Company name (Home Page),
  static const brass = Color(0xFFB3B23D);
  // Used in: list divider,
  static const whiteSmoke1 = Color(0xFFF1F1F1);
  // Used in: Background color of scaffold in (settings, profile),
  static const whiteSmoke2 = Color(0xFFF8F8F8);
  // Used in: raise request
  static const whiteSmoke3 = Color(0xFFF6F6F6);
  // Used in: divider below tabs, personal info tile icon shadow (profile)
  static const gainsboro = Color(0xFFE1E1E1);
  // Used in: personal info tile Title (profile)
  static const nepal = Color(0xFF99B1C3);
  // Used in: data consent page
  static const aliceBlue = Color(0xFFE0F3FF);
  // Used in: splash page
  static const allports = Color(0xFF226A9A);
  // Used in: subtitle2
  static const dimGray = Color(0xFF707070);
  // Used in: disabled fields
  static const nobel = Color(0xFF9B9B9B);
  // Used in: homePage birthday divider
  static const Gray92 = Color(0xFFEBEBEB);
  // Used in: checkInOut widget
  static const mayaBlue = Color(0xFF64C1FF);
  // Used in: checkInOut widget button
  static const red = Color(0xFFFF0303);
  // Used in: checkInOut widget button
  static const lynch = Color(0xFF697E8D);
  // Used in: checkInOut widget button
  static const mantis = Color(0xFF7CCE6C);
  // Used in: filter in leave management page, attendance page
  static const lightCyan = Color(0xFFD5EDFF);
  // Used in: annual attendance widget
  static const pink = Color(0xFFFFC8D2);
  // Used in: leave management carry forward type
  static const darkPink = Color(0xFF33DC8D);
  // Used in: annual attendance widget
  static const amaranth = Color(0xFFE83F5F);
  // Used in: switch widget
  static const softLimeGreen = Color(0xFF4cd964);
  // Used in: Payslips widget
  static const limeGreen = Color(0xFF45C633);
  // Used in: Negative leave balance
  static const orangeRed = Color(0xFFFF4D4D);
  // Used in: Payslips widget
  static const antiFlashWhite = Color(0xFFEFF1F8);
  // Used in: dynamic widget
  static const cultured = Color(0xFFF3FAF2);
  // Used in: dynamic widget
  static const jetStream = Color(0xFFC3DCBF);
  // Used in: Positions Graph (Analytics)
  static const aluminium = Color(0xFF7C828A);
}
