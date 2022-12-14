import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project/missions/edit_mission_page.dart';
import 'package:project/missions/list_items_builder.dart';
import 'package:project/model/Mission.dart';
import 'package:project/services/firestore_repository.dart';
import 'package:project/services/repository.dart';
import 'package:project/utils/show_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

class MissionEntriesPage extends StatelessWidget {
  const MissionEntriesPage({required this.database, required this.mission});
  final Repository? database;
  final Mission? mission;

  static Future<void> show(BuildContext context, Mission mission) async {
    final database = Provider.of<Repository>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) =>
            MissionEntriesPage(database: database, mission: mission),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider<Repository>(
      create: (context) => FirestoreRepository(),
      builder: (context, child) {
        final database = Provider.of<Repository>(context, listen: false);
        return StreamBuilder<Mission?>(
            stream: database.getMissionStream(mission!.id),
            builder: (context, snapshot) {
              final mission = snapshot.data;
              final missionName = mission?.name ?? 'cant find';
              return Scaffold(
                appBar: AppBar(
                  elevation: 2.0,
                  title: Text(missionName),
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () => EditMissionPage.show(
                        context,
                        database: database,
                        mission: mission,
                      ),
                    ),
                  ],
                ),
                //body: _buildContent(context, mission!),
              );
            });
      },
    );
  }
}
