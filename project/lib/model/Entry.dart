import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Entry {
  Entry({
    required this.id,
    required this.missionId,
    required this.time,
    required this.location,
    required this.name,
  });

  String? id;
  String? missionId;
  Timestamp? time;
  String? location;
  String? name;

  factory Entry.fromMap(Map<dynamic, dynamic> value, String id) {
    final Timestamp time = value['time'];
    final String name = value['name'];
    final String location = value['location'];
    return Entry(
        id: id,
        missionId: value['missionId'],
        time: time,
        location: location,
        name: name);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'missionId': missionId,
      'name': name,
      'time': time,
      'location': location
    };
  }
}
