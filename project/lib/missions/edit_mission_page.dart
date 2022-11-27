import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/model/Mission.dart';
import 'package:project/services/repository.dart';
import 'package:project/utils/show_alert_dialog.dart';
import 'package:project/utils/show_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.mission != null) {
      _name = widget.mission?.name;
      _location = widget.mission?.location;
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
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
            cancelActionText: 'cancel',
          );
        } else {
          final id = widget.mission?.name ?? "documentIdFromCurrentDate()";
          //final mission = Mission(name: id, name: _name, ratePerHour: _location);
          //await widget.database.setJob(job);
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
        title: Text(widget.mission == null ? 'New Job' : 'Edit Mission'),
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
        decoration: InputDecoration(labelText: 'Job name'),
        initialValue: _name,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        initialValue: _location != null ? '$_location' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _location = value,
      ),
    ];
  }
}
