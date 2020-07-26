import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Firestore _db;
  FirestoreService() {
    _db = Firestore.instance;
  }

  Future<void> setData({String userId, Map<String, dynamic> data}) async {
    await _db
        .collection('users')
        .document(userId)
        .setData(data, merge: true);
  }
}
