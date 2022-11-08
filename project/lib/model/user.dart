/// Stores variables concerning the user
class User {
  String imagePath;
  final String name;
  String address;
  String regNr;
  String email;
  String phoneNr;
  List<String> certifications;

  User({
    required this.imagePath,
    required this.name,
    required this.address,
    required this.regNr,
    required this.email,
    required this.phoneNr,
    required this.certifications,
    }
  );
}