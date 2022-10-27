import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/model/Mission.dart';
import '../../services/repository.dart';

import 'api_paths.dart';

class FirestoreRepository implements Repository {
  final FirebaseFirestore store = FirebaseFirestore.instance;

  
  /// Get a stream for a document stored at a specific path.
  /// Automatically convert each snapshot to an object of corresponding type
  /// Use the provided [converter] function for the conversion
  Stream<T?> _getDocumentStream<T>(
      String path, T Function(Map<String, dynamic>) converter) {
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
  Stream<Iterable<T>> _getCollectionStream<T>(
      String path, T Function(Map<String, dynamic>) converter) {
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

  @override
  Stream<Iterable<Mission>> getAllMissionsStream() {
    // TODO: implement getAllMissionsStream
    throw UnimplementedError();
  }

  @override
  Stream<Mission?> getMissionStream(String missionId) {
    // TODO: implement getMissionStream
    throw UnimplementedError();
  }
}