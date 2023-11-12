class SignUpWithEmailPasswordFailture {
  final String message;
  SignUpWithEmailPasswordFailture([this.message = "An unknown error occurred"]);
  factory SignUpWithEmailPasswordFailture.code(String code) {
    switch (code) {
      case 'weak-password':
        return SignUpWithEmailPasswordFailture(
            "Please enter a stronger password");
      case 'invalid-email':
        return SignUpWithEmailPasswordFailture(
            "Email is not valid or badly formatted");
      case 'email-already-in-use':
        return SignUpWithEmailPasswordFailture(
            "An account already exists for that email");
      case 'operation-not-allowed':
        return SignUpWithEmailPasswordFailture(
            "operation is not allowed. Please conatact support");
      case 'user-disabled':
        return SignUpWithEmailPasswordFailture(
            "This user has been disable . Please contact support for help");
      default:
        return SignUpWithEmailPasswordFailture();
    }
  }
}
