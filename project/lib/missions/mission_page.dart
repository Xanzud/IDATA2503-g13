import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/missions/edit_mission_page.dart';
import 'package:project/missions/mission_entries_page.dart';
import 'package:project/missions/list_items_builder.dart';
import 'package:project/missions/mission_list_tile.dart';
import 'package:project/missions/new_mission_page.dart';
import 'package:project/services/firebase_crud.dart';
import 'package:project/services/repository.dart';
import 'package:provider/provider.dart';

import '../model/Mission.dart';
import '../services/firestore_repository.dart';
import '../utils/show_exception_alert_dialog.dart';

class MissionPage extends StatelessWidget {
  const MissionPage({super.key});

  Future<void> _delete(BuildContext context, Mission mission) async {
    try {
      //final database = Provider.of<Repository>(context, listen: false);
      final docMission =
          FirebaseFirestore.instance.collection("missions").doc(mission.id);
      docMission.delete();
      FirebaseCrud.archiveMission(mission: mission);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Mission \'${mission.name}\' deleted and moved to archive')));
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<Repository>(
        create: (context) => FirestoreRepository(),
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Missions'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return newMissionPage();
                      }));
                    }),
              ],
            ),
            body: _buildContents(context),
          );
        });
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Repository>(context, listen: false);
    return StreamBuilder<Iterable<Mission>>(
      stream: database.getAllMissionsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Mission>(
          snapshot: snapshot,
          itemBuilder: (context, mission) => Dismissible(
            key: Key('mission-${mission.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _delete(context, mission);
            },
            child: MissionListTile(
                mission: mission,
                onTap: () => EditMissionPage.show(context,
                    database: database, mission: mission)),
          ),
        );
      },
    );
  }
}
