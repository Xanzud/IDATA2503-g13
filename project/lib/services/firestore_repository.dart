import 'dart:async';

import 'package:project/model/Mission.dart';
import 'package:project/model/user.dart';
import 'package:project/services/firebase_crud.dart';
import '../../services/repository.dart';

import 'api_paths.dart';

class FirestoreRepository implements Repository {

  //TODO Temporarily disabled i guess, use getAllMissionsStreamWithID() instead
/*
  @override
  Stream<Iterable<Mission>> getAllMissionsStream() => FirebaseCrud()
      .getCollectionStream(ApiPaths.missionRoot(), Mission.fromMap);

  @override
  Stream<Mission?> getMissionStream(String missionId) => FirebaseCrud()
      .getDocumentStream(ApiPaths.mission(missionId), Mission.fromMap);
*/
  @override
  Future<void> createMission(Mission mission, String missionID) =>
      FirebaseCrud().setData(
        path: ApiPaths.missionRoot() + missionID,
        data: mission.toMap(),
      );

  @override
  Stream<Iterable<User>> getUsersStream() {
    return FirebaseCrud().getCollectionStream(
        ApiPaths.userRoot(), User.fromMap);
  }

  /// Retrieves all missions together with the ID
  @override
  Stream<Iterable<Mission>> getAllMissionsStreamWithID() => FirebaseCrud().collectionStreamWithID(
      builder: (data, documentID) => Mission.fromMapFactory(data, documentID),
  );

  //TODO placeholders, too tired to remove atm.
  @override
  Stream<Iterable<Mission>> getAllMissionsStream() {
    // TODO: implement getAllMissionsStream
    throw UnimplementedError();
  }

  @override
  Stream<Mission?> getMissionStream(String missionId) {
    // TODO: implement getMissionStream
    throw UnimplementedError();
  }
}
