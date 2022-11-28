import 'package:project/model/user.dart';
import 'package:project/utils/user_settings.dart';

///Class for handeling user management, such as loading user data,
///and CRUD operations regarding user.

class UserHandler {

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

}