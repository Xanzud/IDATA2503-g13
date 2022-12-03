import 'package:flutter/material.dart';
import 'package:project/model/Mission.dart';
import 'package:project/model/user.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({Key? key, required this.user, required this.onTap})
      : super(key: key);
  final User user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity(horizontal: 3),
      title: Text(user.name + " : " + user.email),
      leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: (user.imagePath == "")
              ? NetworkImage(
                  "https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png")
              : NetworkImage(user.imagePath)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
