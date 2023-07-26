import 'package:flutter/material.dart';
import 'package:vayroll/widgets/widgets.dart';

class RequestsKeyProvider {
  GlobalKey<RefreshableState>? _mykey;
  GlobalKey<RefreshableState>? _teamKey;

  RequestsKeyProvider() {
    _mykey = GlobalKey<RefreshableState>();
    _teamKey = GlobalKey<RefreshableState>();
  }

  GlobalKey<RefreshableState>? get mykey => _mykey;
  GlobalKey<RefreshableState>? get teamkey => _teamKey;
}
