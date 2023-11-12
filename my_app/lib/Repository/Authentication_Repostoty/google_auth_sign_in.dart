import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthAPI {
  static final googleSignIn =
      GoogleSignIn(scopes: ['https://mail.google.com/']);
  static Future<GoogleSignInAccount?> signIn() async {
    try {
      return await googleSignIn.signIn();
    } catch (error) {
      print('Google Sign-In Error: $error');
      return null;
    }
  }

  static Future signOut() => googleSignIn.signOut();
}
