import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _landingPage(),
    );
  }
  
  Widget _landingPage(){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Landing Page"),
      ),
    );
  }
}