import 'package:flutter/material.dart';
import 'package:traintastic/core/utils/constants/colors.dart';

// ignore: must_be_immutable
class CustomButton extends StatefulWidget {
  double width;
  bool isGhostButton;
  Function()? onTap;
  String text;

  CustomButton(
      {super.key,
      required this.width,
      required this.isGhostButton,
      required this.text,
      required this.onTap});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              widget.isGhostButton ? CColors.white : CColors.primary,
          foregroundColor:
              widget.isGhostButton ? CColors.primary : CColors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                  color: widget.isGhostButton
                      ? CColors.primary
                      : Colors.transparent,
                  width: widget.isGhostButton ? 1 : 0)),
        ),
        onPressed: widget.onTap,
        child: Text(widget.text),
      ),
    );
  }
}
