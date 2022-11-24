import 'package:flutter/material.dart';
import 'package:project/authentication_service.dart';
import 'package:project/model/Mission.dart';
import 'package:provider/provider.dart';

import 'services/repository.dart';

class LandingPage extends StatelessWidget {
  static const String missionId = "g1tXCcqtk1YSV45o9p6v";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _landingPage(context),
    );
  }

  Widget _landingPage(BuildContext context) {
    return Scaffold(
      body: _body(context),
      appBar: AppBar(
        title: const Text("Landing Page"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        ElevatedButton(
          onPressed: () {
            print("Testing packing list view");
          },
          child: Text(
            "packing list view",
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            print("Testing feedback view");
          },
          child: Text(
            "feedpack view",
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            print("Testing mission archeive view");
          },
          child: Text(
            "mission archeive view",
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            print("Testing mission overview view");
          },
          child: Text(
            "mission overview view",
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            print("Testing damage report view");
          },
          child: Text(
            "damage report view",
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: Text(
              "Sign Out",
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[300])),
        _buildMissionInfo(context)
      ]),
    );
  }

  Widget _buildMissionInfo(BuildContext context) {
    final repository = Provider.of<Repository>(context, listen: false);
    return StreamBuilder<Mission?>(
        stream: repository.getMissionStream(missionId),
        builder: (context, snapshot) {
          // Check if we got something other than real data...
          if (snapshot.connectionState != ConnectionState.active) {
            return const Text("Loading...");
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text("Loading...");
          }

          // If we get so far, this means we got data!
          final Mission mission = snapshot.data!;

          return Column(
            children: [
              _buildMissionTitle(mission.name),
              _buildMissionLocation(mission.location),
              _buildMissionTime(mission.time.toString()),
            ],
          );
        });
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
