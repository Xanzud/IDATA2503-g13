import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/missions/edit_mission_page.dart';
import 'package:project/missions/mission_entries_page.dart';
import 'package:project/missions/list_items_builder.dart';
import 'package:project/missions/mission_list_tile.dart';
import 'package:project/services/firebase_crud.dart';
import 'package:project/services/repository.dart';
import 'package:provider/provider.dart';

import '../model/Mission.dart';
import '../utils/show_exception_alert_dialog.dart';

class MissionPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Mission mission) async {
    try {
      final database = Provider.of<Repository>(context, listen: false);
      await FirebaseCrud.deleteMission(docId: "test");
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Missions'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => EditMissionPage.show(
              context,
              database: Provider.of<Repository>(context, listen: false),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Repository>(context, listen: false);
    return StreamBuilder<Iterable<Mission>>(
      stream: database.getAllMissionsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Mission>(
          snapshot: snapshot,
          itemBuilder: (context, mission) => Dismissible(
            key: Key('mission-${mission.name}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, mission),
            child: MissionListTile(
              mission: mission,
              onTap: () => MissionEntriesPage.show(context, mission),
            ),
          ),
        );
      },
    );
  }
}
