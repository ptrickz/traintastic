class Seats {
  String id;
  String seatName;
  bool isSelected;
  bool isBooked;
  String lockedBy;

  Seats({
    required this.id,
    required this.seatName,
    required this.isSelected,
    required this.isBooked,
    required this.lockedBy,
  });

  factory Seats.fromJson(Map<String, dynamic> json, String id) {
    return Seats(
      id: id,
      seatName: json['seatName'],
      isSelected: json['isSelected'],
      isBooked: json['isBooked'],
      lockedBy: json['lockedBy'],
    );
  }
}
