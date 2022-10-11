import 'package:flutter/material.dart';
import 'package:project/authentication_service.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _landingPage(context),
    );
  }

  Widget _landingPage(BuildContext context) {
    return Scaffold(
      body: _body(context),
      appBar: AppBar(
        title: const Text("Landing Page"),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: Text(
              "Sign Out",
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[300]))
      ]),
    );
  }
}
