import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/model/Mission.dart';
import 'package:project/services/api_paths.dart';
import 'package:project/services/firestore_service.dart';
import '../model/Response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
CollectionReference _Collection = _firestore.collection('');

class FirebaseCrud {
  // Users

  static Future<Response> addUser(
      {required String name,
      required String phone,
      required String address,
      String? reg,
      String? certifications,
      String? email}) async {
    _Collection = _firestore.collection('users');

    Response response = Response();
    DocumentReference documentReference = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "address": address,
      "phone": phone,
      "name": name,
      "regNr": reg,
      "email": email
    };

    await documentReference.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Successfully added to database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Stream<QuerySnapshot> readUser() {
    _Collection = _firestore.collection('users');
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.snapshots();
  }

  static Future<Response> updateUser(
      {required String name,
      required String phone,
      required String address,
      String? reg,
      String? certifications,
      String? email}) async {
    _Collection = _firestore.collection('users');

    Response response = Response();
    DocumentReference documentReference = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "address": address,
      "phone": phone,
      "name": name,
      "regNr": reg,
      "email": email
    };

    await documentReference.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Successfully updated User";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Future<Response> deleteUser({
    required String docId,
  }) async {
    _Collection = _firestore.collection('users');

    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully Deleted User";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  // Missions

  static Future<Response> createMission(
      {required id,
      required String location,
      required String name,
      required Timestamp time}) async {
    _Collection = _firestore.collection('missions');

    Response response = Response();
    DocumentReference documentReference = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "id": id,
      "location": location,
      "name": name,
      "time": time
    };

    await documentReference.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Successfully added to database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Stream<QuerySnapshot> readMission() {
    _Collection = _firestore.collection('missions');
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.snapshots();
  }

/*
  static Future<Response> updateMission(
      {required String location,
      required String name,
      required Timestamp time}) async {
    _Collection = _firestore.collection('missions');

    Response response = Response();
    DocumentReference documentReference = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "location": location,
      "name": name,
      "time": time
    };

    await documentReference.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Successfully updated mission";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
  */

  static Future<void> saveMission(Mission mission) =>
      FirestoreService.instance.setData(
        path: ApiPaths.mission(mission.id),
        data: mission.toMap(),
      );

  static Future<void> setMission({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  static Future<Response> deleteMission({
    required String docId,
  }) async {
    _Collection = _firestore.collection('missions');

    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully Deleted mission";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  Stream<T?> getDocumentStream<T>(
      String path, T Function(Map<String, dynamic>) converter) {
    print("Get document at $path");
    // Get snapshot stream first
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        _firestore.doc(path).snapshots();

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
  Stream<Iterable<T>> getCollectionStream<T>(
      String path, T Function(Map<String, dynamic>) converter) {
    print("Get collection items at $path");
    // Get snapshot stream first
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        _firestore.collection(path).snapshots();

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

  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  /// Returns a stream of iterable with snapshots together with document ID
  Stream<Iterable<T>> collectionStreamWithID<T>({
    required T Function(Map<String, dynamic> data, String documentID) builder,
  }) {
    final collection = _firestore.collection("missions");
    final snapshots = collection.snapshots();

    return snapshots.map((snapshots) => snapshots.docs
        .map(
          (snapshot) => builder(snapshot.data(), snapshot.id),
        )
        .toList());
  }

  static void updateMission(
      {required String location,
      required String name,
      required Timestamp time}) {}
}
