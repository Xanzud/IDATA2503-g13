import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/missions/mission_page.dart';
import 'package:project/missions/new_mission_page.dart';
import 'package:project/model/Mission.dart';
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
    final user = UserSettings.currentUser;
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
                padding: const EdgeInsets.fromLTRB(40, 100, 40, 40),
                child: _buildMissionInfoAll(context)),
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
              Icons.report,
              size: 50,
              color: Colors.red,
            ),
            label: 'Report',
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

  //TODO cleanup
  Widget _buildMissionInfo(BuildContext context) {
    const String missionId = "g1tXCcqtk1YSV45o9p6v";
    final repository = Provider.of<Repository>(context, listen: false);
    bool isChecked = false;

    return StreamBuilder<Mission?>(
        stream: repository.getMissionStream(missionId),
        builder: (context, snapshot) {
          // Check if we got something other than real data...
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

          // If we get so far, this means we got data!
          final Mission mission = snapshot.data!;

          return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    height: 150,
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
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(mission.name,
                                  style: TextStyle(color: Colors.red[300])),
                            )),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(mission.name,
                                  style: TextStyle(
                                      color: Colors.blue[700], fontSize: 18)),
                            )),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                              child: Row(
                                children: [
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 5,
                                    children: [
                                      Icon(Icons.access_time_outlined),
                                      Text(mission.time.toString()),
                                    ],
                                  ),
                                  Spacer(),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 5,
                                    children: [
                                      Text('Attend',
                                          style: TextStyle(fontSize: 16)),
                                      Checkbox(
                                        checkColor: Colors.white,
                                        value: isChecked,
                                        onChanged: (bool? value) {
                                          setState(() => isChecked = value!);
                                        },
                                      )
                                    ],
                                  )
                                ],
                              )),
                        ),
                      ],
                    )),
              ]);
        });
  }

  Widget _buildMissionInfoAll(BuildContext context) {
    final repository = Provider.of<Repository>(context, listen: false);
    bool isChecked = false;

    return StreamBuilder<Iterable<Mission>>(
        stream: repository.getAllMissionsStreamWithID(),
        builder: (context, snapshot) {
          // Check if we got something other than real data...
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

          // If we get so far, this means we got data!
          final Iterable<Mission> mission = snapshot.data!;

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
        height: 150,
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(name!, style: TextStyle(color: Colors.red[300])),
                )),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(name,
                          style:
                              TextStyle(color: Colors.blue[700], fontSize: 18)),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () =>
                              _onItemTapped(3, collectionId, database),
                          child: Text("Packing List",
                              style: TextStyle(color: Colors.white))),
                      Spacer(),
                      //ElevatedButton(
                      //    onPressed: () => _onItemTapped(4),
                      //    child: Icon(Icons.edit_note)),
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
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
                      Spacer(),
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

  Widget _buildMissionTitle(String missionName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        missionName,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  //TODO Cleanup
  /// Build the price text for the product
  Widget _buildMissionLocation(String location) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        "location: $location",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  /// Build the product image
  Widget _buildMissionTime(String time) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        "time: $time",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
