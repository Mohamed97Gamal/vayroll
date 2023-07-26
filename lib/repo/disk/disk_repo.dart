import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vayroll/models/attendance/check_in_out.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:pointycastle/asymmetric/api.dart';

class DiskRepo {
  static final DiskRepo _singleton = DiskRepo._internal();

  factory DiskRepo() {
    return _singleton;
  }

  DiskRepo._internal();

  saveTokens(String accessToken, String refreshToken) async {
    final publicKey = RSAKeyParser().parse(Encryption.publicKey);
    final encryptor = Encrypter(RSA(publicKey: publicKey as RSAPublicKey));

    final encryptedAccessToken = encryptor.encrypt(accessToken).base64;
    final encryptedRefreshToken = encryptor.encrypt(refreshToken).base64;

    printIfDebug('Encrypted Access Token:' + encryptedAccessToken);
    printIfDebug('Encrypted Refresh Token:' + encryptedRefreshToken);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', encryptedAccessToken);
    await prefs.setString('refresh_token', encryptedRefreshToken);
  }

  saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  saveEmployeeId(String employeeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('employee_id', employeeId);
  }

  saveDataConsentAccept(bool accept) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('data_consent', accept);
  }

  Future<List<String?>> getTokens() async {
    final prefs = await SharedPreferences.getInstance();
    return [prefs.getString('access_token'), prefs.getString('refresh_token')];
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<String?> getEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('employee_id');
  }

  Future<bool?> getDataConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('data_consent');
  }

  saveFirstTimeLogin(bool firstTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time_login', firstTime);
  }

  Future<bool?> getFirstTimeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('first_time_login');
  }

  saveFcmToken(String fcmToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', fcmToken);
  }

  Future<String?> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }

  Future<List<DashboardWidget>?> getWidgets() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = await getUserId();
    var data = prefs.getString('widgets_$userId');
    return data == null
        ? null
        : (jsonDecode(data) as List?)
            ?.map((e) => DashboardWidget.fromJson(e as Map<String, dynamic>))
            .toList();
  }

  Future<bool> saveWidgets(List<DashboardWidget> value) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = await getUserId();
    return await prefs.setString('widgets_$userId', jsonEncode(value));
  }

  Future<bool> getIsCheckedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isCheckedIn') ?? false;
  }

  saveIsCheckedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('isCheckedIn', value);
  }

  Future<CheckInOut?> getCheckInData() async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('checkInData');
    return data == null ? null : CheckInOut.fromJson(jsonDecode(data));
  }

  saveCheckInData(CheckInOut value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString('checkInData', jsonEncode(value));
  }

  removeCheckInData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('checkInData');
  }

  removeIsCheckedIn() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('isCheckedIn');
  }

  Future<bool> getOrgChartShowcaseDisplayed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('OrgChartShowcaseDisplayed') ?? false;
  }

  Future<bool> saveOrgChartShowcaseDisplayed(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool('OrgChartShowcaseDisplayed', value);
  }
}
