class ApiPaths {
  /// Get document for a shop with given id
  static String mission(String missionId) => "missions/$missionId";
  static String archivedMission(String missionId) =>
      "missions_archived/$missionId";
  static String missionRoot() => "missions";
  static String archivedMissionRoot() => "missions_archive";
  static String userRoot() => "users";
}
