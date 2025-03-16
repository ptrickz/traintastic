import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traintastic/core/utils/constants/colors.dart';
import 'package:traintastic/core/utils/helpers/helper_functions.dart';

// ignore: must_be_immutable
class CustomDatePicker extends StatefulWidget {
  TextEditingController textEditingController;
  CupertinoDatePickerMode mode;
  DateTime targetValue;
  String label;
  String hintText;
  DateTime? maximumTime;
  DateTime? minimumTime;
  DateTime? initialTime;
  CustomDatePicker({
    super.key,
    required this.textEditingController,
    required this.mode,
    required this.targetValue,
    required this.label,
    required this.hintText,
    this.maximumTime,
    this.minimumTime,
    this.initialTime,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: CColors.tertiary, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        enableInteractiveSelection: false,
        showCursor: false,
        controller: widget.textEditingController,
        keyboardType: TextInputType.none,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: CupertinoColors.placeholderText,
                ),
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
            )),
        onTap: () {
          widget.textEditingController.clear();
          DateTime tempSelectedValue = widget.targetValue;
          showCupertinoDialog(
            context: (context),
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                content: SizedBox(
                  height: 150,
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: TextStyle(
                      color: CupertinoColors.black,
                      fontSize: 16,
                    ))),
                    child: CupertinoDatePicker(
                      maximumDate: widget.maximumTime,
                      minimumDate: widget.minimumTime,
                      initialDateTime: widget.initialTime,
                      mode: widget.mode == CupertinoDatePickerMode.time
                          ? CupertinoDatePickerMode.time
                          : CupertinoDatePickerMode.date,
                      use24hFormat: true,
                      onDateTimeChanged: (value) {
                        setState(() {
                          tempSelectedValue = value;
                        });
                      },
                    ),
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: CupertinoColors.systemRed,
                          ),
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(
                      'OK',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: CupertinoColors.activeBlue,
                          ),
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        widget.targetValue = tempSelectedValue;
                        widget.textEditingController.text = widget.mode ==
                                CupertinoDatePickerMode.time
                            ? HelperFunctions.formatTime(widget.targetValue)
                            : HelperFunctions.formatDate(widget.targetValue);
                      });
                      widget.textEditingController.removeListener(() {});

                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
