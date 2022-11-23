import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/Mission.dart';
import '../services/repository.dart';

class newMissionPage extends StatefulWidget {

  @override
  _newMissionPageState createState() => _newMissionPageState();
}

class _newMissionPageState extends State<newMissionPage> {
  final _formKey = GlobalKey<FormState>();

  //TODO should be non-initialized?
  String? _name;
  String? _time;
  String? _location;

  String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if(form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async{
    if(_validateAndSaveForm()) {
      print("form saved $_name, $_time, $_location");
      final repository = Provider.of<Repository>(context, listen: false);
      final mission = Mission(_name!, _time!, _location!);
      String missionID = "/${documentIdFromCurrentDate()}";
      await repository.createMission(mission, missionID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text("New Mission"),
        actions: <Widget>[
          FloatingActionButton(
            child: Text("Submit", style: TextStyle(fontSize: 18,color: Colors.white)),
              onPressed: _submit,
          )],
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
            )
          ),
        )
      );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      )
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: "Name"),
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Time"),
        onSaved: (value) => _time = value,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Location"),
        onSaved: (value) => _location = value,
      ),
    ];
  }
}