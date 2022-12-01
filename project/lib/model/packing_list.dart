import 'package:project/model/packing_item.dart';

class PackingList {
  final String name;
  final List<PackingItem> items;
  final String id;


  PackingList(this.name, this.items, this.id);

  factory PackingList.fromMap(Map<String, dynamic> data, docId) {
    final String name = data["name"];
    final List<PackingItem> items = data["items"];

    return PackingList(name, items, docId);
  }
}