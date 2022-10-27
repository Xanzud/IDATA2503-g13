class Mission{
  final String name;
  final String time;
  final String location;

  Mission(this.name, this.time,this.location);

  static Mission fromMap(Map<String, dynamic> data){
    assert(data.containsKey("name"), "Missing name property for a mission");
    assert(data.containsKey("time"), "Missing time property for a mission");
    assert(data.containsKey("location"),
    "Missing location property for a mission");
    return Mission(data["name"], data["time"], data["location"]);
  }
}