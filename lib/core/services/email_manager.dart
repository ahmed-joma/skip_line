class EmailManager {
  static final EmailManager _instance = EmailManager._internal();
  factory EmailManager() => _instance;
  EmailManager._internal();

  String? _resetEmail;

  void setResetEmail(String email) {
    _resetEmail = email;
  }

  String? get resetEmail => _resetEmail;

  void clearResetEmail() {
    _resetEmail = null;
  }
}
