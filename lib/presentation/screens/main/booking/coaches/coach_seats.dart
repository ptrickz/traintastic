import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traintastic/core/services/firestore_services.dart';
import 'package:traintastic/core/utils/constants/colors.dart';
import 'package:traintastic/core/utils/helpers/helper_functions.dart';
import 'package:traintastic/data/models/coaches_model.dart';
import 'package:traintastic/data/models/seats_model.dart';
import 'package:traintastic/presentation/screens/main/booking/details/booking_details.dart';
import 'package:traintastic/presentation/screens/main/booking/trains/trains_return.dart';

// ignore: must_be_immutable
class CoachSeatsDepartPage extends StatefulWidget {
  double ticketPrice;
  int passengers;
  String trainName;
  String trainNo;
  String trainId;
  String? returnDate;
  String departureDate;
  String from;
  String to;
  CoachSeatsDepartPage({
    super.key,
    required this.ticketPrice,
    required this.passengers,
    required this.trainName,
    required this.trainNo,
    required this.trainId,
    required this.returnDate,
    required this.departureDate,
    required this.from,
    required this.to,
  });

  @override
  State<CoachSeatsDepartPage> createState() => _CoachSeatsDepartPageState();
}

class _CoachSeatsDepartPageState extends State<CoachSeatsDepartPage> {
  Coaches? selectedCoach;
  List<Coaches> coaches = [];

  List<Seats> seats = [];
  final String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

  int get availableSeats =>
      seats.where((seat) => !seat.isBooked && seat.lockedBy.isEmpty).length;

  List<String> get selectedSeats => seats
      .where((seat) => seat.isSelected && seat.lockedBy == currentUserEmail)
      .map((seat) => seat.id)
      .toList();

  double get totalPrice => selectedSeats.length * widget.ticketPrice;

  void toggleSeat(String seatId) async {
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    int maxSeats = widget.passengers;

    Seats seat = seats.firstWhere((s) => s.id == seatId);

    if (!seat.isBooked) {
      if (seat.isSelected) {
        seat.isSelected = false;
        seat.lockedBy = "";
      } else if (selectedSeats.length < maxSeats) {
        seat.isSelected = true;
        seat.lockedBy = currentUserEmail!;
      }
    }

    // Firestore update
    await FirebaseFirestore.instance
        .collection("trains")
        .doc(widget.trainId)
        .collection("coaches")
        .doc(selectedCoach!.id)
        .collection("seats")
        .doc(seatId)
        .update({
      "isSelected": seat.isSelected,
      "lockedBy": seat.isSelected ? currentUserEmail : "",
    });

    // UI will update automatically through the real-time listener
  }

  void listenToSeatsForCoach(String coachId) {
    FirebaseFirestore.instance
        .collection("trains")
        .doc(widget.trainId)
        .collection("coaches")
        .doc(coachId)
        .collection("seats")
        .snapshots()
        .listen((seatSnapshot) {
      List<Seats> updatedSeats = seatSnapshot.docs.map((doc) {
        return Seats.fromJson(doc.data(), doc.id);
      }).toList();

      setState(() {
        seats = updatedSeats;
      });
    });
  }

  void _fetchCoaches() {
    FirestoreServices().getCoaches(widget.trainId).listen((coach) {
      setState(() {
        coaches = coach;
      });
    });
  }

