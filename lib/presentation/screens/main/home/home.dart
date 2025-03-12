import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:traintastic/core/utils/constants/colors.dart';
import 'package:traintastic/core/utils/helpers/helper_functions.dart';
import 'package:traintastic/data/models/core_model.dart';
import 'package:traintastic/presentation/screens/auth/login.dart';
import 'package:traintastic/presentation/screens/main/booking/location_search/location_search.dart';
import 'package:traintastic/presentation/screens/main/booking/trains/trains_depart.dart';
import 'package:traintastic/presentation/screens/main/profile/profile.dart';
import 'package:traintastic/presentation/screens/main/tickets/tickets.dart';
import 'package:traintastic/presentation/widgets/button.dart';
import 'package:traintastic/presentation/widgets/datepicker.dart';
import 'package:traintastic/presentation/widgets/textformfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController departureDateController = TextEditingController();
  TextEditingController returnTimeController = TextEditingController();
  TextEditingController passengersController = TextEditingController();

  int index = 0;
  int selectedChip = 0;
  bool isSearchWithoutValidation = false;

  IRawTimeSpan rawTimeSpan = IRawTimeSpan(
    date: DateTime.now(),
    startTime: DateTime.now(),
    endTime: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: index == 0
            ? Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        color: CColors.primary,
                        width: double.infinity,
                        height: 250,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(25, 50, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CircleAvatar(
                                      radius: 30,
                                      child: Icon(CupertinoIcons.person_fill),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    SizedBox(
                                      height: 60,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Jon Bovi",
                                            style:
                                                TextStyle(color: CColors.white),
                                          ),
                                          Text(
                                            "jonbovi@gmail.com",
                                            style:
                                                TextStyle(color: CColors.white),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()));
                                  },
                                  child: Text(
                                    "Logout",
                                    style: TextStyle(color: CColors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 30,
                    top: 130,
                    right: 30,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: CColors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.2), // Shadow color
                                    blurRadius: 10, // Softness of the shadow
                                    spreadRadius:
                                        2, // How much the shadow spreads
                                    offset: const Offset(
                                        4, 4), // Shadow position (X, Y)
                                  ),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ChoiceChip(
                                        label: const Text("One Way"),
                                        selected: selectedChip == 0,
                                        selectedColor: CColors
                                            .primary, // Color when selected
                                        onSelected: (bool selected) {
                                          setState(() {
                                            selectedChip = 0;
                                          });
                                        },
                                        labelStyle: TextStyle(
                                          color: selectedChip == 0
                                              ? CColors.tertiary
                                              : CColors.secondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                          width: 12), // Space between chips
                                      ChoiceChip(
                                        label: const Text("Return Trip"),
                                        selected: selectedChip == 1,
                                        selectedColor: CColors.primary,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            selectedChip = 1;
                                          });
                                        },
                                        labelStyle: TextStyle(
                                          color: selectedChip == 1
                                              ? CColors.tertiary
                                              : CColors.secondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  CustomPaint(
                                    size: const Size(double.infinity, 1),
                                    painter: DashPainter(),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  CustomTextFormField(
                                      onTap: () async {
                                        String? departLocation =
                                            await showDialog(
                                                context: context,
                                                useSafeArea: false,
                                                builder: (context) =>
                                                    Dialog.fullscreen(
                                                      child: LocationSearchPage(
                                                        selectable: true,
                                                        refreshCallback: () {},
                                                      ),
                                                    ));
                                        if (departLocation != null) {
                                          fromController.text = departLocation;
                                        } else {
                                          fromController.text = "";
                                        }
                                      },
                                      keyboardType: null,
                                      controller: fromController,
                                      obscureText: false,
                                      isPasswordField: false,
                                      hintText: "Location",
                                      label: "From"),
                                  HelperFunctions.showErrorMessage(
                                      fromController.text.isEmpty &&
                                          isSearchWithoutValidation,
                                      "Fields cannot be empty"),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  CustomTextFormField(
                                      onTap: () async {
                                        String? destination = await showDialog(
                                            context: context,
                                            useSafeArea: false,
                                            builder: (context) =>
                                                Dialog.fullscreen(
                                                  child: LocationSearchPage(
                                                    selectable: true,
                                                    refreshCallback: () {},
                                                  ),
                                                ));
                                        if (destination != null) {
                                          toController.text = destination;
                                        } else {
                                          toController.text = "";
                                        }
                                      },
                                      keyboardType: null,
                                      controller: toController,
                                      obscureText: false,
                                      isPasswordField: false,
                                      hintText: "Location",
                                      label: "To"),
                                  HelperFunctions.showErrorMessage(
                                      toController.text.isEmpty &&
                                          isSearchWithoutValidation,
                                      "Fields cannot be empty"),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  CustomDatePicker(
                                    textEditingController:
                                        departureDateController,
                                    mode: CupertinoDatePickerMode.date,
                                    targetValue: rawTimeSpan.endTime,
                                    label: "Departure",
                                    hintText: "Date",
                                  ),
                                  HelperFunctions.showErrorMessage(
                                      departureDateController.text.isEmpty &&
                                          isSearchWithoutValidation,
                                      "Fields cannot be empty"),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  selectedChip == 0
                                      ? const SizedBox.shrink()
                                      : Column(
                                          children: [
                                            CustomDatePicker(
                                              textEditingController:
                                                  returnTimeController,
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                              targetValue: rawTimeSpan.endTime,
                                              label: "Return",
                                              hintText: "Date",
                                            ),
                                            HelperFunctions.showErrorMessage(
                                                returnTimeController
                                                        .text.isEmpty &&
                                                    isSearchWithoutValidation,
                                                "Fields cannot be empty"),
                                          ],
                                        ),
                                  selectedChip == 0
                                      ? const SizedBox.shrink()
                                      : const SizedBox(
                                          height: 12,
                                        ),
                                  CustomTextFormField(
                                      onTap: null,
                                      keyboardType: TextInputType.number,
                                      controller: passengersController,
                                      obscureText: false,
                                      isPasswordField: false,
                                      hintText: "1",
                                      label: "Guest(s)"),
                                  HelperFunctions.showErrorMessage(
                                      passengersController.text.isEmpty &&
                                          isSearchWithoutValidation,
                                      "Fields cannot be empty"),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  CustomPaint(
                                    size: const Size(double.infinity, 1),
                                    painter: DashPainter(),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  CustomButton(
                                      width: 400,
                                      isGhostButton: false,
                                      text: "Search",
                                      onTap: () {
                                        setState(() {
                                          isSearchWithoutValidation = true;
                                        });
                                        if (fromController.text.isNotEmpty &&
                                            toController.text.isNotEmpty) {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => TrainsDepartPage(
                                                  from: fromController.text,
                                                  to: toController.text,
                                                  departureDate:
                                                      departureDateController
                                                          .text,
                                                  returnDate:
                                                      returnTimeController
                                                              .text.isNotEmpty
                                                          ? returnTimeController
                                                              .text
                                                          : null,
                                                  passengers: int.parse(
                                                      passengersController
                                                          .text))));
                                        } else {
                                          HelperFunctions.showToast(
                                              context,
                                              "Please enter all fields",
                                              ToastificationType.error,
                                              CupertinoIcons
                                                  .exclamationmark_circle);
                                        }
                                      })
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : index == 1
                ? const TicketsPage()
                : const ProfilePage(),
        extendBody: true,
        bottomNavigationBar: FloatingNavbar(
          onTap: (int val) {
            setState(() {
              index = val;
            });
          },
          currentIndex: index,
          iconSize: 20,
          backgroundColor: CColors.secondary,
          selectedBackgroundColor: CColors.white,
          selectedItemColor: CColors.primary,
          unselectedItemColor: CColors.white,
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(5),
          items: [
            FloatingNavbarItem(icon: CupertinoIcons.house_fill, title: 'Home'),
            FloatingNavbarItem(
                icon: CupertinoIcons.tickets_fill, title: 'Tickets'),
            FloatingNavbarItem(
                icon: CupertinoIcons.person_circle_fill, title: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double dashWidth = 5, dashSpace = 5, startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
