import 'package:project/model/packing_item.dart';

class MissionPackingCollectionBuilder {

  MissionPackingCollectionBuilder();

  List<PackingItem> buildList(String packingList) {
    List<PackingItem> returnList = [];
    switch(packingList) {
      case "Search and Rescue": {
        returnList.add(PackingItem("Warm Blankets", "First Shelf", 6, false));
        returnList.add(PackingItem("Hot Coffee", "Second Shelf", 2, false));
        returnList.add(PackingItem("Satellite Phone", "Second Shelf", 4, false));
        returnList.add(PackingItem("First Aid Kit", "Third Shelf", 6, false));
        break;
      }
    }
    return returnList;
  }
}