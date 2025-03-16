class Train {
  String id;
  int trainNo;
  String trainName;
  double ticketPrice;

  Train(
      {required this.id,
      required this.trainNo,
      required this.trainName,
      required this.ticketPrice});

  factory Train.fromJson(Map<String, dynamic> json, String id) {
    return Train(
      id: id,
      trainNo: json['trainNo'],
      trainName: json['trainName'],
      ticketPrice: (json['ticketPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
