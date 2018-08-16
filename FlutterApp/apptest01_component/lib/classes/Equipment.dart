import 'BaseItem.dart';
import 'Component.dart';

class Equipment extends BaseItem {
  Equipment() : super(itemType: BaseItemType.Equipment);

  List<Component> componentList;
}
