class LoginFailure {
  final String message;

  LoginFailure([this.message = "An unknown error occurred"]);

  factory LoginFailure.code(String code) {
    switch (code) {
      case 'invalid-email':
        return LoginFailure("Email is not valid or badly formatted");
      case 'user-disabled':
        return LoginFailure(
            "This user has been disabled. Please contact support for help");
      case 'user-not-found':
        return LoginFailure("No user found with this email");
      case 'wrong-password':
        return LoginFailure("Invalid password. Please try again.");
      default:
        return LoginFailure();
    }
  }
}
