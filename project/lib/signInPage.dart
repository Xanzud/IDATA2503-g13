import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/authentication_service.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  //const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PrepActive"),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: _buildContent(context),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
    );
  }

  Widget _buildContent(BuildContext context) {
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
              controller: emailController,
              obscureText: false,
              decoration: InputDecoration(
                labelText: "Email",
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
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password", border: OutlineInputBorder())),
            SizedBox(height: 60),
            ElevatedButton(
                onPressed: () {
                  context.read<AuthenticationService>().signIn(
                      emailController.text.trim(),
                      passwordController.text.trim());
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white))
          ],
        ));
  }
}
