import 'package:flutter_test/flutter_test.dart';
import 'package:project/model/packing_item.dart';

void main() {
  group("Point", () {
    PackingItem pi1;
    setUp(() {
      pi1 = PackingItem("stretcher", "second", 1, true);
    });

    test("Test that PackingItem.toMap() returns a map, as expected", () {
      pi1 = PackingItem("stretcher", "second", 1, true);
      Map<String, dynamic> pi1Map = pi1.toMap();
      expect(pi1Map["name"], "stretcher");
      expect(pi1Map["shelf"], "second");
      expect(pi1Map["count"], 1);
      expect(pi1Map["packed"], true);
    });
  });
}
