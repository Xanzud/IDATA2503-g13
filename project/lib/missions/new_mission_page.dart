import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/model/packing_list.dart';
import 'package:project/services/firebase_crud.dart';
import 'package:provider/provider.dart';

import '../services/firestore_repository.dart';
import '../services/repository.dart';

class newMissionPage extends StatefulWidget {
  @override
  _newMissionPageState createState() => _newMissionPageState();
}

class _newMissionPageState extends State<newMissionPage> {
  final _formKey = GlobalKey<FormState>();
  late final List<String> _packingLists = [];

  //TODO CLEANUP
  String? _name;
  Timestamp? _time;
  String? _location;
  String? _chosenPacketList;

  String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
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
    if (_location == null ||
        _time == null ||
        _name == null ||
        _chosenPacketList == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Fill the form before submitting'),
        backgroundColor: Colors.red,
      ));
      return;
    } else {
      var response = await FirebaseCrud.createMission(
          location: _location!,
          name: _name!,
          time: _time!,
          packingList: _chosenPacketList!);

      if (response.code != 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.message.toString())));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.message.toString()),
          backgroundColor: Colors.red,
        ));
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
              title: Text("New Mission"),
            ),
            body: _buildContents(context),
          );
        });
  }

  Widget _buildContents(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildForm(context),
      )),
    ));
  }

  Widget _buildForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(context),
        ));
  }

  List<Widget> _buildFormChildren(BuildContext context) {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: "Name"),
        onChanged: (value) {
          setState(() {
            _name = value;
          });
        },
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
        mode: DateTimeFieldPickerMode.dateAndTime,
        autovalidateMode: AutovalidateMode.always,
        //validator: (e) =>
        //(e?.day ?? 0) == 1 ? 'Please not the first day' : null,
        onDateSelected: (DateTime value) {
          setState(() {
            _time = Timestamp.fromMicrosecondsSinceEpoch(
                value.microsecondsSinceEpoch);
          });
        },
      ),
      SizedBox(height: 50),
      TextFormField(
        decoration: InputDecoration(labelText: "Location"),
        onChanged: (value) {
          _location = value;
        },
      ),
      SizedBox(height: 50),
      Text("Packing List"),
      _buildPacketSelector(context),
      Padding(
          padding: EdgeInsets.all(120),
          child: ElevatedButton(
            onPressed: _submit,
            child: Text("Submit",
                style: TextStyle(fontSize: 18, color: Colors.white)),
          )),
    ];
  }

  //Packet List selector setup

  Widget _buildPacketSelector(BuildContext context) {
    final repository = Provider.of<Repository>(context, listen: false);

    return StreamBuilder<Iterable<PackingList>>(
        stream: repository.getPackingLists(),
        builder: (context, snapshot) {
          if (_packingLists.isEmpty) {
            //Error handling
            if (snapshot.connectionState != ConnectionState.active) {
              return Center(
                child: const CircularProgressIndicator.adaptive(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text("No data to load"),
              );
            }

            final Iterable<PackingList> snapShotData = snapshot.data!;

            for (var entry in snapShotData) {
              _packingLists.add(entry.name);
            }
          }

          return DropdownButton<String>(
            hint: const Text("Choose Packing List"),
            items: _packingLists
                .map<DropdownMenuItem<String>>((String packetListsValue) {
              return DropdownMenuItem<String>(
                  value: packetListsValue, child: Text(packetListsValue));
            }).toList(),
            onChanged: _packetDropDownSelector,
            value: _chosenPacketList,
          );
        });
  }

  void _packetDropDownSelector(String? newValue) {
    setState(() {
      _chosenPacketList = newValue;
    });
  }
}
