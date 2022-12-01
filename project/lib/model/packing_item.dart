class PackingItem {

  final String name;
  final String shelf;
  final int count;
  bool packed;
  final String id;

  PackingItem(this.name, this.shelf, this.count, this.packed, this.id);

  factory PackingItem.fromMap(Map<String, dynamic> data, String docID) {
    final String name = data["name"];
    final String shelf = data["shelf"];
    final int count = data["count"];
    final bool packed = data["packed"];

    return PackingItem(name, shelf, count, packed, docID);
  }
}