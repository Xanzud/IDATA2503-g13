import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:project/services/firebase_crud.dart';
import 'package:project/signInPage.dart';
import 'package:project/widget/profile_widget.dart';
import "../model/user.dart";

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _textFormFieldEditable = false;
  final auth.User? _currentUserAuth = auth.FirebaseAuth.instance.currentUser;
  late Future<User> userFuture;

  final _formKey = GlobalKey<FormState>();
  bool isFirstRun = true;
  late String? _imagePath;
  late String? _name;
  late String? _email;
  late String? _phoneNr;
  late String? _regNr;

  @override
  void initState() {
    super.initState();

    userFuture = FirebaseCrud.getUserByUid(_currentUserAuth!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Text("Error: $error");
          } else if (snapshot.hasData) {
            //If we get here, we should have been able to fetch the data.
            User user = snapshot.data!;
            //If this is the first run, initialze user data variables.
            if (isFirstRun) {
              isFirstRun = !isFirstRun;
              _imagePath = user.imagePath;
              _name = user.name;
              _email = user.email;
              _phoneNr = user.phoneNr;
              _regNr = user.regNr;
            }
            return Scaffold(
                appBar: _buildAppBar(context),
                body:
                    ListView(physics: const BouncingScrollPhysics(), children: [
                  Form(
                      key: _formKey,
                      child: Column(children: [
                        Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: _buildprofileContent(context, user),
                            )),
                      ]))
                ]));
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
      title: Text("Profile View"),
    );
  }

  ///Helper method for populating the profile view with the relevant data.
  List<Widget> _buildprofileContent(BuildContext context, User user) {
    return [
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            ClipOval(
                child: Material(
                    color: Colors.transparent,
                    child: Ink.image(
                      image: (_imagePath == "" || _imagePath == null)
                          ? NetworkImage(
                              "https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png")
                          : NetworkImage(_imagePath!),
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                    ))),
          ],
        ),
      ),
      const SizedBox(height: 24),
      //Image path url
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          enabled: _textFormFieldEditable,
          decoration: const InputDecoration(
              labelText: 'Image url',
              //Change underline color when editable
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )),
          initialValue: _imagePath,
          onChanged: (value) {
            setState(() {
              _imagePath = value;
            });
          },
        ),
      ),
      //Name
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          enabled: _textFormFieldEditable,
          decoration: const InputDecoration(
              labelText: 'Name',
              //Change underline color when editable
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )),
          initialValue: _name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Name field cannot be empty";
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _name = value;
            });
          },
        ),
      ),
      const SizedBox(height: 24),
      //Email
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          enabled: _textFormFieldEditable,
          decoration: const InputDecoration(
              labelText: 'Email',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )),
          initialValue: _email,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Email field cannot be empty";
            } else if (!EmailValidator.validate(value)) {
              return "Not a valid email address.";
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _email = value;
            });
          },
          keyboardType: TextInputType.emailAddress,
        ),
      ),
      const SizedBox(height: 24),
      //Phone #
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          enabled: _textFormFieldEditable,
          decoration: const InputDecoration(
              labelText: 'Phone #',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )),
          initialValue: _phoneNr,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Phone # field cannot be empty";
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _phoneNr = value;
            });
          },
          keyboardType: TextInputType.phone,
        ),
      ),
      const SizedBox(height: 24),
      //Reg #
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          enabled: _textFormFieldEditable,
          decoration: const InputDecoration(
              labelText: 'Vehicle reg #',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )),
          initialValue: _regNr,
          onChanged: (value) {
            setState(() {
              _regNr = value;
            });
          },
          keyboardType: TextInputType.text,
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
      const SizedBox(height: 24),
      _buildLogoutButton(),
    ];
  }

  ///Helper method for listing up user's certifications
  Widget _buildCertifications(BuildContext context, User user) {
    List<dynamic>? certifications = user.certifications;

    if (user.certifications.length == 0) {
      return const Text(
          """No certifications to show.\nContact admin to add certifications.""",
          style: TextStyle(color: Colors.red));
    } else {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: user.certifications.length,
          itemBuilder: (context, index) {
            final item = certifications[index];

            return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                    enabled:
                        false, //Should never be anabled, as users should not be able to edit these themselves.
                    initialValue: item,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    )));
          });
    }
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
              _textFormFieldEditable ? "Save" : "Edit",
              style: const TextStyle(color: Colors.black),
            )));
  }

  ///Method to be called when edit button is pressed
  ///Simply toggles _isEditButtonPressed.
  void onEditButtonPressed() {
    //If form is currently editable
    if (_textFormFieldEditable == true) {
      setState(() {
        //If validators pass
        if (_formKey.currentState!.validate()) {
          _textFormFieldEditable = !_textFormFieldEditable;
          //If all valid, update the database.
          final profile = FirebaseFirestore.instance
              .collection("users")
              .doc(_currentUserAuth!.uid);
          profile.update({
            "imagePath": _imagePath,
            "name": _name,
            "email": _email,
            "phoneNr": _phoneNr,
            "regNr": _regNr,
          });
          final snackBar = SnackBar(content: const Text("profile updated"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
      //If form is NOT currently editable
    } else if (_textFormFieldEditable == false) {
      setState(() {
        _textFormFieldEditable = true;
      });
    }
  }

  //Helper method for creating logout button.
  Widget _buildLogoutButton() {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ElevatedButton(
          onPressed: () {
            onLogoutButtonPressed();
          },
          child: const Text("Logout", style: TextStyle(color: Colors.black)),
        ));
  }

  //Method to be called when Logout button is pressed.
  //Logs out the user.
  void onLogoutButtonPressed() {
    setState(() {
      auth.FirebaseAuth.instance.signOut();

      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => new SignInPage()),
          (route) => false);
    });
  }

  String checkValidators() {
    throw UnimplementedError();
  }
}
