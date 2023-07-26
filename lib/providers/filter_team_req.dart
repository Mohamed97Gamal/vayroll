import 'package:flutter/material.dart';

class FilterTeamRequestsProvider extends ChangeNotifier {
  List<String> _requestsTypes = [];
  bool _behalfOfMe = false;
  bool? _byMe = false;
  DateTime? _fromClosedDate;
  DateTime? _toClosedDate;
  DateTime? _fromSubmissionDate;
  DateTime? _toSubmissionDate;

  List<String> get requestsTypes => _requestsTypes;
  bool get behalfOfMe => _behalfOfMe;
  bool? get byMe => _byMe;
  DateTime? get fromClosedDate => _fromClosedDate;
  DateTime? get toClosedDate => _toClosedDate;
  DateTime? get fromSubmissionDate => _fromSubmissionDate;
  DateTime? get toSubmissionDate => _toSubmissionDate;

  set requestsTypes(List<String> value) {
    _requestsTypes = value;
    notifyListeners();
  }

  set behalfOfMe(bool value) {
    _behalfOfMe = value;
    notifyListeners();
  }

  set byMe(bool? value) {
    _byMe = value;
    notifyListeners();
  }

  set fromClosedDate(DateTime? value) {
    _fromClosedDate = value;
    notifyListeners();
  }

  set toClosedDate(DateTime? value) {
    _toClosedDate = value;
    notifyListeners();
  }

  set fromSubmissionDate(DateTime? value) {
    _fromSubmissionDate = value;
    notifyListeners();
  }

  set toSubmissionDate(DateTime? value) {
    _toSubmissionDate = value;
    notifyListeners();
  }
}
