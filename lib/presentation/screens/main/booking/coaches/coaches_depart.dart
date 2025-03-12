import 'package:flutter/material.dart';
import 'package:traintastic/core/utils/constants/colors.dart';

// ignore: must_be_immutable
class CoachesDepartPage extends StatefulWidget {
  double ticketPrice;
  int passengers;
  String trainName;
  CoachesDepartPage({
    super.key,
    required this.ticketPrice,
    required this.passengers,
    required this.trainName,
  });

  @override
  State<CoachesDepartPage> createState() => _CoachesDepartPageState();
}

class _CoachesDepartPageState extends State<CoachesDepartPage> {
  String selectedCoach = "Coach 1";
  final List<String> coaches = [
    "Coach 1",
    "Coach 2",
    "Coach 3",
    "Coach 4",
    "Coach 5",
    "Coach 6"
  ];
  final Map<String, String> seatStatus = {
    "A1": "available",
    "A2": "available",
    "A3": "booked",
    "A4": "available",
    "B1": "available",
    "B2": "booked",
    "B3": "available",
    "B4": "booked",
    "C1": "available",
    "C2": "available",
    "C3": "booked",
    "C4": "available",
    "D1": "available",
    "D2": "available",
    "D3": "booked",
    "D4": "available",
    "E1": "booked",
    "E2": "available",
    "E3": "booked",
    "E4": "available",
  };

  int get availableSeats =>
      seatStatus.values.where((status) => status == "available").length;

  List<String> get selectedSeats => seatStatus.entries
      .where((entry) => entry.value == "selected")
      .map((entry) => entry.key)
      .toList();

  double get totalPrice => selectedSeats.length * widget.ticketPrice;

  void toggleSeat(String seat) {
    int maxSeats = widget.passengers;
    setState(() {
      if (seatStatus[seat] == "available") {
        if (selectedSeats.length < maxSeats) {
          seatStatus[seat] = "selected";
        }
      } else if (seatStatus[seat] == "selected") {
        seatStatus[seat] = "available";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.tertiary,
      appBar: AppBar(
        backgroundColor: CColors.tertiary,
        title: const Text("Select Your Seat(s)"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Coach selection
            DropdownButton<String>(
              value: selectedCoach,
              items: coaches.map((coach) {
                return DropdownMenuItem(value: coach, child: Text(coach));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedCoach = val!;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Seats Left: $availableSeats",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Seat Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                seatIndicator(Colors.grey, "Available"),
                const SizedBox(width: 10),
                seatIndicator(Colors.red, "Booked"),
                const SizedBox(width: 10),
                seatIndicator(CColors.primary, "Selected"),
              ],
            ),
            const SizedBox(height: 20),

            // Seat Grid
            SizedBox(
              height: 300,
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      seatColumn(["A", "B", "C", "D", "E"], leftSide: true),
                      const VerticalDivider(
                        thickness: 1,
                      ),
                      seatColumn(["A", "B", "C", "D", "E"], leftSide: false),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Ticket Summary Card
            if (selectedSeats.isNotEmpty)
              Card(
                margin: const EdgeInsets.all(16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ticketInfoRow("Train", widget.trainName),
                      const SizedBox(height: 10),
                      ticketInfoRow("Your Seat(s)", selectedSeats.join(" & ")),
                      const SizedBox(height: 10),
                      ticketInfoRow(
                          "Total Price", "RM${totalPrice.toStringAsFixed(2)}"),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: selectedSeats.length < widget.passengers
                              ? null
                              : () {
                                  // Handle ticket confirmation
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                                selectedSeats.length < widget.passengers
                                    ? "Selected ${selectedSeats.length} / ${widget.passengers}"
                                    : "Continue",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget ticketInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, color: Colors.black54)),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget seatIndicator(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }

  Widget seatColumn(List<String> rows, {required bool leftSide}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            seatBox("$row${leftSide ? 1 : 3}"),
            const SizedBox(width: 10),
            seatBox("$row${leftSide ? 2 : 4}"),
          ],
        );
      }).toList(),
    );
  }

  Widget seatBox(String seat) {
    Color seatColor;
    switch (seatStatus[seat]) {
      case "booked":
        seatColor = Colors.red;
        break;
      case "selected":
        seatColor = CColors.primary;
        break;
      default:
        seatColor = Colors.grey;
    }

    return GestureDetector(
      onTap: () => toggleSeat(seat),
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(seat,
            style: const TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }
}
