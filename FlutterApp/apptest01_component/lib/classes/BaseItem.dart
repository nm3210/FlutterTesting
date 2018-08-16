import 'DateTimeCustom.dart';
import 'package:meta/meta.dart';

class BaseItem {
  BaseItem({@required BaseItemType itemType}) : _itemType = itemType;

  DateTimeCustom _installDateTime = DateTimeCustom.now();
  DateTimeCustom _removalDateTime = DateTimeCustom.now();
  String _itemName;
  String _itemComment;

  BaseItemType _itemType;
}

enum BaseItemType { Component, Equipment }
