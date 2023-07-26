import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/providers/providers.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/widgets/widgets.dart';

import 'check_in_out_notify_provider.dart';

class AutoCheckOutProvider {
  late bool _isCheckingOut;

  AutoCheckOutProvider() {
    _isCheckingOut = false;
  }

  void autoCheckOut(BuildContext context, CheckInOut? checkInData, String? employeeId) async {
    if (_isCheckingOut) return;
    _isCheckingOut = true;

    var checkOutTime = DateTime(checkInData!.time!.year, checkInData.time!.month, checkInData.time!.day, 23, 59, 59);

    var duration = checkOutTime.difference(checkInData.time!);

    double workingHours = duration.inHours.toDouble() + (duration.inMinutes.remainder(60) / 60);

    var position = await _getPosition(context);

    var sessionCheckOut = CheckInOut(
      id: checkInData.id,
      time: checkOutTime,
      latitude: position != null ? position.latitude : null,
      longitude: position != null ? position.longitude : null,
      isManual: position == null,
      workingHours: workingHours,
    );

    await ApiRepo().checkOut(employeeId, sessionCheckOut);

    // var response = await ApiRepo().checkOut(employeeId, sessionCheckOut);
    // if (!response.status) {
    //   await showCustomModalBottomSheet(
    //       context: context, desc: context.appStrings.autoCheckOutAtEndOfDayFailedPleaseCheckOutManually);
    //   return;
    // }
    context.read<KeyProvider>().homeAttendanceNotifier.refresh();
    context.read<AttendanceCheckOutNotifyProvider>().refresh();
    context.read<HomeCheckOutNotifyProvider>().refresh();
    _isCheckingOut = false;
  }

  Future<Position?> _getPosition(BuildContext context) async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null; // Future.error('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null; // Future.error('Location permissions are denied');
      }
    } else if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return null; // Future.error('Location permissions are permanently denied, we cannot request permissions.');
      }
    }

    return await showFutureProgressDialog<Position>(
        context: context, initFuture: () => Geolocator.getCurrentPosition());
  }
}
