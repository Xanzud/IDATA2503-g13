import 'package:project/model/packing_item.dart';
import 'package:project/model/user.dart';

import '../model/Mission.dart';
import '../model/packing_list.dart';

abstract class Repository {
  /// Get a stream with mission snapshot for a specific mission with given ID
  Stream<Mission?> getMissionStream(String missionId);

  // Missions
  /// Get a stream with all the missions
  Stream<Iterable<Mission>> getAllMissionsStream();
  Stream<Mission> missionStream({required String missionId});
  Stream<Iterable<Mission>> getAllMissionsStreamWithID();
  Future<void> createMission(Mission mission, String missionID);
  Future<void> deleteMission(Mission mission);
  //Archived missions
  Stream<Iterable<Mission>> getAllArchivedMissionsStream();
  Stream<Mission?> missionArchivedStream({required String missionId});
  //Users
  Stream<Iterable<User>> getUsersStream();

  //Packing lists
  Stream<Iterable<PackingList>> getPackingLists();

  //Item collection for missions
  Stream<Iterable<PackingItem>> getItemCollectionForMission(String itemCollectionId);

  //Generic
  Future<void> delete({required String collection, required String docId});
}
