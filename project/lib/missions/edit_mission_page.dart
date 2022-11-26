import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditMissionPage extends StatefulWidget {
  EditMissionPage({required String missionId}) : super();

  late String missionID;

  @override
  _EditMissionPageState createState() => _EditMissionPageState();
}

class _EditMissionPageState extends State<EditMissionPage>  {

  @override
  Widget build(BuildContext context, ) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text("New Mission"),
      ),
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(),
              )
          ),
        )
    );
  }
}
