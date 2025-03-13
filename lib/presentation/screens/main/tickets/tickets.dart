import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traintastic/core/services/firestore_services.dart';
import 'package:traintastic/core/utils/constants/colors.dart';
import 'package:traintastic/data/models/tickets_model.dart';
import 'package:traintastic/presentation/screens/main/tickets/ticket_detail.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  List<Tickets> ticketList = [];
  void _fetchTickets() {
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    if (currentUserEmail == null) return;
    FirestoreServices().getTickets().listen((tickets) {
      setState(() {
        ticketList = tickets
            .where((ticket) => ticket.ticketHolder == currentUserEmail)
            .toList(); // Initially show ll locations
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tickets"),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: ticketList.isEmpty
                ? const Center(child: Text("No results found"))
                : ListView.builder(
                    itemCount: ticketList.length,
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
                                        title: ticketList[index].departure,
                                        subtitle: ticketList[index].departure,
                                      ),
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
                                        title: ticketList[index].destination,
                                        subtitle: ticketList[index].destination,
                                      ),
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
                                          time: ticketList[index].departureTime,
                                          date:
                                              ticketList[index].departureDate),
                                      TimeColumn(
                                          time: ticketList[index].arrivalTime,
                                          date:
                                              "Coach No: ${ticketList[index].coachNo}"),
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
                                        "Train: ${ticketList[index].trainName}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => TicketDetailsPage(
                                                    trainName: ticketList[index]
                                                        .trainName,
                                                    departureDate: ticketList[
                                                            index]
                                                        .departureDate,
                                                    departureTime:
                                                        ticketList[index]
                                                            .departureTime,
                                                    arrivalTime:
                                                        ticketList[index]
                                                            .arrivalTime,
                                                    from: ticketList[index]
                                                        .departure,
                                                    to: ticketList[index]
                                                        .destination,
                                                    selectedSeatList:
                                                        ticketList[index]
                                                            .seatList,
                                                    coachNo: ticketList[index]
                                                        .coachNo)));
                                          },
                                          child: const Text(
                                            "View Ticket",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  ),
                                  const SizedBox(height: 8),
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
