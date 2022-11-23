import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/pages/profile_page.dart';

import '../utils/user_settings.dart';

class FeedPage extends StatefulWidget{
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>{
  int _selectedIndex = 0;

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = UserSettings.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prepactive'),
      ),
      bottomNavigationBar: bottomNavigationBar(context),

    );


  }

  BottomNavigationBar bottomNavigationBar(BuildContext context){
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.feed,size: 40),
              label: 'Feed',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,size: 40),
              label: 'Profile',
              backgroundColor: Colors.blue),
        ],
      type: BottomNavigationBarType.shifting,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[200],
      onTap: _onItemTapped,
    );
  }
}