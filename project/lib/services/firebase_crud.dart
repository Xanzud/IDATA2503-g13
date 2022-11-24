import 'package:cloud_firestore/cloud_firestore.dart';
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
}
