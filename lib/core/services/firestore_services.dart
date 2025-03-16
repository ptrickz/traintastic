import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traintastic/data/models/coaches_model.dart';
import 'package:traintastic/data/models/locations_model.dart';
import 'package:traintastic/data/models/seats_model.dart';
import 'package:traintastic/data/models/tickets_model.dart';
import 'package:traintastic/data/models/train_model.dart';

class FirestoreServices {
  final CollectionReference locationsCollection =
      FirebaseFirestore.instance.collection('locations');

  Stream<List<Locations>> getLocations() {
    return locationsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Locations.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  final CollectionReference trainsCollection =
      FirebaseFirestore.instance.collection('trains');

  Stream<List<Train>> getTrains() {
    return trainsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Train.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Stream<List<Coaches>> getCoaches(String trainId) {
    return FirebaseFirestore.instance
        .collection('trains/$trainId/coaches')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Coaches.fromJson(doc.data(), doc.id))
          .toList();
    });
  }

  Stream<List<Seats>> getSeats(String trainId, coachId) {
    return FirebaseFirestore.instance
        .collection('trains/$trainId/coaches/$coachId')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Seats.fromJson(doc.data(), doc.id))
          .toList();
    });
  }

  Stream<List<Tickets>> getTickets() {
    return FirebaseFirestore.instance
        .collection('tickets')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Tickets.fromJson(doc.data(), doc.id))
          .toList();
    });
  }
}
