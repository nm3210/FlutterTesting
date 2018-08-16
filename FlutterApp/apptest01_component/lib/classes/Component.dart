import 'package:apptest01_component/classes/BaseItem.dart';
import 'package:apptest01_component/classes/Equipment.dart';

class Component extends BaseItem {
  Component({Equipment equipmentReference})
      : equipmentReference = equipmentReference,
        super(itemType: BaseItemType.Component);

//  Component.returnItem(
//      {DateTimeCustom installDate,
//      DateTimeCustom removalDate,
//      String itemName,
//      String itemComment,
//      Equipment inputEquipmentRef})
//      : equipmentReference = inputEquipmentRef,
//        super.returnItem(
//            itemType: BaseItemType.Component,
//            installDate: installDate,
//            removalDate: removalDate,
//            itemName: itemName,
//            itemComment: itemComment);

  Equipment equipmentReference;
}
