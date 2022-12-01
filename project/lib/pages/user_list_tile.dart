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
      title: Text(user.name + " : " + user.email),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
