import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/model/Mission.dart';
import 'package:project/services/firebase_crud.dart';
import 'package:project/services/repository.dart';
import 'package:project/utils/show_alert_dialog.dart';
import 'package:project/utils/show_exception_alert_dialog.dart';

class EditMissionPage extends StatefulWidget {
  const EditMissionPage(
      {Key? key, required this.database, required this.mission})
      : super(key: key);
  final Repository? database;
  final Mission? mission;

  static Future<void> show(BuildContext context,
      {Repository? database, Mission? mission}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EditMissionPage(database: database, mission: mission),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _EditMissionPageState();
  }
}

class _EditMissionPageState extends State<EditMissionPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _location;
  Timestamp? _time;

  @override
  void initState() {
    super.initState();
    if (widget.mission != null) {
      _name = widget.mission?.name;
      _location = widget.mission?.location;
      _time = widget.mission?.time;
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
        final missions = await widget.database!.getAllMissionsStream().first;
        final allNames = missions.map((mission) => mission.name).toList();
        if (widget.mission != null) {
          allNames.remove(widget.mission!.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different mission name',
            defaultActionText: 'OK',
            cancelActionText: 'cancel',
          );
        } else {
          final id = widget.mission?.id;
          //final mission = Mission(_name!, _time!, _location!, id!);
          final docMission =
              FirebaseFirestore.instance.collection("missions").doc(id?.trim());
          docMission.update({
            "id": id,
            "name": _name,
            "location": _location,
            "time": _time,
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
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.mission == null ? 'New Mission' : 'Edit Mission'),
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
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
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
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Mission name'),
        initialValue: _name,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      SizedBox(height: 50),
      TextFormField(
        decoration: InputDecoration(labelText: 'Location'),
        initialValue: _location != null ? '$_location' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        validator: (value) =>
            value!.isNotEmpty ? null : 'Location can\'t be empty',
        onSaved: (value) => _location = value,
      ),
      SizedBox(height: 50),
      DateTimeFormField(
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.black45),
          errorStyle: TextStyle(color: Colors.redAccent),
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.event_note),
          labelText: 'Date',
        ),
        initialValue:
            DateTime.fromMicrosecondsSinceEpoch(_time!.microsecondsSinceEpoch),
        mode: DateTimeFieldPickerMode.dateAndTime,
        autovalidateMode: AutovalidateMode.always,
        validator: (e) =>
            (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
        onDateSelected: (DateTime value) {
          setState(() {
            _time = Timestamp.fromMicrosecondsSinceEpoch(
                value.microsecondsSinceEpoch);
          });
        },
      ),
      SizedBox(height: 50),
    ];
  }
}
