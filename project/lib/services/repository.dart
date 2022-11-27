import 'package:project/model/user.dart';

import '../model/Mission.dart';

abstract class Repository {
  /// Get a stream with mission snapshot for a specific mission with given ID
  Stream<Mission?> getMissionStream(String missionId);

  /// Get a stream with all the missions
  Stream<Iterable<Mission>> getAllMissionsStream();

  Future<void> createMission(Mission mission, String missionID);
  Future<void> deleteMission(Mission mission);

  Stream<Iterable<User>> getUsersStream();

  Stream<Mission> missionStream({required String missionId});

  Stream<Iterable<Mission>> getAllMissionsStreamWithID();
}
