import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/model/user.dart';
import 'package:project/services/repository.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<Repository>(context, listen: false);
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<Iterable<User>>(
              stream: repository.getUsersStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == null) {
                  final docs = snapshot.data?.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: docs!.length,
                    itemBuilder: (context, index) {
                      final user = docs[index].data();
                      return ListTile(
                        title: Text(user['name'] ?? user['email']),
                      );
                    },
                  );
                }
                return Center(
                  child: Text("No users"),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
