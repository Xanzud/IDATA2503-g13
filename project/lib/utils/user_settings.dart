import '../model/user.dart';

///Class for storing settings and information on the current user.
///For anything regarding changing this information, see the user_handler class.
class UserSettings {
  static User currentUser = User(
      "images/defaultProfilePic.jpg",
      "Jane Doe",
      "123 Fakestreet",
      "eu12345",
      "jane@doe.com",
      "10101010",
      [],
      "user",
      "uid:test");
}

//old profile pic from web
//"https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80"
