import 'package:flutter/material.dart';
import 'package:my_app/Controller/password_reset_controller.dart';
import 'package:my_app/Screen/login_screen.dart';
import 'package:my_app/Theme/theme.dart';
import 'package:my_app/Widget/button_primary.dart';
import 'package:get/get.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PasswordRestConroller());
    final _formKey = GlobalKey<FormState>();
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
                  "ForgetPassword",
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
                    " Enter Your Email Address",
                    style: tpharagraph2,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.email,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: "Email",
                      hintText: "Email"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter the email Address";
                    }

                    final isEmailValid =
                        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);

                    if (!isEmailValid) return "Enter Valid Email Address";
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonPrimary(
                  text: "Next",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      PasswordRestConroller.instance
                          .passwordRest(controller.email.text.trim());
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
