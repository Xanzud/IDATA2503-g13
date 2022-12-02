import 'package:project/model/packing_item.dart';

class PackingList {
  final String name;
  final String id;


  PackingList(this.name, this.id);

  factory PackingList.fromMap(Map<String, dynamic> data, docId) {
    final String name = data["name"];

    return PackingList(name, docId);
  }
}