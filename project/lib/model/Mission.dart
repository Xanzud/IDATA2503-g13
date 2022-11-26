import 'package:cloud_firestore/cloud_firestore.dart';

class Mission{
  final String name;
  final Timestamp time;
  final String location;
  final String id;

  Mission(this.name, this.time, this.location, this.id);

  //TODO Cleanup, don't need 2 fromMaps
  static Mission fromMap(Map<String, dynamic> data, String id){
    assert(data.containsKey("name"), "Missing name property for a mission");
    assert(data.containsKey("time"), "Missing time property for a mission");
    assert(data.containsKey("location"),
    "Missing location property for a mission");
    return Mission(data["name"], data["time"], data["location"], data["id"]);
  }

  factory Mission.fromMapFactory(Map<String, dynamic> data, String documentId) {
    final String name = data["name"];
    final Timestamp time = data["time"];
    final String location = data["location"];

    return Mission(name, time, location, documentId);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "time": time,
      "location": location,
    };
  }
}