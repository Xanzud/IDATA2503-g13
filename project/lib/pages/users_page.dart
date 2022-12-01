import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/missions/edit_mission_page.dart';
import 'package:project/missions/mission_entries_page.dart';
import 'package:project/missions/list_items_builder.dart';
import 'package:project/missions/mission_list_tile.dart';
import 'package:project/missions/new_mission_page.dart';
import 'package:project/model/user.dart';
import 'package:project/pages/edit_user_page.dart';
import 'package:project/pages/user_list_tile.dart';
import 'package:project/services/firebase_crud.dart';
import 'package:project/services/repository.dart';
import 'package:provider/provider.dart';

import '../model/Mission.dart';
import '../services/firestore_repository.dart';
import '../utils/show_exception_alert_dialog.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  Future<void> _delete(BuildContext context, User user) async {
    try {
      //final database = Provider.of<Repository>(context, listen: false);
      final docMission =
          FirebaseFirestore.instance.collection("users").doc(user.uid);
      docMission.delete();
      FirebaseCrud.delete(collection: "users", docId: user.uid);
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
              title: Text('Users'),
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
    return StreamBuilder<Iterable<User>>(
      stream: database.getUsersStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<User>(
          snapshot: snapshot,
          itemBuilder: (context, user) => Dismissible(
            key: Key('mission-${user.uid}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _delete(context, user);
            },
            child: UserListTile(
                user: user,
                onTap: () =>
                    EditUserPage.show(context, database: database, user: user)),
          ),
        );
      },
    );
  }
}
