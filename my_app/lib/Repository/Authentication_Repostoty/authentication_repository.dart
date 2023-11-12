import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:my_app/Repository/Authentication_Repostoty/Exception/login_failture.dart';
import 'package:my_app/Repository/Authentication_Repostoty/Exception/signup_email_password_failure.dart';
import 'package:my_app/Screen/dashboard.dart';
import 'package:my_app/Screen/login_screen.dart';
import 'package:my_app/Screen/mail_verification_screen.dart';
import 'package:my_app/Screen/splash_screen.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //variable
  final _auth = FirebaseAuth.instance;
  //late final Rx<User?> firebaseUser;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;
  //will be load when app launches this func called and the set the firebaseUser State
  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    //ever(firebaseUser, _setIntialScreen);
    setIntialScreen(firebaseUser.value);
  }

//Setting Intial Screen onLoad
  setIntialScreen(User? user) {
    //Get.offAll(() => const SplashScreen());
    user == null
        ? Get.offAll(() => const SplashScreen())
        : user.emailVerified
            ? Get.offAll(() => const Dashboard())
            : Get.offAll(() => const MailVerificationScreen());
  }

//func
  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
          //authentivation successful, do something
        },
        codeSent: ((verificationId, resendingToken) {
          // codesent to phonenumber,sace verification ID for later use
          this.verificationId.value = verificationId;
        }),
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId.value = verificationId;
        },
        verificationFailed: (e) {
          print(e.code);
          if (e.code == 'invalid-phone-number') {
            Get.snackbar("Error", "This provide phone number is not valid");
          } else {
            Get.snackbar("Error", "Something went wrong. try agrain.");
          }
        });
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(
      PhoneAuthProvider.credential(
          verificationId: verificationId.value, smsCode: otp),
    );

    return credentials.user != null ? true : false;
  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      print("error: $e");
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      firebaseUser.value == null
          // ? Get.offAll(const Dashboard())
          // : Get.offAll(const SplashScreen());
          ? Get.offAll(() => const SplashScreen())
          : firebaseUser.value!.emailVerified
              ? Get.offAll(() => const Dashboard())
              : Get.offAll(() => const MailVerificationScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailPasswordFailture.code(e.code);
      print('FireBase Auth exception - ${ex.message}');
      print('Firebase Error Code - ${e.code}');
      Get.snackbar("Error", ex.message);
      throw ex;
    } catch (_) {
      final ex = SignUpWithEmailPasswordFailture();
      print("Exception - ${ex.message}");

      throw ex;
    }
  }

  Future<void> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Check if the user's account is disabled
        final userEmail =
            currentUser.email ?? ''; // Use a default value if email is null
        final isActive = await isAccountDisabled(userEmail);
        if (isActive == "Deactive") {
          // User is disabled, sign them out and show an appropriate message
          await _auth.signOut();
          Get.offAll(const LoginScreen());
          Get.snackbar("Error",
              "Your account is disabled.Please Contact Administration");
          return;
        } else {
          firebaseUser.value != null
              ? Get.offAll(const Dashboard())
              : Get.offAll(const SplashScreen());
        }
      }
    } on FirebaseAuthException catch (e) {
      final failure = LoginFailure.code(e.code);
      print('Firebase Auth exception - ${failure.message}');
      print('Firebase Error Code - ${e.code}');
      Get.snackbar("Error", failure.message);
      throw failure;
    } catch (_) {
      final failure = LoginFailure();
      print("Exception - ${failure.message}");
      throw failure;
    }
  }

  Future<void> passwordRest(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email).then(
            (value) => {
              print("email Sent"),
              Get.snackbar("Success", "Check Your Emails"),
              Get.to(() => const LoginScreen()),
            },
          );
    } catch (e) {
      Get.snackbar("Error", "Something Gone wrong .Try Again");
      print("error: $e");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.to(() => const LoginScreen());
  }

  Future<String> isAccountDisabled(String userEmail) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs[0].data();
        final isActive = userData['status'] ?? 'Active';
        return isActive;
      } else {
        // User not found, consider handling this case accordingly
        return 'Active';
      }
    } catch (e) {
      // Handle any potential errors here
      print(e);
      return 'Active';
    }
  }
}
