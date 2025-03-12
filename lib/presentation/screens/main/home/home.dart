import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traintastic/core/utils/constants/colors.dart';
import 'package:traintastic/data/models/core_model.dart';
import 'package:traintastic/presentation/screens/main/booking/location_search/location_search.dart';
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
  TextEditingController departureTimeController = TextEditingController();
  TextEditingController returnTimeController = TextEditingController();
  TextEditingController passengersController = TextEditingController();

  int index = 0;
  int selectedChip = 0;

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
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(25, 100, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  child: Icon(CupertinoIcons.person_fill),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                SizedBox(
                                  height: 60,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Jon Bovi"),
                                      Text("jonbovi@gmail.com"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 30,
                    top: 200,
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
                            height: selectedChip == 0 ? 450 : 500,
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
                                    height: 16,
                                  ),
                                  CustomPaint(
                                    size: const Size(double.infinity, 1),
                                    painter: DashPainter(),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  CustomTextFormField(
                                      onTap: () async {
                                        fromController.text = await showDialog(
                                            context: context,
                                            useSafeArea: false,
                                            builder: (context) =>
                                                Dialog.fullscreen(
                                                  child: LocationSearchPage(
                                                    selectable: true,
                                                    refreshCallback: () {},
                                                  ),
                                                ));
                                      },
                                      keyboardType: null,
                                      controller: fromController,
                                      obscureText: false,
                                      isPasswordField: false,
                                      hintText: "Location",
                                      label: "From"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  CustomTextFormField(
                                      onTap: () async {
                                        toController.text = await showDialog(
                                            context: context,
                                            useSafeArea: false,
                                            builder: (context) =>
                                                Dialog.fullscreen(
                                                  child: LocationSearchPage(
                                                    selectable: true,
                                                    refreshCallback: () {},
                                                  ),
                                                ));
                                      },
                                      keyboardType: null,
                                      controller: toController,
                                      obscureText: false,
                                      isPasswordField: false,
                                      hintText: "Location",
                                      label: "To"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  CustomDatePicker(
                                    textEditingController:
                                        departureTimeController,
                                    mode: CupertinoDatePickerMode.date,
                                    targetValue: rawTimeSpan.endTime,
                                    label: "Departure",
                                    hintText: "Date",
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  selectedChip == 0
                                      ? const SizedBox.shrink()
                                      : CustomDatePicker(
                                          textEditingController:
                                              returnTimeController,
                                          mode: CupertinoDatePickerMode.date,
                                          targetValue: rawTimeSpan.endTime,
                                          label: "Return",
                                          hintText: "Date",
                                        ),
                                  selectedChip == 0
                                      ? const SizedBox.shrink()
                                      : const SizedBox(
                                          height: 16,
                                        ),
                                  CustomTextFormField(
                                      onTap: null,
                                      keyboardType: TextInputType.number,
                                      controller: passengersController,
                                      obscureText: false,
                                      isPasswordField: false,
                                      hintText: "1",
                                      label: "Guest(s)"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  CustomPaint(
                                    size: const Size(double.infinity, 1),
                                    painter: DashPainter(),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  CustomButton(
                                      width: 400,
                                      isGhostButton: false,
                                      text: "Search",
                                      onTap: () {})
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
