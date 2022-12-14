import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/packing_item.dart';
import '../services/firestore_repository.dart';
import '../services/repository.dart';

class packingListPage extends StatefulWidget {
  const packingListPage({Key? key, required this.itemCollectionId, required this.database})
    : super(key: key);
  final String itemCollectionId;
  final Repository? database;

  Future<void> show(BuildContext context,
      {required String itemCollectionId, Repository? database}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => packingListPage(itemCollectionId: itemCollectionId, database: database,),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _packingListPageState createState() => _packingListPageState();
}

class _packingListPageState extends State<packingListPage> {

  late final String itemCollectionId;
  late final Repository? database;
  late Map<String, bool> checkedMap = {};

  bool hasBeenInitialized = false;

  @override
  Widget build(BuildContext context) {

    if(hasBeenInitialized == false) {
      itemCollectionId = widget.itemCollectionId;
      database = widget.database;
      hasBeenInitialized = true;
    }

    return Provider<Repository>(
        create: (context) => FirestoreRepository(),
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text("Packing List"),
            ),
            body: _buildMainContent(context),
            );
        }
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(4),
      child: _buildList(),
    ));
  }

  Widget _buildList() {
    return StreamBuilder<Iterable<PackingItem>>(
        stream: database?.getItemCollectionForMission(itemCollectionId),
        builder: (context, snapshot) {



          // Error handling
          if (snapshot.connectionState != ConnectionState.active) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
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
            border: TableBorder.symmetric(inside: const BorderSide(style: BorderStyle.solid)),
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
      if(item.packed == true) {
        checkedMap[item.name] = true;
      }
      else {
        checkedMap[item.name] = false;
      }
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
              Text("Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
              Text("Shelf", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              Text("Number", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              Text("Packed?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              //Causes overflow error
              //Spacer(),
              //Text(_itemPacked(item.packed)),
              //Spacer(),
              Checkbox(
                checkColor: Colors.white,
                value: checkedMap[item.name],
                onChanged: (bool? value) {
                  checkPackedItem(itemCollectionId, item.id);
                  setState(() {
                    if(checkedMap[item.name] == false) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Item Packed!")));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Item Unpacked!")));
                    }
                    checkedMap[item.name] = value!;
                  });
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
    return "Not packed";
  }

  void checkPackedItem(String collectionId, String itemId)  {
     database!.updateItemAsPacked(collectionId, itemId);
  }
}
