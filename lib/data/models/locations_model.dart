class Locations {
  String id;
  String locationName;

  Locations({
    required this.id,
    required this.locationName,
  });

  factory Locations.fromJson(Map<String, dynamic> json, String id) {
    return Locations(id: id, locationName: json['locationName']);
  }
}
