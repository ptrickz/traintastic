// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toastification/toastification.dart';
import 'package:traintastic/core/services/auth_service.dart';
import 'package:traintastic/core/utils/constants/colors.dart';
import 'package:traintastic/core/utils/helpers/helper_functions.dart';
import 'package:traintastic/presentation/screens/main/home/home.dart';
import 'package:traintastic/presentation/widgets/button.dart';
import 'package:traintastic/presentation/widgets/textformfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool showPassword = false;
  bool showCfPassword = false;
  bool isLoginWithoutValidation = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: CColors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 350,
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/images/register.svg",
                      width: 250,
                    ),
                  ),
                ),
                const Text(
                  "Register",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 16),
                  child: Text(
                    "Enter your credentials to register your account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Form(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextFormField(
                      onTap: null,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      obscureText: false,
                      isPasswordField: false,
                      hintText: "Type here...",
                      label: "Email",
                    ),
                    HelperFunctions.showErrorMessage(
                        emailController.text.isEmpty &&
                            isLoginWithoutValidation,
                        "Fields cannot be empty"),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomTextFormField(
                      onTap: null,
                      keyboardType: null,
                      controller: passwordController,
                      obscureText: !showPassword,
                      isPasswordField: true,
                      hintText: "●●●●●●●●",
                      label: "Password",
                    ),
                    HelperFunctions.showErrorMessage(
                        passwordController.text.isEmpty &&
                            isLoginWithoutValidation,
                        "Fields cannot be empty"),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomTextFormField(
                      onTap: null,
                      keyboardType: null,
                      controller: confirmPasswordController,
                      obscureText: !showCfPassword,
                      isPasswordField: true,
                      hintText: "●●●●●●●●",
                      label: "Confirm Password",
                    ),
                    HelperFunctions.showErrorMessage(
                        confirmPasswordController.text.isEmpty &&
                            isLoginWithoutValidation,
                        "Fields cannot be empty"),
                  ],
                )),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                    width: double.infinity,
                    isGhostButton: false,
                    text: "Register",
                    onTap: () async {
                      setState(() {
                        isLoginWithoutValidation = true;
                      });
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty &&
                          confirmPasswordController.text.isNotEmpty &&
                          (passwordController.text ==
                              confirmPasswordController.text)) {
                        String message = await AuthService().signup(
                            email: emailController.text,
                            password: passwordController.text);
                        if (message == "Success") {
                          HelperFunctions.showToast(
                              context,
                              message,
                              ToastificationType.success,
                              CupertinoIcons.check_mark_circled);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        navIndex: 0,
                                      )));
                        } else {
                          HelperFunctions.showToast(
                              context,
                              message,
                              ToastificationType.error,
                              CupertinoIcons.exclamationmark);
                        }
                      } else if (passwordController.text !=
                          confirmPasswordController.text) {
                        HelperFunctions.showToast(
                            context,
                            "Passwords do not match!",
                            ToastificationType.error,
                            CupertinoIcons.exclamationmark_circle);
                      } else {
                        HelperFunctions.showToast(
                            context,
                            "Please enter all fields",
                            ToastificationType.error,
                            CupertinoIcons.exclamationmark_circle);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
