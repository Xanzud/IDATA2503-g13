class PackingItem {

  final String name;
  final String shelf;
  final int count;
  bool packed;
  late String id = "";

  PackingItem(this.name, this.shelf, this.count, this.packed);

  factory PackingItem.fromMap(Map<String, dynamic> data, String docID) {
    final String name = data["name"];
    final String shelf = data["shelf"];
    final int count = data["count"];
    final bool packed = data["packed"];

    PackingItem packingItem = PackingItem(name, shelf, count, packed);
    packingItem.id = docID;

    return packingItem;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "shelf": shelf,
      "count": count,
      "packed": packed,
    };
  }
}