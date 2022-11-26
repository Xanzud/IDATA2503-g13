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
                if (snapshot.connectionState != ConnectionState.active) {
                  return Center(
                    child: const CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: Text("No data to load"),
                  );
                }

                final Iterable<User> usersData = snapshot.data!;

                return Column(
                  children: List.generate(usersData.length, (index) {
                    return Text(usersData.elementAt(index).name +
                        " : " +
                        usersData.elementAt(index).email);
                  }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
