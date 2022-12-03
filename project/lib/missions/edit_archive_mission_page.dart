import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/model/Mission.dart';
import 'package:project/model/user.dart';
import 'package:project/pages/edit_user_page.dart';
import 'package:project/pages/user_list_tile.dart';
import 'package:project/services/firebase_crud.dart';
import 'package:project/services/firestore_repository.dart';
import 'package:project/services/repository.dart';
import 'package:project/utils/show_alert_dialog.dart';
import 'package:project/utils/show_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

class EditArchiveMissionPage extends StatefulWidget {
  const EditArchiveMissionPage(
      {Key? key, required this.database, required this.mission})
      : super(key: key);
  final Repository? database;
  final Mission? mission;

  static Future<void> show(BuildContext context,
      {Repository? database, Mission? mission}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EditArchiveMissionPage(database: database, mission: mission),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _EditArchiveMissionPageState();
  }
}

class _EditArchiveMissionPageState extends State<EditArchiveMissionPage> {
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
    return Provider<Repository>(
      create: (context) => FirestoreRepository(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            title: Text(
                widget.mission == null ? 'New Mission' : 'Archived Mission'),
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
        decoration: InputDecoration(labelText: 'Mission name'),
        initialValue: _name,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
        enabled: false,
      ),
      SizedBox(height: 50),
      TextFormField(
        decoration: InputDecoration(labelText: 'Location'),
        initialValue: _location != null ? '$_location' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        enabled: false,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Location can\'t be empty',
        onSaved: (value) => _location = value,
      ),
      SizedBox(height: 50),
      DateTimeFormField(
        enabled: false,
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
      _buildUsersStatic(context)
    ];
  }

  Widget _buildUsersStatic(BuildContext context) {
    final database = Provider.of<Repository>(context, listen: false);
    Mission? mission = widget.mission;

    if (mission!.attending.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: mission.attending.length,
        itemBuilder: (context, index) {
          final Future<User> user =
              FirebaseCrud.getUserByUid(mission.attending[index]);
          return FutureBuilder<User>(
            future: user,
            builder: (context, snapshot) {
              List<Widget> widgetChildren;
              if (snapshot.hasData) {
                widgetChildren = [
                  UserListTile(
                      user: snapshot.data!,
                      onTap: () => EditUserPage.show(context,
                          database: database, user: snapshot.data!))
                ];
              } else if (snapshot.hasError) {
                widgetChildren = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    //child: Text('Error: ${snapshot.error}'),
                    child: Text('No one attended'),
                  ),
                ];
              } else {
                widgetChildren = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ];
              }
              return Column(
                children: widgetChildren,
              );
            },
          );
        },
      );
    } else {
      return Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            //child: Text('Error: ${snapshot.error}'),
            child: Text('No one attended'),
          )
        ],
      );
    }
  }
}
