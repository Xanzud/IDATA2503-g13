import '../model/user.dart';

class UserSettings{
  static User currentUser = User(
    imagePath: "https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80",
    name: "Jane Doe",
    address: "123 Fakestreet",
    regNr: "eu12345",
    email: "jane@doe.com",
    phoneNr: "10101010",
    certifications: [],
    role: "user"
  );
}