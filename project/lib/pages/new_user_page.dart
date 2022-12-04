import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/authentication_service.dart';
import 'package:project/services/firebase_crud.dart';
import 'package:provider/provider.dart';

import '../model/Mission.dart';
import '../services/repository.dart';

class NewUserPage extends StatefulWidget {
  @override
  _NewUserPagePageState createState() => _NewUserPagePageState();
}

class _NewUserPagePageState extends State<NewUserPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _uid;
  String? _password;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool validatePsw(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future<void> _submit() async {
    /*
    if(_validateAndSaveForm()) {
      print("form saved $_name, $_time, $_location");
      final repository = Provider.of<Repository>(context, listen: false);
      final mission = Mission(_name!, _time!, _location!);

      String missionID = "/${documentIdFromCurrentDate()}";
      await repository.createMission(mission, missionID);
    }
     */
    if (_validateAndSaveForm()) {
      if (!_formKey.currentState!.validate()) return;
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        var user = await auth.createUserWithEmailAndPassword(
            email: _email!, password: _password!);
        _uid = user.user?.uid;

        var response = await FirebaseCrud.createUser(
            name: _name!,
            phoneNr: "",
            email: _email!,
            role: "user",
            uid: _uid!,
            address: "",
            certifications: List<String>.empty(),
            imagePath: "",
            regNr: "");

        if (response.code != 200) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response.message.toString())));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response.message.toString())));
        }
      } on FirebaseAuthException catch (err) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(err.message!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text("New User"),
      ),
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildForm(),
      )),
    ));
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "Name"),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter a name";
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            /*
            SizedBox(height: 50),
            TextFormField(
              decoration: InputDecoration(labelText: "UID"),
              onChanged: (value) {
                setState(() {
                  _uid = value;
                });
              },
            ),
            */
            SizedBox(height: 50),
            TextFormField(
              decoration: InputDecoration(labelText: "Email"),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                  return "Enter Correct Email Address";
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            SizedBox(height: 50),
            TextFormField(
              decoration: InputDecoration(labelText: "Password"),
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
              validator: (value) =>
                  value!.isNotEmpty ? null : 'Password can\'t be empty',
            ),
            Padding(
                padding: EdgeInsets.all(120),
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text("Create",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ))
          ],
        ));
  }
}
