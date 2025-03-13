class Tickets {
  String id;
  String arrivalTime;
  String departure;
  String destination;
  String departureTime;
  String departureDate;
  String ticketHolder;
  String trainName;
  List<String> seatList;
  String coachNo;

  Tickets({
    required this.id,
    required this.arrivalTime,
    required this.departure,
    required this.destination,
    required this.departureTime,
    required this.departureDate,
    required this.ticketHolder,
    required this.trainName,
    required this.seatList,
    required this.coachNo,
  });

  factory Tickets.fromJson(Map<String, dynamic> json, String id) {
    return Tickets(
      id: id,
      arrivalTime: json['arrivalTime'],
      departure: json['departure'],
      destination: json['destination'],
      departureTime: json['departureTime'],
      departureDate: json['departureDate'],
      ticketHolder: json['ticketHolder'] ?? "",
      trainName: json['trainName'],
      seatList: List<String>.from(json['seatList'] ?? []),
      coachNo: json['coachNo'],
    );
  }

  // Convert Tickets object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      "arrivalTime": arrivalTime,
      "departure": departure,
      "destination": destination,
      "departureTime": departureTime,
      "departureDate": departureDate,
      "ticketHolder": ticketHolder,
      "trainName": trainName,
      "seatList": seatList,
    };
  }
}
