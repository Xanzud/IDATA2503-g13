import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/model/Mission.dart';
import 'package:project/services/firestore_service.dart';
import '../../services/repository.dart';

import 'api_paths.dart';

class FirestoreRepository implements Repository {
  final FirebaseFirestore store = FirebaseFirestore.instance;
  final _service = FirestoreService.instance;

  @override
  Stream<Iterable<Mission>> getAllMissionsStream() => _service
      .getCollectionStream(ApiPaths.missionRoot(), Mission.fromMap, store);

  @override
  Stream<Mission?> getMissionStream(String missionId) => _service
      .getDocumentStream(ApiPaths.mission(missionId), Mission.fromMap, store);

  @override
  Future<void> createMission(Mission mission, String missionID) =>
      _service.setData(
        path: ApiPaths.missionRoot() + missionID,
        data: mission.toMap(),
      );

  @override
  Stream<Iterable<Mission>> getUsersStream() {
    return _service.getCollectionStream(
        ApiPaths.userRoot(), Mission.fromMap, store);
  }
}
