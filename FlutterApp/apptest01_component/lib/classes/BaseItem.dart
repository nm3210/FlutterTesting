
import 'package:apptest01_component/classes/DateTimeCustom.dart';
import 'package:apptest01_component/classes/Equipment.dart';
import 'package:apptest01_component/classes/Component.dart';
import 'package:meta/meta.dart';

class BaseItem {
  BaseItem({@required BaseItemType itemType}) : itemType = itemType {
    // Set default removal date
    this.removalDateTime.specialCheck = true;
  }

  static BaseItem of({@required BaseItemType itemType}) {
    switch (itemType) {
      case BaseItemType.Component:
        return new Component(equipmentReference: null);
        break;
      case BaseItemType.Equipment:
        return new Equipment(componentList: null);
        break;
    }
  }

  DateTimeCustom installDateTime = DateTimeCustom.now();
  DateTimeCustom removalDateTime = DateTimeCustom.now();
  String itemName = '';
  String itemComment = '';
  BaseItemType itemType;
}

enum BaseItemType { Component, Equipment }
