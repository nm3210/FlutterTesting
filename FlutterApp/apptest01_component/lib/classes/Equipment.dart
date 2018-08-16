import 'package:apptest01_component/classes/BaseItem.dart';
import 'package:apptest01_component/classes/Component.dart';

class Equipment extends BaseItem {
  Equipment({List<Component> componentList})
      : componentList = componentList,
        super(itemType: BaseItemType.Equipment);

//  Equipment.returnItem(
//      {DateTimeCustom installDate,
//      DateTimeCustom removalDate,
//      String itemName,
//      String itemComment,
//      List<Component> inputComponentRef})
//      : componentList = inputComponentRef,
//        super.returnItem(
//            itemType: BaseItemType.Equipment,
//            installDate: installDate,
//            removalDate: removalDate,
//            itemName: itemName,
//            itemComment: itemComment);

  List<Component> componentList;
}
