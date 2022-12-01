import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Stores variables concerning the user
class User {
  String uid;
  String imagePath;
  String name;
  String address;
  String regNr;
  String email;
  String phoneNr;
  List<dynamic> certifications;
  String role;

  User(this.imagePath, this.name, this.address, this.regNr, this.email,
      this.phoneNr, this.certifications, this.role, this.uid);

  static User fromMap(Map<String, dynamic> data) {
    assert(data.containsKey("name"), "Missing name property for a user");
    assert(data.containsKey("address"), "Missing address property for a user");
    assert(data.containsKey("regNr"), "Missing regNr property for a user");
    assert(data.containsKey("email"), "Missing email property for a user");
    assert(data.containsKey("phoneNr"), "Missing phoneNr property for a user");
    assert(data.containsKey("certifications"),
        "Missing certifications property for a user");
    assert(data.containsKey("role"), "Missing role property for a user");
    return User(
        data["imagePath"],
        data["name"],
        data["address"],
        data["regNr"],
        data["email"],
        data["phoneNr"],
        data["certifications"],
        data["role"],
        data["uid"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "imagePath": imagePath,
      "name": name,
      "address": address,
      "regNr": regNr,
      "email": email,
      "phoneNr": phoneNr,
      "certifications": certifications,
      "role": role,
    };
  }

  ///For mapping data of user document from firestore into usable User object
  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
        data?["imagePath"],
        data?["name"],
        data?["address"],
        data?["regNr"],
        data?["email"],
        data?["phoneNr"],
        data?['certifications'] is Iterable
            ? List.from(data?['certifications'])
            : [],
        data?["role"],
        data?["uid"]);
  }

  ///For mapping User object into user document for firestore.
  Map<String, dynamic> toFireStore() {
    return {
      if (imagePath != null) "imagePath": imagePath,
      if (name != null) "name": name,
      if (address != null) "address": address,
      if (regNr != null) "regNr": regNr,
      if (email != null) "email": email,
      if (phoneNr != null) "phoneNr": phoneNr,
      if (certifications != null) "certifications": certifications,
      if (role != null) "role": role,
    };
  }
}
