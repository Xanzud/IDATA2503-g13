import 'package:flutter/material.dart';
import 'package:project/model/Mission.dart';

class MissionListTileArchived extends StatelessWidget {
  const MissionListTileArchived(
      {Key? key, required this.mission, required this.onTap})
      : super(key: key);
  final Mission mission;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    String attendingStr = "No one attended this mission";
    if (mission.attending.isEmpty) {
      attendingStr = "No one attended this mission";
    } else {
      attendingStr = "${mission.attending.length} attending";
    }

    return ListTile(
      title: Text(mission.name +
          " " +
          mission.time.toDate().toUtc().toString() +
          "\n" +
          attendingStr),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
