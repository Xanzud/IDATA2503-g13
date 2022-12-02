import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/packing_item.dart';

class packingListPage extends StatefulWidget {
  @override
  _packingListPageState createState() => _packingListPageState();
}

class _packingListPageState extends State<packingListPage> {

  List<PackingItem> testList = [new PackingItem("test1", "Test shelf", 4, false, "id"),
    new PackingItem("test2", "Test shelf", 4, false, "id"),
    new PackingItem("test3", "Test shelf", 4, false, "id")
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text("Packing List"),
      ),
      body: _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildList(),
    ));
  }

  Widget _buildList() {
    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _buildRows(),
    );
  }

  List<TableRow> _buildRows() {
    return <TableRow>[
      TableRow(
        children: <Widget>[
          Container(
            height: 64,
            width: 128,
            child: Row(children: [
              Spacer(),
              Text("Name"),
              Spacer(),
            ],),
          ),
          Container(
            height: 64,
            width: 128,
            child: Row(children: [
              Spacer(),
              Text("Shelf"),
              Spacer(),
            ],),
          ),
          Container(
            height: 64,
            width: 128,
            child: Row(children: [
              Spacer(),
              Text("Number"),
              Spacer(),
            ],),
          ),
          Container(
            height: 64,
            width: 128,
            child: Row(children: [
              Spacer(),
              Text("Packed?"),
              Spacer(),
            ],),
          ),
        ],
      ),
      _buildSingleRow(testList[0])
    ];
  }


  TableRow _buildSingleRow(PackingItem item) {
    return TableRow(
      children: <Widget>[
        Container(
          height: 64,
          width: 128,
          child: Row(children: [
            Spacer(),
            Text(item.name),
            Spacer(),
          ],),
        ),
        Container(
          height: 64,
          width: 128,
          child: Row(children: [
            Spacer(),
            Text(item.shelf),
            Spacer(),
          ],),
        ),
        Container(
          height: 64,
          width: 128,
          child: Row(children: [
            Spacer(),
            Text(item.packed.toString()),
            Spacer(),
          ],),
        ),
        Container(
          height: 64,
          width: 128,
          child: Row(children: [
            Spacer(),
            Text(item.packed.toString()),
            Spacer(),
            Checkbox(
              checkColor: Colors.white,
              value: false, onChanged: (bool? value) {},
            ),
            Spacer(),
          ],),
        ),
      ],
    );
  }
}
