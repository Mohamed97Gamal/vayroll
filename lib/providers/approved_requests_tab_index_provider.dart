class ApprovedRequestsTabIndexProvider {
  int? _index;

  ApprovedRequestsTabIndexProvider() {
    _index = 0;
  }

  int? get index => _index;

  set index(int? value) {
    if (_index != value) {
      _index = value;
    }
  }
}
