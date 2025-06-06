import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Assuming Firestore.instance is from an older cloud_firestore version.
  // Modern is FirebaseFirestore.instance.
  final Firestore _db;

  FirestoreService() : _db = Firestore.instance;

  Future<void> setData(
      {required String userId, required Map<String, dynamic> data}) async {
    await _db
        .collection('users')
        .document(userId)
        .setData(data, merge: true);
  }

  Future<Map<String, dynamic>?> getData({required String userId}) async {
    final DocumentSnapshot document =
        await _db.collection('users').document(userId).get();
    // In older versions, document.data could be null if the document doesn't exist.
    // The return type Map<String, dynamic>? handles this.
    return document.data as Map<String, dynamic>?;
  }
}
