import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/missions/mission_page.dart';
import 'package:project/missions/new_mission_page.dart';
import 'package:project/missions/show_mission_page.dart';
import 'package:project/model/Mission.dart';
import 'package:project/pages/about_page.dart';
import 'package:project/pages/admin_page.dart';
import 'package:project/pages/packing_list_page.dart';
import 'package:project/pages/profile_page.dart';
import 'package:project/services/firebase_crud.dart';
import 'package:project/services/firestore_repository.dart';
import 'package:project/services/repository.dart';
import 'package:provider/provider.dart';

import '../missions/edit_mission_page.dart';
import '../utils/DateFormatter.dart';
import '../utils/user_settings.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index, [String? collectionId, Repository? database]) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ProfilePage();
        }));
      } else if (_selectedIndex == 1) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return AboutPage();
        }));
      } else if (_selectedIndex == 3) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return packingListPage(
              itemCollectionId: collectionId!, database: database);
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider<Repository>(
        create: (context) => FirestoreRepository(),
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 100,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text('Feed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  )),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
              child:
                  SingleChildScrollView(child: _buildMissionInfoAll(context)),
            ),
            bottomNavigationBar: Theme(
                data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent),
                child: bottomNavigationBar(context)),
          );
        });
  }

  BottomNavigationBar bottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 50,
              color: Colors.red,
            ),
            label: 'Profile',
            backgroundColor: Colors.white),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.info,
              size: 50,
              color: Colors.red,
            ),
            label: 'About',
            backgroundColor: Colors.white),
      ],
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.grey,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      onTap: _onItemTapped,
    );
  }

  Widget _buildMissionInfoAll(BuildContext context) {
    final repository = Provider.of<Repository>(context, listen: false);
    bool isChecked = false;

    return StreamBuilder<Iterable<Mission>>(
        stream: repository.getAllMissionsStreamWithID(),
        builder: (context, snapshot) {
          // Error handling
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

          final Iterable<Mission> mission = snapshot.data!;

          if (mission.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Nothing here.",
                    style:
                        const TextStyle(fontSize: 32.0, color: Colors.black54),
                  ),
                  Text(
                    "Add a new mission?",
                    style:
                        const TextStyle(fontSize: 16.0, color: Colors.black54),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(mission.length, (index) {
              return Padding(
                padding: EdgeInsets.all(20),
                child: _buildSingleMissionObject(
                    mission.elementAt(index).name,
                    mission.elementAt(index).time,
                    mission.elementAt(index).location,
                    mission.elementAt(index).itemCollectionId,
                    repository,
                    mission.elementAt(index)),
              );
            }),
          );
        });
  }

  Widget _buildSingleMissionObject(
      String? name,
      Timestamp time,
      String? location,
      String collectionId,
      Repository database,
      Mission mission) {
    bool isChecked;
    if (mission.attending.contains(FirebaseAuth.instance.currentUser!.uid)) {
      isChecked = true;
    } else {
      isChecked = false;
    }
    return Container(
        height: 210,
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 1,
                offset: Offset(1, 4),
              )
            ]),
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: <Widget>[
            Expanded(
                child: Padding(
              padding: EdgeInsets.fromLTRB(2, 10, 2, 0),
              child: Text(location!,
                  style: TextStyle(color: Colors.red[300], fontSize: 16)),
            )),
            Expanded(
                //alignment: Alignment.topLeft,
                child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
              child: Text(name!,
                  style: TextStyle(color: Colors.blue[700], fontSize: 18)),
            )),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                          onPressed: () =>
                              _onItemTapped(3, collectionId, database),
                          child: Text("Packing List",
                              style: TextStyle(color: Colors.white))),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return ShowMissionPage(
                                  database: database, mission: mission);
                            }));
                          },
                          child: Text("Show",
                              style: TextStyle(color: Colors.white))),
                      Spacer(),
                      //ElevatedButton(
                      //    onPressed: () => _onItemTapped(4),
                      //    child: Icon(Icons.edit_note)),
                    ],
                  )),
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
                  child: Row(
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 5,
                        children: [
                          Icon(Icons.access_time_outlined),
                          Text(DateFormatter.toRightFormat(
                              DateTime.fromMicrosecondsSinceEpoch(
                                  time.microsecondsSinceEpoch))),
                        ],
                      ),
                      const Spacer(),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 5,
                        children: [
                          Text('Attend', style: TextStyle(fontSize: 16)),
                          Checkbox(
                            checkColor: Colors.white,
                            value: isChecked,
                            onChanged: (bool? value) {
                              if (value! == true) {
                                try {
                                  final docMission = FirebaseFirestore.instance
                                      .collection("missions")
                                      .doc(mission.id);
                                  List<dynamic> attendingUsers =
                                      mission.attending;
                                  attendingUsers.add(
                                      FirebaseAuth.instance.currentUser!.uid);
                                  docMission.update({
                                    "attending": attendingUsers,
                                  });
                                } on FirebaseException catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.message!)));
                                }
                              } else {
                                try {
                                  final docMission = FirebaseFirestore.instance
                                      .collection("missions")
                                      .doc(mission.id);
                                  List<dynamic> attendingUsers =
                                      mission.attending;
                                  attendingUsers.remove(
                                      FirebaseAuth.instance.currentUser!.uid);
                                  docMission.update({
                                    "attending": attendingUsers,
                                  });
                                } on FirebaseException catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.message!)));
                                }
                              }

                              setState(() {});
                            },
                          )
                        ],
                      )
                    ],
                  )),
            ),
          ],
        ));
  }
}
