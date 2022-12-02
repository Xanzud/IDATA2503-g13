import 'dart:async';
import 'dart:html';

import 'package:project/model/Mission.dart';
import 'package:project/model/user.dart';
import 'package:project/services/firebase_crud.dart';
import '../../services/repository.dart';

import 'api_paths.dart';

class FirestoreRepository implements Repository {
  @override
  Stream<Iterable<Mission>> getAllMissionsStream() => FirebaseCrud()
      .getCollectionStream(ApiPaths.missionRoot(), Mission.fromMapOriginal);

  @override
  Stream<Mission?> getMissionStream(String missionId) => FirebaseCrud()
      .getDocumentStream(ApiPaths.mission(missionId), Mission.fromMapOriginal);

  @override
  Future<void> createMission(Mission mission, String missionID) =>
      FirebaseCrud().setData(
        path: ApiPaths.missionRoot() + missionID,
        data: mission.toMap(),
      );

  @override
  Stream<Iterable<User>> getUsersStream() {
    return FirebaseCrud()
        .getCollectionStream(ApiPaths.userRoot(), User.fromMap);
  }

  /// Retrieves all missions together with the ID
  @override
  Stream<Iterable<Mission>> getAllMissionsStreamWithID() =>
      FirebaseCrud().collectionStreamWithID(
          builder: (data, documentID) =>
              Mission.fromMapFactory(data, documentID));

  @override
  Future<void> deleteMission(Mission mission) async {
    FirebaseCrud.deleteMission(docId: mission.id);
  }

  @override
  Stream<Mission> missionStream({required String missionId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveMission(Mission mission) async {
    FirebaseCrud.saveMission(mission);
  }

  @override
  Future<void> delete(
      {required String collection, required String docId}) async {
    FirebaseCrud.delete(collection: collection, docId: docId);
  }

  @override
  Stream<Iterable<Mission>> getAllArchivedMissionsStream() =>
      FirebaseCrud().getCollectionStream(
          ApiPaths.archivedMissionRoot(), Mission.fromMapOriginal);

  @override
  Stream<Mission?> missionArchivedStream({required String missionId}) =>
      FirebaseCrud().getDocumentStream(
          ApiPaths.archivedMission(missionId), Mission.fromMapOriginal);

  @override
  Stream<Iterable<User>> getUsersStreamFromMission(String missionID) {
    // TODO: implement getUsersStreamFromMission
    throw UnimplementedError();
  }
}
