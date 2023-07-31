import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intL;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/widgets.dart';

T? tryCast<T>(dynamic obj) {
  if (obj == null) return null;
  return (obj is T) ? obj : null;
}

String? nullIfEmpty(String? value, {bool trimmed = true}) {
  if (value == null) return null;
  final _value = trimmed == true ? value.trim() : value;
  if (_value.isEmpty) return null;
  return _value;
}

void printIfDebug(Object object) {
  if (kReleaseMode) return;
  print(object);
}

Size getTextSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

intL.DateFormat get dateFormat => intL.DateFormat('dd/MM/yyyy');

intL.DateFormat get dateFormat2 => intL.DateFormat('yyyy-MM-dd');

intL.DateFormat get dateFormat3 => intL.DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

intL.DateFormat get dateFormat4 => intL.DateFormat('E, dd MMM');

intL.DateFormat get dateTimeFormat => intL.DateFormat('dd/MM/yyyy  HH:mm a');

intL.DateFormat get monthYearFormat => intL.DateFormat.yMMM();

intL.DateFormat get monthYearFormat2 => intL.DateFormat('MMMM, yyyy');

intL.DateFormat get monthYearFormat3 => intL.DateFormat('MMM_yyyy');

intL.DateFormat get dayOfWeek => intL.DateFormat('E');

intL.DateFormat get timeFormat => intL.DateFormat('hh:mm a');

intL.NumberFormat get currencyFormat => intL.NumberFormat("#,##0.00");

const int pageSize = 10;

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    int thisInMinutes = this.hour * 60 + this.minute;
    int otherInMinutes = other.hour * 60 + other.minute;
    if (thisInMinutes < otherInMinutes) return -1;
    if (thisInMinutes > otherInMinutes) return 1;
    return 0;
  }
}

extension LocalizedStrings on BuildContext {
  AppLocalizations? get appStrings => AppLocalizations.of(this);
}

bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }

  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool isSameDayWithoutYear(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }

  return a.month == b.month && a.day == b.day;
}

bool isSameTime(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }
  return a.hour == b.hour && a.minute == b.minute;
}

Color statusColor(String? status, BuildContext context) {
  if (status == "submitted".toUpperCase()) return DefaultThemeColors.brass;
  if (status == "new".toUpperCase()) return DefaultThemeColors.mantis;
  if (status == "closed".toUpperCase())
    return Theme.of(context).colorScheme.secondary;
  return Theme.of(context).primaryColor;
}

String getDecomentIcon(String? extention) {
  switch (extention) {
    case "pdf":
      return VPayIcons.pdf;
    case "doc":
      return VPayIcons.doc;
    case "xlsx":
      return VPayIcons.xlsx;
    case "jpg":
      return VPayIcons.jpg;
    case "bmp":
      return VPayIcons.bmp;
    case "dib":
      return VPayIcons.dib;
    case "gif":
      return VPayIcons.gif;
    case "heic":
      return VPayIcons.heic;
    case "jpeg":
      return VPayIcons.jpeg;
    case "png":
      return VPayIcons.png;
    case "tiff":
      return VPayIcons.tiff;
    case "webp":
      return VPayIcons.webp;
    case "csv":
      return VPayIcons.csv;
    case "docx":
      return VPayIcons.docx;
    case "txt":
      return VPayIcons.txt;
    case "xls":
      return VPayIcons.xls;
    default:
      return VPayIcons.other;
  }
}

Future saveCall(BuildContext context, String? phoneNumber,
    {Caller? recipient}) async {
  // ignore: unused_local_variable
  final saveCallResponse = await showFutureProgressDialog<BaseResponse<List>>(
    context: context,
    initFuture: () => ApiRepo().saveCall(
        context.read<EmployeeProvider>().employee!.id,
        phoneNumber,
        dateFormat3.format(DateTime.now()),
        recipient: recipient),
  );

  if (saveCallResponse?.status ?? false) {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber!.replaceAll(' ', ""),
    );
    await launch(launchUri.toString());
  } else {
    await showCustomModalBottomSheet(
      context: context,
      desc: saveCallResponse?.message ?? " ",
    );
    return;
  }
}

double calculatePercentage(LeaveBalanceResponseDTO? leaveBalanceInfo) {
  final currentBalance = leaveBalanceInfo?.currentBalance == null
      ? 0
      : leaveBalanceInfo!.currentBalance! < 0
          ? 0
          : leaveBalanceInfo.currentBalance!;
  final totalBalance =
      (leaveBalanceInfo?.totalBalance ?? leaveBalanceInfo?.maxDaysPerRequest!)!;
  if (totalBalance >= currentBalance) {
    return currentBalance / totalBalance;
  } else {
    return totalBalance / totalBalance;
  }
}

extension NumExtensions on num {
  bool get isInt => (this % 1) == 0;
}
