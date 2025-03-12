import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:traintastic/core/utils/constants/colors.dart';
import 'package:traintastic/core/utils/helpers/helper_functions.dart';
import 'package:traintastic/presentation/screens/auth/forgot_password.dart';
import 'package:traintastic/presentation/screens/auth/register.dart';
import 'package:traintastic/presentation/screens/main/home/home.dart';
import 'package:traintastic/presentation/widgets/button.dart';
import 'package:traintastic/presentation/widgets/textformfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showPassword = false;
  bool isLoginWithoutValidation = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
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
                    child: Image.asset(
                      "assets/images/tren.png",
                      width: 150,
                    ),
                  ),
                ),
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 16),
                  child: Text(
                    "Enter your credentials to access your account",
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
                        label: "Password"),
                    HelperFunctions.showErrorMessage(
                        passwordController.text.isEmpty &&
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
                    text: "Login",
                    onTap: () {
                      setState(() {
                        isLoginWithoutValidation = true;
                      });
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HomePage()));
                      } else {
                        HelperFunctions.showToast(
                            context,
                            "Please enter all fields",
                            ToastificationType.error,
                            CupertinoIcons.exclamationmark_circle);
                      }
                    }),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordPage()));
                        },
                        child: Text(
                          "Forgot password?",
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: CupertinoColors.systemGrey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegisterPage()));
                        },
                        child: Text(
                          "Register",
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: CupertinoColors.systemGrey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
