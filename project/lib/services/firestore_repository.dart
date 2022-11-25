import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/model/Mission.dart';
import 'package:project/model/user.dart';
import 'package:project/services/firebase_crud.dart';
import '../../services/repository.dart';

import 'api_paths.dart';

class FirestoreRepository implements Repository {

  @override
  Stream<Iterable<Mission>> getAllMissionsStream() => FirebaseCrud()
      .getCollectionStream(ApiPaths.missionRoot(), Mission.fromMap);

  @override
  Stream<Mission?> getMissionStream(String missionId) => FirebaseCrud()
      .getDocumentStream(ApiPaths.mission(missionId), Mission.fromMap);

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
}
