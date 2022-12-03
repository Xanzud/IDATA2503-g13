import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/services/firebase_crud.dart';
import 'package:project/services/firestore_repository.dart';
import 'package:project/utils/user_handler.dart';
import 'package:project/widget/profile_widget.dart';
import 'package:provider/provider.dart';
import '../services/repository.dart';
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
  final Auth.User? _currentUserAuth = Auth.FirebaseAuth.instance.currentUser;
  late Future<User> userFuture;

  @override
  void initState() {
    super.initState();

    userFuture = FirebaseCrud.getUserByUid(_currentUserAuth!.uid);
  }

  @override
  Widget build(BuildContext context) {
    //final database = Provider.of<Repository>(context, listen: false);
    return FutureBuilder(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Text("Error: $error");
          } else if (snapshot.hasData) {
            //If we get here, we should have been able to fetch the data.
            User user = snapshot.data!;
            String userName = user.name;
            return Scaffold(
                appBar: _buildAppBar(context),
                body: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: _buildprofileContent(context, user)));
          } else {
            //Return an empty widget.
            return const SizedBox();
          }
        });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: const BackButton(),
      elevation: 0,
    );
  }

  ///Helper method for populating the profile view with the relevant data.
  List<Widget> _buildprofileContent(BuildContext context, User user) {
    return [
      SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ProfileWidget(
          imagePath: user.imagePath,
          onClicked: () async {},
        ),
      ),
      SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          decoration: InputDecoration(labelText: 'User name'),
          initialValue: user.name,
          validator: (value) =>
              value!.isNotEmpty ? null : 'Name can\'t be empty',
        ),
      ),
      SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Email'),
          initialValue: user.email != null ? user.email : null,
          keyboardType: TextInputType.emailAddress,
          validator: (value) =>
              value!.isNotEmpty ? null : 'Email can\'t be empty',
        ),
      ),
      SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Phone #'),
          initialValue: user.phoneNr,
          keyboardType: TextInputType.phone,
        ),
      ),
      SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: Text("Certifications"),
        ),
      ),
      _buildCertifications(context, user),
      SizedBox(height: 24),
      _buildEditButton(),
    ];
  }

  ///Helper method for listing up user's certifications
  Widget _buildCertifications(BuildContext context, User user) {
    List<dynamic>? certifications = user.certifications;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: user.certifications.length,
      itemBuilder: (context, index) {
        final item = certifications[index];

        return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
                initialValue: user.certifications[index],
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                )));
      },
    );
  }

  ///Helper method for creating the edit button.
  Widget _buildEditButton() {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ElevatedButton(
            onPressed: () {
              onEditButtonPressed();
            },
            child: Text(
              _isEditButtonPressed ? "Save" : "Edit",
              style: TextStyle(color: Colors.black),
            )));
  }

  ///Method to be called when edit button is pressed
  ///Simply toggles isEditButtonPressed.
  void onEditButtonPressed() {
    setState(() {
      _isEditButtonPressed = !_isEditButtonPressed;
    });
  }
}
