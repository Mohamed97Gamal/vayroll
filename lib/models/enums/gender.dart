enum Gender { Male, Female, Other }

extension GenderProps on Gender? {
  String? get name {
    switch (this) {
      case Gender.Male:
        return "Male".toUpperCase();
      case Gender.Female:
        return "Female".toUpperCase();
      case Gender.Other:
        return "Other".toUpperCase();
      default:
        return null;
    }
  }
}
