import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/missions/mission_archive_page.dart';
import 'package:project/missions/mission_page.dart';
import 'package:project/missions/new_mission_page.dart';
import 'package:project/model/user.dart';
import 'package:project/pages/users_page.dart';
import 'package:project/services/firestore_repository.dart';
import 'package:project/services/repository.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Provider<Repository>(
        create: (context) => FirestoreRepository(),
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Admin Page"),
            ),
            body: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[_buildNav(), _buildBody()],
                ),
              ),
            ),
          );
        });
  }
}

class _buildNav extends StatelessWidget {
  const _buildNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        SizedBox(height: 50),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return newMissionPage();
              }));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, padding: EdgeInsets.all(20)),
            child: Text("New Mission",
                style: TextStyle(color: Colors.black, fontSize: 20))),
        SizedBox(height: 50),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MissionArchivePage();
              }));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, padding: EdgeInsets.all(20)),
            child: Text("Mission archive",
                style: TextStyle(color: Colors.black, fontSize: 20))),
        SizedBox(height: 50),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MissionPage();
              }));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, padding: EdgeInsets.all(20)),
            child: Text("Active missions",
                style: TextStyle(color: Colors.black, fontSize: 20))),
        SizedBox(height: 50),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return UsersPage();
              }));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, padding: EdgeInsets.all(20)),
            child: Text("Users",
                style: TextStyle(color: Colors.black, fontSize: 20))),
      ]),
    );
  }
}

class _buildBody extends StatelessWidget {
  const _buildBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<Repository>(context, listen: false);
    return StreamBuilder<Iterable<User>>(
      stream: repository.getUsersStream(),
      builder: (context, snapshot) {
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

        final Iterable<User> usersData = snapshot.data!;

        return Center(
            child: Column(
          children: [
            /*
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("Users", style: TextStyle(fontSize: 16)),
            ),
            
            Column(
              children: List.generate(usersData.length, (index) {
                return Text(usersData.elementAt(index).name +
                    " : " +
                    usersData.elementAt(index).email);
              }),
            ),
            */
          ],
        ));
      },
    );
  }
}
