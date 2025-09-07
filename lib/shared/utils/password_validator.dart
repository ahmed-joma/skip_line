class PasswordValidator {
  static bool isValidPassword(String password) {
    return password.length >= 8 &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  static List<String> getPasswordErrors(String password) {
    List<String> errors = [];

    if (password.length < 8) {
      errors.add('Password must be at least 8 characters');
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      errors.add('Password must contain at least one number');
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      errors.add('Password must contain at least one uppercase letter');
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      errors.add('Password must contain at least one lowercase letter');
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      errors.add('Password must contain at least one special character');
    }

    return errors;
  }

  static List<String> getPasswordErrorsArabic(String password) {
    List<String> errors = [];

    if (password.length < 8) {
      errors.add('كلمة المرور يجب أن تكون 8 أحرف على الأقل');
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      errors.add('كلمة المرور يجب أن تحتوي على رقم واحد على الأقل');
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      errors.add('كلمة المرور يجب أن تحتوي على حرف كبير واحد على الأقل');
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      errors.add('كلمة المرور يجب أن تحتوي على حرف صغير واحد على الأقل');
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      errors.add('كلمة المرور يجب أن تحتوي على رمز خاص واحد على الأقل');
    }

    return errors;
  }
}
