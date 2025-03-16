import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toastification/toastification.dart';
import 'package:traintastic/core/utils/constants/colors.dart';
import 'package:traintastic/core/utils/helpers/helper_functions.dart';
import 'package:traintastic/presentation/widgets/button.dart';
import 'package:traintastic/presentation/widgets/textformfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();

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
                  height: 400,
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/images/forgot.svg",
                      width: 250,
                    ),
                  ),
                ),
                const Text(
                  "Forgot Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 16),
                  child: Text(
                    "Enter your email to reset your password",
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
                  ],
                )),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                    width: double.infinity,
                    isGhostButton: false,
                    text: "Reset Password",
                    onTap: () {
                      setState(() {
                        isLoginWithoutValidation = true;
                      });
                      if (emailController.text.isNotEmpty) {
                        HelperFunctions.showToast(
                            context,
                            "Please check your email for the new password",
                            ToastificationType.success,
                            CupertinoIcons.check_mark);
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
