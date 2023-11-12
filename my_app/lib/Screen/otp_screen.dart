import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:my_app/Controller/otp_controller.dart';
import 'package:my_app/Screen/login_screen.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/button_primary.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var otp;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            color: blackColor,
          ),
          title: const Text("Back", style: TextStyle(color: blackColor)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "OTP",
                  style: title,
                ),
              ),
              Center(
                child: Text(
                  " Verification",
                  style: title,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    " Enter OTP verification Code",
                    style: tpharagraph2,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              OtpTextField(
                numberOfFields: 6,
                fillColor: Colors.black.withOpacity(0.1),
                filled: true,
                onSubmit: (value) {
                  otp = value;
                  OTPController.instance.verifyOTP(otp);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonPrimary(
                  text: "Next",
                  onTap: () {
                    OTPController.instance.verifyOTP(otp);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
