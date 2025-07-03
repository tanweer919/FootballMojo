import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService() : _db = FirebaseFirestore.instance;

  Future<void> setData(
      {required String userId, required Map<String, dynamic> data}) async {
    await _db
        .collection('users')
        .doc(userId)
        .set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getData({required String userId}) async {
    final DocumentSnapshot document =
        await _db.collection('users').doc(userId).get();
    return document.data() as Map<String, dynamic>?;
  }
}
