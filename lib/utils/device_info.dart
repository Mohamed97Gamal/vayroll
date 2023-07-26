import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:vayroll/models/device_information.dart';

class DeviceInfo {
  late DeviceInfoPlugin deviceInfo;

  DeviceInfo() {
    deviceInfo = DeviceInfoPlugin();
  }

  Future<DeviceInformation?> getDeviceInfo() async {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return DeviceInformation(
        androidInfo.id,
        androidInfo.device,
        androidInfo.manufacturer,
      );
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return DeviceInformation(
        iosInfo.identifierForVendor,
        iosInfo.utsname.machine,
        iosInfo.model,
      );
    }
    return null;
  }
}
