import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traintastic/core/utils/constants/colors.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatefulWidget {
  TextEditingController controller;
  TextInputType? keyboardType;
  bool obscureText;
  bool isPasswordField;
  String hintText;
  String label;
  GestureTapCallback? onTap;

  CustomTextFormField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.obscureText,
    required this.isPasswordField,
    required this.hintText,
    required this.label,
    required this.onTap,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: CColors.tertiary, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        onTap: widget.onTap,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        controller: widget.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: CupertinoColors.placeholderText),
          prefixIcon: SizedBox(
            width: 110,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
          suffixIcon: widget.isPasswordField
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.obscureText = !widget.obscureText;
                    });
                  },
                  child: Icon(
                    widget.obscureText
                        ? CupertinoIcons.eye_slash_fill
                        : CupertinoIcons.eye_fill,
                    size: 20,
                    color: CupertinoColors.systemGrey2,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
