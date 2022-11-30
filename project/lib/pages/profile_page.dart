import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/services/firebase_crud.dart';
import 'package:project/services/firestore_repository.dart';
import 'package:project/utils/user_handler.dart';
import 'package:project/widget/profile_widget.dart';
import "../utils/user_settings.dart";
import "../widget/profile_widget.dart";
import "../model/user.dart";
import 'package:cloud_firestore/cloud_firestore.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditButtonPressed = false;
  User _currentUser = UserSettings.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        body: ListView(physics: const BouncingScrollPhysics(), children: [
          const SizedBox(height: 24),
          ProfileWidget(
            imagePath: _currentUser.imagePath,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildNameAndEmail(_currentUser),
          const SizedBox(height: 24),
          buildInfoField(infoName: "Address", info: _currentUser.address),
          const SizedBox(height: 24),
          buildInfoField(infoName: "Phone #", info: _currentUser.phoneNr),
          const SizedBox(height: 24),
          buildInfoField(infoName: "Reg #", info: _currentUser.regNr),
          const SizedBox(height: 24),
          buildInfoField(
              infoName: "Certifications",
              info: _currentUser.certifications.toString()),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: () {
                onEditButtonPressed();
              },
              child: Text(
                _isEditButtonPressed ? "Save" : "Edit",
                style: TextStyle(color: Colors.black),
              )),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: (() => onLoadUserButtonPressed()),
              child: const Text("Load user")),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: (() => print(_currentUser.name)),
              child: const Text("Print current user name")),
        ]));
  }

  AppBar _buildAppBar(BuildContext context) {
    const icon = CupertinoIcons.moon_stars;
    return AppBar(
      leading: const BackButton(),
      elevation: 0,
      actions: [IconButton(onPressed: () {}, icon: const Icon(icon))],
    );
  }

  /// Builds fields for name and email address.
  Widget buildNameAndEmail(User user) => Column(children: [
        Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: const TextStyle(color: Colors.grey),
        )
      ]);

  /// Builds generic info field. Intended for easy creation of Address, phone,
  /// and reg.
  Widget buildInfoField({required String infoName, required String info}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              infoName,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            )),
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              enabled: _isEditButtonPressed,
            ))
      ]);

  ///Method to be called when edit button is pressed
  ///Simply toggles isEditButtonPressed.
  void onEditButtonPressed() {
    setState(() {
      _isEditButtonPressed = !_isEditButtonPressed;
    });
  }


  void onLoadUserButtonPressed() {
    UserHandler.loadUser();
    print("onLoadUserButtonPresse User: ${_currentUser.name}");
    setState(() {
      _currentUser = UserSettings.currentUser;
    });

    //Fetching user data by email signed in with from Firebase Firestore
    FirebaseCrud fbc = FirebaseCrud();
    User ?fetchedUser;
    fbc.getUserByEmailOnce(UserHandler.getEmailSignedInWith).then((result) {
      fetchedUser = result;
    });
    if(fetchedUser != null){
      print(fetchedUser?.email);
    }
  }
}
