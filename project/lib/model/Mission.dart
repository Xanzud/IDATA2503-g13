import 'package:cloud_firestore/cloud_firestore.dart';

class Mission {
  final String name;
  final Timestamp time;
  final String location;
  final String id;
  final String packingList;
  final List<dynamic> attending;

  Mission(this.name, this.time, this.location, this.id,this.packingList, this.attending);

  //TODO Cleanup, don't need 2 fromMaps
  static Mission fromMap(Map<String, dynamic> data, String id) {
    assert(data.containsKey("name"), "Missing name property for a mission");
    assert(data.containsKey("time"), "Missing time property for a mission");
    assert(data.containsKey("location"),
        "Missing location property for a mission");
    assert(data.containsKey("packingList"), "Missing packingList property for a mission");
    return Mission(data["name"], data["time"], data["location"], data["id"],data["packingList"], data["attending"]
    );
  }

  static Mission fromMapOriginal(Map<String, dynamic> data) {
    assert(data.containsKey("name"), "Missing name property for a mission");
    assert(data.containsKey("time"), "Missing time property for a mission");
    assert(data.containsKey("location"),
        "Missing location property for a mission");
    assert(data.containsKey("id"), "Missing id property for a mission");
    assert(data.containsKey("packingList"), "Missing packingList property for a mission");
    return Mission(data["name"], data["time"], data["location"], data["id"], data["packingList"], data["attending"]);
  }

  factory Mission.fromMapFactory(Map<String, dynamic> data, String documentId) {
    final String name = data["name"];
    final Timestamp time = data["time"];
    final String location = data["location"];
    final String packingList = data["packingList"];
    final List<dynamic> attending = data["attending"];

    return Mission(name, time, location, documentId, packingList, attending);
  }

  factory Mission.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Mission(data?["name"], data?["time"], data?["location"], data?["id"],
        data?["packingList"],
        data?["attending"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "time": time,
      "location": location,
      "packingList": packingList,
      "attending": attending
    };
  }
}
