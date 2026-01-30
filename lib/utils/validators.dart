class Validators {
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name cannot be empty';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username cannot be empty';
    }
    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  static String? validateAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) {
      return 'Please select your date of birth';
    }

    final today = DateTime.now();
    final age = today.year - dateOfBirth.year;
    final monthDiff = today.month - dateOfBirth.month;
    final dayDiff = today.day - dateOfBirth.day;

    final actualAge =
        monthDiff < 0 || (monthDiff == 0 && dayDiff < 0) ? age - 1 : age;

    if (actualAge < 13) {
      return 'You must be at least 13 years old';
    }
    return null;
  }

  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your gender';
    }
    return null;
  }

  static String? validateInstagram(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Instagram username cannot be empty';
    }
    return null;
  }

  static String? validateYoutube(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'YouTube channel username cannot be empty';
    }
    return null;
  }
}
