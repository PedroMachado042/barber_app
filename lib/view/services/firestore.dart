import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addNumber(String i) {
    return firestore.collection('Numbers').doc('numbers').set({
      'value': i,
      'timestamp': Timestamp.now(),
    });
  }
}
