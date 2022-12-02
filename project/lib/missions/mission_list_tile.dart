import 'package:flutter/material.dart';
import 'package:project/model/Mission.dart';

class MissionListTile extends StatelessWidget {
  const MissionListTile({Key? key, required this.mission, required this.onTap})
      : super(key: key);
  final Mission mission;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(mission.name +
          " " +
          mission.time.toDate().toUtc().toString() +
          "\n" +
          mission.attending.length.toString() +
          " attending"),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
