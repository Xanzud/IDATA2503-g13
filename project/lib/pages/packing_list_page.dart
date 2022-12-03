import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/packing_item.dart';
import '../services/firestore_repository.dart';
import '../services/repository.dart';

class packingListPage extends StatefulWidget {
  @override
  _packingListPageState createState() => _packingListPageState();
}

class _packingListPageState extends State<packingListPage> {

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<Repository>(context, listen: false);
    return Provider<Repository>(
        create: (context) => FirestoreRepository(),
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text("Packing List"),
            ),
            body: _buildMainContent(context),

            //TODO Just for testing
            floatingActionButton: FloatingActionButton(onPressed: () { },
            ),
          );
        });
  }

  Widget _buildMainContent(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildList(),
    ));
  }

  Widget _buildList() {
    final repository = Provider.of<Repository>(context, listen: false);

    return StreamBuilder<Iterable<PackingItem>>(
        stream: repository.getItemCollectionForMission(),
        builder: (context, snapshot) {



          // Error handling
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

          final Iterable<PackingItem> itemCollection = snapshot.data!;

          return Table(
            border: TableBorder.all(),
            columnWidths: const <int, TableColumnWidth>{},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: _buildItemRows(itemCollection)
          );
        });
  }

  List<TableRow> _buildItemRows(Iterable<PackingItem> itemCollection) {
    List<TableRow> returnList = <TableRow>[];

    returnList.add(_buildInfoRow());

    for(var item in itemCollection) {
      returnList.add(_buildSingleRow(item));
    }

    return returnList;
  }

  TableRow _buildInfoRow() {
    return TableRow(
      children: <Widget>[
        Container(
          height: 64,
          width: 128,
          child: Row(
            children: [
              Spacer(),
              Text("Name"),
              Spacer(),
            ],
          ),
        ),
        Container(
          height: 64,
          width: 128,
          child: Row(
            children: [
              Spacer(),
              Text("Shelf"),
              Spacer(),
            ],
          ),
        ),
        Container(
          height: 64,
          width: 128,
          child: Row(
            children: [
              Spacer(),
              Text("Number"),
              Spacer(),
            ],
          ),
        ),
        Container(
          height: 64,
          width: 128,
          child: Row(
            children: [
              Spacer(),
              Text("Packed?"),
              Spacer(),
            ],
          ),
        ),

      ],
    );
  }

  TableRow _buildSingleRow(PackingItem item) {
    return TableRow(
      children: <Widget>[
        Container(
          height: 64,
          width: 128,
          child: Row(
            children: [
              Spacer(),
              Text(item.name),
              Spacer(),
            ],
          ),
        ),
        Container(
          height: 64,
          width: 128,
          child: Row(
            children: [
              Spacer(),
              Text(item.shelf),
              Spacer(),
            ],
          ),
        ),
        Container(
          height: 64,
          width: 128,
          child: Row(
            children: [
              Spacer(),
              Text(item.count.toString()),
              Spacer(),
            ],
          ),
        ),
        Container(
          height: 64,
          width: 128,
          child: Row(
            children: [
              Spacer(),
              Text(_itemPacked(item.packed)),
              Spacer(),
              Checkbox(
                checkColor: Colors.white,
                value: false,
                onChanged: (bool? value) {
                  value: true;
                  checkPackedItem();
                  },
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }
  
  String _itemPacked(bool packed) {
    if(packed) {
      return "Packed";
    }
    else return "Not packed";
  }

  void checkPackedItem() {

  }
}
