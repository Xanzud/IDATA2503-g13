import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project/firebase_options.dart';
import 'package:project/main.dart';
import 'package:project/model/Mission.dart';
import 'package:project/model/packing_item.dart';
import 'package:project/services/firestore_repository.dart';

void main() {
  group("Point", () {
    PackingItem pi1;
    setUp(() {
      pi1 = PackingItem("stretcher", "second", 1, true);
    });

    test("Test that PackingItem.toMap() returns a map, as expected", () {
      //pi1.toMap();
      pi1 = PackingItem("stretcher", "second", 1, true);
      Map<String, dynamic> pi1Map = pi1.toMap();
      expect(pi1Map["name"], "stretcher");
      expect(pi1Map["shelf"], "second");
      expect(pi1Map["count"], 1);
      expect(pi1Map["packed"], true);
    });
  });
}
