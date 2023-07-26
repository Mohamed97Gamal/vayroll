import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/repo/disk/disk_repo.dart';

class EmployeeProvider extends ChangeNotifier {
  Employee? _employee;

  var _isRunning = false;
  Timer? _retryTimer;

  void init() {
    refresh();
  }

  Future<BaseResponse<Employee>> get({bool force = false}) async {
    if (force != true && _employee != null) {
      return BaseResponse<Employee>(status: true, result: _employee);
    }

    _isRunning = true;
    _retryTimer?.cancel();
    final response = await ApiRepo().getMyEmployee();
    if (response.status!) {
      var emp = response.result!;

      final photoId = emp.photo?.id;
      if (photoId != null) {
        final picResponse = await ApiRepo().getFile(photoId);
        if (picResponse.status!) {
          emp = emp.copyWith(photoBase64: picResponse.result);
        }
      }
      employee = emp;
      response.result = emp;
      DiskRepo().saveEmployeeId(emp.id!);
    } else {
      _retryTimer = Timer(Duration(seconds: 3), refresh);
    }
    _isRunning = false;
    return response;
  }

  Employee? get employee {
    if (_employee == null) refresh();
    return _employee;
  }

  set employee(Employee? value) {
    if (_employee != value) {
      _employee = value;
      notifyListeners();
    }
  }

  void refresh() {
    if (!_isRunning) get(force: true);
  }

  void invalidate() => _employee = null;
}
