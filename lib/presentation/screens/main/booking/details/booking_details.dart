// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traintastic/core/utils/constants/colors.dart';
import 'package:traintastic/core/utils/helpers/helper_functions.dart';
import 'package:traintastic/presentation/screens/main/home/home.dart';

// ignore: must_be_immutable
class BookingDetailsPage extends StatefulWidget {
  String trainName;
  String trainNo;
  String departureDate;
  String departureTime;
  String arrivalTime;
  String totalAmount;
  String from;
  String to;
  List<String> selectedSeatList;
  String trainId;
  String selectedCoachId;
  String coachNo;
  BookingDetailsPage({
    super.key,
    required this.trainNo,
    required this.trainName,
    required this.departureDate,
    required this.departureTime,
    required this.totalAmount,
    required this.arrivalTime,
    required this.from,
    required this.to,
    required this.selectedSeatList,
    required this.trainId,
    required this.selectedCoachId,
    required this.coachNo,
  });

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  String? _cardType;
  void detectCardType(String cardNumber) {
    String cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');

    if (RegExp(r'^4').hasMatch(cleanNumber)) {
      setState(() => _cardType = "visa");
    } else if (RegExp(
            r'^(5[1-5]|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)')
        .hasMatch(cleanNumber)) {
      setState(() => _cardType = "mastercard");
    } else {
      setState(() => _cardType = null);
    }
  }

  void bookSeat(List seats) async {
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    for (var seat in seats) {
      await FirebaseFirestore.instance
          .collection("trains")
          .doc(widget.trainId)
          .collection("coaches")
          .doc(widget.selectedCoachId)
          .collection("seats")
          .doc(seat)
          .update({
        "isSelected": true,
        "lockedBy": currentUserEmail,
        "isBooked": true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.tertiary,
      appBar: AppBar(
        backgroundColor: CColors.tertiary,
        title: const Text("Booking"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.trainName,
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CityColumn(title: widget.from, subtitle: widget.from),
                          Column(
                            children: [
                              Icon(Icons.directions_transit,
                                  color: CColors.primary),
                              const SizedBox(height: 4),
                              Container(
                                width: 60,
                                height: 2,
                                color: CColors.primary,
                              ),
                            ],
                          ),
                          CityColumn(title: widget.to, subtitle: widget.to),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TimeColumn(
                              time: widget.departureTime,
                              date: HelperFunctions.formatDate2(
                                  widget.departureDate)),
                          TimeColumn(
                              time: widget.arrivalTime,
                              date: "Train No: ${widget.trainNo}"),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total Price: ${widget.totalAmount}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaymentField(
                    label: "Card Holder Name",
                    hintText: "Enter Name",
                    type: TextInputType.text,
                    obscure: false,
                  ),
                  const SizedBox(height: 10),
                  PaymentField(
                      label: "Card Number",
                      hintText: "Valid Card Number",
                      type: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        CardNumberFormatter(),
                      ],
                      onChanged: detectCardType,
                      obscure: false,
                      suffixIcon: _cardType != null
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(
                                _cardType == "visa"
                                    ? 'assets/images/vsa.png'
                                    : 'assets/images/mst.png',
                                width: 30,
                                height: 30,
                              ),
                            )
                          : null),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: PaymentField(
                          label: "Date",
                          hintText: "DD/YY",
                          type: TextInputType.text,
                          obscure: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            DateFormatter()
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: PaymentField(
                          label: "CVV",
                          hintText: "CVV",
                          type: TextInputType.number,
                          obscure: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3)
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  bookSeat(widget.selectedSeatList);
                  await FirebaseFirestore.instance
                      .collection("tickets")
                      .doc(HelperFunctions.generateFirestoreDocId(
                          FirebaseAuth.instance.currentUser!.email.toString()))
                      .set({
                    "arrivalTime": widget.arrivalTime,
                    "departure": widget.from,
                    "departureDate": widget.departureDate,
                    "departureTime": widget.departureTime,
                    "destination": widget.to,
                    "trainName": widget.trainName,
                    "ticketHolder": FirebaseAuth.instance.currentUser!.email,
                    "seatList": widget.selectedSeatList,
                    "coachNo": widget.coachNo,
                  });
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => HomePage(
                            navIndex: 1,
                          )));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text("Pay",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class CityColumn extends StatelessWidget {
  final String title, subtitle;
  const CityColumn({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class TimeColumn extends StatelessWidget {
  final String time, date;
  const TimeColumn({super.key, required this.time, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(time,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CColors.primary)),
        const SizedBox(height: 4),
        Text(date, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 20.0;
    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    path.addOval(
        Rect.fromCircle(center: Offset(0, size.height / 2), radius: radius));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 2), radius: radius));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
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

class PaymentField extends StatelessWidget {
  final String label;
  final String hintText;
  final Widget? suffixIcon;
  final TextInputType type;
  final bool obscure;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;

  PaymentField(
      {required this.label,
      required this.hintText,
      this.suffixIcon,
      required this.type,
      required this.obscure,
      this.inputFormatters,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          onChanged: onChanged,
          keyboardType: type,
          obscureText: obscure,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

/// Formats card number as XXXX XXXX XXXX XXXX
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = '';

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) formatted += ' ';
      formatted += digits[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formats date as MM/YY
class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = '';

    if (digits.length > 2) {
      formatted = '${digits.substring(0, 2)}/${digits.substring(2)}';
    } else {
      formatted = digits;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
