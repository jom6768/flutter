class AuthService {
  bool _loggedIn = false;

  bool get isLoggedIn => _loggedIn;

  Future<void> signIn(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      _loggedIn = true;
    }
  }

  Future<void> register(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      _loggedIn = true;
    }
  }

  Future<void> signOut() async {
    _loggedIn = false;
  }
}
