import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/Response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
CollectionReference _Collection = _firestore.collection('');

class FirebaseCrud{

  static Future<Response> addUser({
    required String name,
    required String phone,
    required String address,String? reg,String? certifications}) async{

    _Collection = _firestore.collection('users');

    Response response = Response();
    DocumentReference documentReference =
        _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "address" : address,
      "phone" : phone,
      "name" : name
    };

    var result = await documentReference
        .set(data)
        .whenComplete(() {
          response.code = 200;
          response.message = "Successfully added to database";
    })
    .catchError((e){
        response.code = 500;
        response.message = e;
    });

    return response;
  }

  static Future<Response> updateUser({
    required String name,
    required String phone,
    required String address,String? reg,String? certifications}) async{

    _Collection = _firestore.collection('users');

    Response response = Response();
    DocumentReference documentReference =
    _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "address" : address,
      "phone" : phone,
      "name" : name
    };

    var result = await documentReference
        .update(data)
        .whenComplete(() {
      response.code = 200;
      response.message = "Successfully updated User";
    })
        .catchError((e){
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
    DocumentReference documentReferencer =
    _Collection.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete((){
      response.code = 200;
      response.message = "Sucessfully Deleted User";
    })
        .catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
}