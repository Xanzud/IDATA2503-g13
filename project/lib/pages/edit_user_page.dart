import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/model/Mission.dart';
import 'package:project/model/user.dart';
import 'package:project/services/firebase_crud.dart';
import 'package:project/services/firestore_repository.dart';
import 'package:project/services/repository.dart';
import 'package:project/utils/show_alert_dialog.dart';
import 'package:project/utils/show_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({Key? key, required this.database, required this.user})
      : super(key: key);
  final Repository? database;
  final User? user;

  static Future<void> show(BuildContext context,
      {Repository? database, User? user}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditUserPage(database: database, user: user),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _EditUserPageState();
  }
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _password;
  List<dynamic>? _certifications;
  String? _imgUrl;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _name = widget.user?.name;
      _email = widget.user?.email;
      _imgUrl = widget.user?.imagePath;
      _certifications = widget.user?.certifications;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final users = await widget.database!.getUsersStream().first;
        final allNames = users.map((user) => user.name).toList();
        if (widget.user != null) {
          allNames.remove(widget.user!.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different user name',
            defaultActionText: 'OK',
            cancelActionText: 'cancel',
          );
        } else {
          final uid = widget.user?.uid;
          //final mission = Mission(_name!, _time!, _location!, id!);
          final docUser =
              FirebaseFirestore.instance.collection("users").doc(uid?.trim());
          docUser.update({
            "uid": uid,
            "name": _name,
            "email": _email,
            "imagePath": _imgUrl,
            "certifications": _certifications
          });
          //await FirebaseCrud.saveMission(mission);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<Repository>(
      create: (context) => FirestoreRepository(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            title: Text(widget.user == null ? 'New User' : 'Edit User'),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: _submit,
              ),
            ],
          ),
          body: _buildContents(context),
          backgroundColor: Colors.grey[200],
        );
      },
    );
  }

  Widget _buildContents(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(context),
      ),
    );
  }

  List<Widget> _buildFormChildren(BuildContext context) {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'User name'),
        initialValue: _name,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      SizedBox(height: 50),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        initialValue: _email != null ? '$_email' : null,
        keyboardType: TextInputType.emailAddress,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Email can\'t be empty',
        onSaved: (value) => _email = value,
      ),
      SizedBox(height: 50),
      TextFormField(
        decoration: InputDecoration(labelText: 'Img (url only)'),
        initialValue: _imgUrl,
        keyboardType: TextInputType.url,
        onChanged: (value) {
          setState(() {
            _imgUrl = value;
          });
        },
      ),
      SizedBox(height: 50),
      CircleAvatar(
          radius: 100,
          backgroundColor: Colors.transparent,
          backgroundImage: (_imgUrl == "" || _imgUrl == null)
              ? null
              : NetworkImage(_imgUrl!)),
      SizedBox(height: 50),
      Center(
        child: Text("Certifications", style: TextStyle(fontSize: 26)),
      ),
      _buildCertifications(context),
      SizedBox(height: 50),
      _buildAddCertification(),
    ];
  }

  Widget _buildAddCertification() {
    return TextButton(
        onPressed: () {
          setState(() {
            _certifications!.add("");
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('New certification added')));
        },
        child: Icon(Icons.add));
  }

  Widget _buildCertifications(BuildContext context) {
    User? user = widget.user;
    _certifications = user!.certifications;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: user.certifications.length,
      itemBuilder: (context, index) {
        final item = _certifications![index];
        //_certifications?.insert(index, user.certifications[index]);
        /*
        return TextFormField(
          initialValue: user.certifications[index],
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Certification',
          ),
          onChanged: (value) {
            _certifications?.removeAt(index);
            _certifications?.insert(index, value);
            print(_certifications);
          },
        );
        */
        return Dismissible(
            key: Key(item),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                _certifications!.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$item Certification removed')));
            },
            child: TextFormField(
              initialValue: user.certifications[index],
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Certification',
              ),
              onChanged: (value) {
                _certifications?.removeAt(index);
                _certifications?.insert(index, value);
                print(_certifications);
              },
            ));
      },
    );
  }
}