  Future<void> fetchSeatsForCoach(String coachId) async {
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    for (var seat in seats) {
      if (seat.isSelected && seat.lockedBy == currentUserEmail) {
        await FirebaseFirestore.instance
            .collection("trains")
            .doc(widget.trainId)
            .collection("coaches")
            .doc(selectedCoach!.id) // Previous coach
            .collection("seats")
            .doc(seat.id)
            .set({"isSelected": false, "lockedBy": ""});
      }
    }

    setState(() {
      seats = [];
    });

    var seatSnapshot = await FirebaseFirestore.instance
        .collection("trains")
        .doc(widget.trainId)
        .collection("coaches")
        .doc(coachId)
        .collection("seats")
        .get();

    List<Seats> fetchedSeats = seatSnapshot.docs.map((doc) {
      return Seats.fromJson(doc.data(), doc.id);
    }).toList();

    setState(() {
      seats = fetchedSeats;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCoaches();
    if (selectedCoach != null) {
      listenToSeatsForCoach(selectedCoach!.id);
    }
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
            DropdownButton<Coaches>(
              value: selectedCoach,
              hint: const Text("Select a Coach"),
              items: coaches.map((coach) {
                return DropdownMenuItem(
                    value: coach,
                    child: Text("Coach ${coach.coachNo.toString()}"));
              }).toList(),
              onChanged: (val) async {
                if (val == null || selectedCoach?.id == val.id) return;
                String? currentUserEmail =
                    FirebaseAuth.instance.currentUser?.email;
                for (var seat in seats) {
                  if (seat.isSelected && seat.lockedBy == currentUserEmail) {
                    await FirebaseFirestore.instance
                        .collection("trains")
                        .doc(widget.trainId)
                        .collection("coaches")
                        .doc(selectedCoach!.id) // Previous coach
                        .collection("seats")
                        .doc(seat.id)
                        .update({"isSelected": false, "lockedBy": ""});
                  }
                }
                setState(() {
                  selectedCoach = val; // Update selected coach
                  seats = []; // Clear previous seats
                });

                listenToSeatsForCoach(selectedCoach!.id);
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
                  child: seats.isEmpty
                      ? const Center(child: Text("No seats available"))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            seatColumn(["A", "B", "C", "D", "E"],
                                leftSide: true, seats: seats),
                            const VerticalDivider(thickness: 1),
                            seatColumn(["A", "B", "C", "D", "E"],
                                leftSide: false, seats: seats),
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
                      ticketInfoRow(
                        "Your Seat(s)",
                        HelperFunctions.formatSeatList(selectedSeats),
                      ),
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => widget.returnDate ==
                                              null
                                          ? BookingDetailsPage(
                                              selectedSeatList: selectedSeats,
                                              trainId: widget.trainId,
                                              selectedCoachId:
                                                  selectedCoach!.id,
                                              trainNo: widget.trainNo,
                                              trainName: widget.trainName,
                                              departureDate:
                                                  widget.departureDate,
                                              departureTime: "10:00 AM",
                                              totalAmount:
                                                  "RM${totalPrice.toStringAsFixed(2)}",
                                              arrivalTime: "12:24 PM",
                                              from: widget.from,
                                              to: widget.to,
                                              coachNo: selectedCoach!.coachNo
                                                  .toString(),
                                            )
                                          : TrainsReturnPage(
                                              from: widget.to,
                                              to: widget.from,
                                              departureDate:
                                                  widget.departureDate,
                                              returnDate: widget.returnDate,
                                              passengers: widget.passengers)));
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
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }

  Widget seatColumn(List<String> rows,
      {required bool leftSide, required List<Seats> seats}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            seatBox(
              seats.firstWhere(
                (s) =>
                    s.seatName.toLowerCase() ==
                    "${row.toLowerCase()}${leftSide ? 1 : 3}",
                // orElse: () => Seats(
                //     id: "", seatName: "X", isBooked: false, isSelected: false),
              ),
            ),
            const SizedBox(width: 10),
            seatBox(
              seats.firstWhere(
                (s) =>
                    s.seatName.toLowerCase() ==
                    "${row.toLowerCase()}${leftSide ? 2 : 4}",
                // orElse: () => Seats(
                //     id: "", seatName: "X", isBooked: false, isSelected: false),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget seatBox(Seats seat) {
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    // Determine seat color
    Color seatColor;
    if (seat.isBooked) {
      seatColor = Colors.red; // Booked seats are always red
    } else if (seat.lockedBy.isNotEmpty && seat.lockedBy != currentUserEmail) {
      seatColor = Colors.red; // Locked by another user (appears booked)
    } else if (seat.isSelected) {
      seatColor = CColors.primary; // Selected by current user
    } else {
      seatColor = Colors.grey; // Available seats
    }

    return GestureDetector(
      onTap: seatColor == Colors.red ? null : () => toggleSeat(seat.id),
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          seat.seatName.toUpperCase(), // Convert back to uppercase for display
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
