// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:traintastic/core/utils/constants/colors.dart';
import 'package:traintastic/core/utils/helpers/helper_functions.dart';

// ignore: must_be_immutable
class TicketDetailsPage extends StatefulWidget {
  String trainName;
  String departureDate;
  String departureTime;
  String arrivalTime;
  String from;
  String to;
  List<String> selectedSeatList;
  String coachNo;
  TicketDetailsPage({
    super.key,
    required this.trainName,
    required this.departureDate,
    required this.departureTime,
    required this.arrivalTime,
    required this.from,
    required this.to,
    required this.selectedSeatList,
    required this.coachNo,
  });

  @override
  State<TicketDetailsPage> createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String qrDetails = HelperFunctions.formatTicketDetails(
      trainName: widget.trainName,
      departureDate: widget.departureDate,
      departureTime: widget.departureTime,
      arrivalTime: widget.arrivalTime,
      from: widget.from,
      to: widget.to,
      selectedSeatList: widget.selectedSeatList,
      coachNo: widget.coachNo,
    );
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
            Card(
              elevation: 5,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                        TimeColumn(time: widget.arrivalTime, date: ""),
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
                    Screenshot(
                      controller: screenshotController,
                      child: QrImageView(
                        data: qrDetails,
                        version: QrVersions.auto,
                        size: 200,
                        gapless: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await screenshotController
                      .capture(delay: const Duration(milliseconds: 10))
                      .then((capturedImage) async {
                    String base64Image =
                        HelperFunctions.uint8ListToBase64(capturedImage!);
                    await FlutterEmailSender.send(Email(
                      body: '''
                          <html>
                            <body>
                              <p>Here is your ticket QR:</p>
                              <img src="$base64Image" alt="Ticket Image" />
                            </body>
                          </html>
                        ''',
                      subject: 'Trainstastic Ticket QR',
                      recipients: [
                        FirebaseAuth.instance.currentUser!.email.toString()
                      ],
                      isHTML: true,
                    ));
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text("Send QR to Email",
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
