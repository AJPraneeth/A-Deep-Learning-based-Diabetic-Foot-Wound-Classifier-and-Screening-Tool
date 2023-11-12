// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Controller/login_controller.dart';
import 'package:my_app/Screen/forgetpassword.dart';
import 'package:my_app/Screen/register_usertype.dart';

import 'package:my_app/Widget/button_primary.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool obscurePassword = true;
  bool isLoading = false;
  late Future<void> logingFuture;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final _formKey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: controller.email,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
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
            const SizedBox(height: 7),
            TextFormField(
              controller: controller.password,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.password_outlined),
                labelText: "Password",
                hintText: "Password",
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  icon: Icon(obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgetPassword()));
                },
                child: const Text("Forget Passwords ?"),
              ),
            ),
            ButtonPrimary(
                text: "Login",
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    LoginController.instance.loginUser(
                        controller.email.text.trim(),
                        controller.password.text.trim());
                  }
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserType()));
                    },
                    child: const Text("SignUp"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
