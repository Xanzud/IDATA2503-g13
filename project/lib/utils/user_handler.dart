import 'dart:math';

import 'package:project/model/user.dart';
import 'package:project/utils/user_settings.dart';

///Class for handeling user management, such as loading user data,
///and CRUD operations regarding user.

class UserHandler {
  ///Email used to sign in with. Intended for determining which user should be fetched from the database.
  static String _emailLoggedInWith = "";

  static void loadUser(){
    print("loadUser() called");
    updateCurrentUser(User("images/defaultProfilePic.jpg",
      "Thomas",
      "123 Fakestreet",
      "thomasey@stud.no",
      "",
      "12345678",
      [],
      "user"
      )
    );
  }

  static void updateCurrentUser(User newCurrentUser){
    UserSettings.currentUser = newCurrentUser;
    print(UserSettings.currentUser.name);
  }

  ///Returns the email used to sign in with.
  static String get getEmailSignedInWith {
    return _emailLoggedInWith;
  }

  ///Sets the email that was used to sign in with.
  static set setEmailSignedInWith(String email) => _emailLoggedInWith = email;
}