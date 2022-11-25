/// Stores variables concerning the user
class User {
  String imagePath;
  String name;
  String address;
  String regNr;
  String email;
  String phoneNr;
  List<dynamic> certifications;
  String role;

  User(this.imagePath, this.name, this.address, this.regNr, this.email,
      this.phoneNr, this.certifications, this.role);

  static User fromMap(Map<String, dynamic> data) {
    assert(data.containsKey("name"), "Missing name property for a user");
    assert(data.containsKey("address"), "Missing address property for a user");
    assert(data.containsKey("regNr"), "Missing regNr property for a user");
    assert(data.containsKey("email"), "Missing email property for a user");
    assert(data.containsKey("phoneNr"), "Missing phoneNr property for a user");
    assert(data.containsKey("certifications"),
        "Missing certifications property for a user");
    assert(data.containsKey("role"), "Missing role property for a user");
    return User(data["imagePath"], data["name"], data["address"], data["regNr"],
        data["email"], data["phoneNr"], data["certifications"], data["role"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "imagePath": imagePath,
      "name": name,
      "address": address,
      "regNr": regNr,
      "email": email,
      "phoneNr": phoneNr,
      "certifications": certifications,
      "role": role,
    };
  }
}
