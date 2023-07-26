class ProfileTabIndexProvider {
  int? _index;

  ProfileTabIndexProvider() {
    _index = 0;
  }

  int? get index => _index;

  set index(int? value) {
    if (_index != value) {
      _index = value;
    }
  }
}
