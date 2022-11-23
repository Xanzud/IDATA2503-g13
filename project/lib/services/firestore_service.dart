import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  //TODO Pass the FireStore store variable in the constructor instead of the methods.
  Stream<T?> getDocumentStream<T>(String path,
      T Function(Map<String, dynamic>) converter, FirebaseFirestore store) {
    print("Get document at $path");
    // Get snapshot stream first
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
    store.doc(path).snapshots();

    // Then we need to convert it to Stream<T?> - take every snapshot and
    // convert it to a T object. This effectively creates a new Stream
    // where for each item on the "old stream" the conversion function is
    // called and the result of that function is "sent" to the new stream.
    return snapshots.map((documentSnapshot) {
      final Map<String, dynamic>? document = documentSnapshot.data();
      return document != null ? converter(document) : null;
    });
  }

  /// Get a stream for a collection stored at a specific path.
  /// Automatically convert each item in the collection to an object of
  /// corresponding type using the provided [converter] function
  Stream<Iterable<T>> getCollectionStream<T>(String path,
      T Function(Map<String, dynamic>) converter, FirebaseFirestore store) {
    print("Get collection items at $path");
    // Get snapshot stream first
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
    store.collection(path).snapshots();

    // Then we traverse all the documents (as QueryDocumentSnapshot)
    // For each document, we extract the key-value pairs as Map<String, dynamic>
    // Then we convert eah Map to the desired object of type T,
    // return Iterable<T> in the end
    return snapshots.map((collectionSnapshot) {
      // Let's write out all the types explicitly, just for learning - so that
      // we see type of the variable at each step
      final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          collectionSnapshot.docs;
      return documents
          .map((QueryDocumentSnapshot<Map<String, dynamic>> document) {
        final Map<String, dynamic> data = document.data();
        return converter(data);
      });
    });
  }

  Future<void> setData({required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }
}