import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project/pages/profile_page.dart';

main() {
  //Overriding mocked http class that is normally used for test wigdets.
  setUpAll(() => HttpOverrides.global = null);


  //creating variable for storing target widget of tests
  Widget profilePageTestWidget = MediaQuery(
    data: MediaQueryData(), 
    child: MaterialApp(home: ProfilePage()));


 //creating Finders
  final addressFinder = find.text("Address");
  final phoneFinder = find.text("Phone #");
  final regFinder = find.text("Reg #");
  final certFinder = find.text("Certifications");

  //Tests that ProfilePage has a single widget with the text "Address"
  testWidgets("ProfilePage has an address field", (WidgetTester tester) async {
    await tester.pumpWidget(profilePageTestWidget);
    expect(addressFinder, findsOneWidget);
  });

  //Tests that profilPage has a single widget with the text "Phone #"
  testWidgets("ProfilePage has a phone # field", (WidgetTester tester) async {
    await tester.pumpWidget(profilePageTestWidget);
    expect(phoneFinder, findsOneWidget);
  });

  //Tests that profilPage has a single widget with the text "Reg #"
  testWidgets("ProfilePage has a reg # field", (WidgetTester tester) async {
    await tester.pumpWidget(profilePageTestWidget);
    expect(regFinder, findsOneWidget);
  });

  //Tests that profilPage has a single widget with the text "Certifications"
  testWidgets("ProfilePage has an address field", (WidgetTester tester) async {
    await tester.pumpWidget(profilePageTestWidget);
    expect(certFinder, findsOneWidget);

  });
}