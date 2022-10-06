import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PrepActive"),
        elevation: 2.0,
      ),
      body: _buildContent(),
      backgroundColor: Colors.red,
    );
  }

  Widget _buildContent() {
    return Container(
        padding: EdgeInsets.all(25),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            SizedBox(child: Image.asset("images/icon01.png")),
            SizedBox(height: 40),
            Text(
              "Username",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Password",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
                obscureText: true,
                decoration: InputDecoration(border: OutlineInputBorder())),
            SizedBox(height: 60),
            ElevatedButton(
                onPressed: () => _signIn(),
                child: Text("Login", style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white))
          ],
        ));
  }

  void _signIn() {

  }
}
