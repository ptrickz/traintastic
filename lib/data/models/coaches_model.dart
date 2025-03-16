class Coaches {
  String id;
  int coachNo;

  Coaches({
    required this.id,
    required this.coachNo,
  });

  factory Coaches.fromJson(Map<String, dynamic> json, String id) {
    return Coaches(id: id, coachNo: json['coachNo']);
  }
}
