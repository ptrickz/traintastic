import 'package:flutter/material.dart';
import 'package:traintastic/core/services/firestore_services.dart';
import 'package:traintastic/core/utils/constants/colors.dart';
import 'package:traintastic/core/utils/helpers/helper_functions.dart';
import 'package:traintastic/data/models/train_model.dart';
import 'package:traintastic/presentation/screens/main/booking/coaches/coach_seats.dart';

// ignore: must_be_immutable
class TrainsReturnPage extends StatefulWidget {
  String from;
  String to;
  String departureDate;
  String? returnDate;
  int passengers;
  TrainsReturnPage({
    super.key,
    required this.from,
    required this.to,
    required this.departureDate,
    required this.returnDate,
    required this.passengers,
  });

  @override
  State<TrainsReturnPage> createState() => _TrainsPageState();
}

class _TrainsPageState extends State<TrainsReturnPage> {
  List<Train> trainData = [];

  void _fetchTrains() {
    FirestoreServices().getTrains().listen((trains) {
      setState(() {
        trainData = trains;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTrains();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CColors.tertiary,
        appBar: AppBar(
          backgroundColor: CColors.tertiary,
          title: const Text("Available Departures"),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: trainData.isEmpty
                ? const Center(child: Text("No results found"))
                : ListView.builder(
                    itemCount: trainData.length,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ClipPath(
                          clipper: TicketClipper(),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CityColumn(
                                          title: widget.from,
                                          subtitle: widget.from),
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
                                      CityColumn(
                                          title: widget.to,
                                          subtitle: widget.to),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TimeColumn(
                                          time: "10:00 AM",
                                          date: HelperFunctions.formatDate2(
                                              widget.departureDate)),
                                      TimeColumn(
                                          time: "12:24 PM",
                                          date:
                                              "Train No: ${trainData[index].trainNo}"),
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        trainData[index].trainName,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        HelperFunctions.formatCurrency(
                                            trainData[index].ticketPrice),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(Icons.access_time,
                                              color: Colors.grey),
                                          SizedBox(width: 5),
                                          Text("18h 15m | Non-Stop"),
                                        ],
                                      ),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: CColors.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text("Select",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })));
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
