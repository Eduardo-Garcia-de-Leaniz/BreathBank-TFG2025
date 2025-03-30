import 'package:cloud_firestore/cloud_firestore.dart';

class Database_service {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> create({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await db.collection(collectionPath).doc(docId).set(data);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> read({
    required String collectionPath,
    required String docId,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await db.collection(collectionPath).doc(docId).get();
    return snapshot.exists ? snapshot : null;
  }

  Future<void> update({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await db.collection(collectionPath).doc(docId).update(data);
  }

  Future<void> delete({
    required String collectionPath,
    required String docId,
  }) async {
    await db.collection(collectionPath).doc(docId).delete();
  }
}
