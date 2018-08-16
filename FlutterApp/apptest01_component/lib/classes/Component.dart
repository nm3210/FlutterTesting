import 'BaseItem.dart';
import 'Equipment.dart';

class Component extends BaseItem {
  Component() : super(itemType: BaseItemType.Component);

  Equipment equipmentReference;
}
