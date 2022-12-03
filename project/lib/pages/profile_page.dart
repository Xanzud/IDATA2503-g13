import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:project/services/firebase_crud.dart';
import 'package:project/widget/profile_widget.dart';
import "../model/user.dart";

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditButtonPressed = false;
  final auth.User? _currentUserAuth = auth.FirebaseAuth.instance.currentUser;
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

  //Builds top side appbar.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: const BackButton(),
      elevation: 0,
    );
  }

  ///Helper method for populating the profile view with the relevant data.
  List<Widget> _buildprofileContent(BuildContext context, User user) {
    return [
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ProfileWidget(
          imagePath: user.imagePath,
          onClicked: () async {},
        ),
      ),
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          decoration: const InputDecoration(labelText: 'User name'),
          initialValue: user.name,
          validator: (value) =>
              value!.isNotEmpty ? null : 'Name can\'t be empty',
        ),
      ),
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          decoration: const InputDecoration(labelText: 'Email'),
          initialValue: user.email != null ? user.email : null,
          keyboardType: TextInputType.emailAddress,
          validator: (value) =>
              value!.isNotEmpty ? null : 'Email can\'t be empty',
        ),
      ),
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          decoration: const InputDecoration(labelText: 'Phone #'),
          initialValue: user.phoneNr,
          keyboardType: TextInputType.phone,
        ),
      ),
      const SizedBox(height: 24),
      const Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: Text("Certifications"),
        ),
      ),
      _buildCertifications(context, user),
      const SizedBox(height: 24),
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
          initialValue: item,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            )
          )
        );
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
              style: const TextStyle(color: Colors.black),
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
