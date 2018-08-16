// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:apptest01_component/classes/DateTimeCustom.dart';
import 'package:apptest01_component/classes/BaseItem.dart';
import 'package:apptest01_component/gui/date_time_entry.dart';

class ItemEntry extends StatefulWidget {
  ItemEntry([BaseItemType itemTypeInput])
      : itemType = itemTypeInput,
        inputItem = BaseItem.of(itemType: itemTypeInput);

  ItemEntry.of([BaseItem inputItem])
      : itemType = inputItem.itemType,
        inputItem = inputItem;

  final BaseItemType itemType;
  final BaseItem inputItem;

  @override
  ItemEntryState createState() => new ItemEntryState(itemType, inputItem);
}

class ItemEntryState extends State<ItemEntry> {
  ItemEntryState([BaseItemType itemType, BaseItem inputItem]) {
    this.itemType = itemType;

    switch (this.itemType) {
      case BaseItemType.Component:
        typeName = 'component';
        break;
      case BaseItemType.Equipment:
        typeName = 'equipment';
        break;
      default:
        typeName = 'item';
        break;
    }

    if (inputItem != null) {
      _installDateTime = inputItem.installDateTime;
      _removalDateTime = inputItem.removalDateTime;
      _itemName = inputItem.itemName;
      _itemComment = inputItem.itemComment;

      _hasName = false; //(_itemName != null) && (_itemName.length > 0);
//      _hasComment = (_itemComment != null) && (_itemComment.length > 0);
      _saveNeeded = false;
    }
  }

  DateTimeCustom _installDateTime = DateTimeCustom.now();
  DateTimeCustom _removalDateTime = DateTimeCustom.now();
  String _itemName = '';
  String _itemLocation =
      ''; // NPM Note: to be changed to component/equipment list
  String _itemComment = '';

  BaseItemType itemType;
  String typeName;

  bool _saveNeeded = false;
  bool _hasName = false;
  bool _hasLocation = false;
  bool _hasComment = false;

  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = new TextEditingController(text: '$_itemName');
  }

  Future<bool> _onWillPop() async {
    _saveNeeded = _hasLocation || _hasName || _saveNeeded;
    if (!_saveNeeded) {
      debugPrint("No modifications noted, quitting...");
      return true;
    }

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle =
        theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              content: new Text('Discard new $typeName "$_itemName"?',
                  style: dialogTextStyle),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      debugPrint("Cancel discard item");
                      Navigator.of(context).pop(
                          false); // Pops the confirmation dialog but not the page.
                    }),
                new FlatButton(
                    child: const Text('DISCARD'),
                    onPressed: () {
                      debugPrint("Discard item");
                      Navigator.of(context).pop(
                          true); // Returning true to _onWillPop will pop again.
                    })
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
      appBar: new AppBar(
          title: new Text((_itemName != null) && (_itemName.length > 0)
              ? _itemName
              : '${typeName[0].toUpperCase()}${typeName.substring(1)} TBD'),
          actions: <Widget>[
            new FlatButton(
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                onPressed: () {
                  debugPrint("Trying to exit w/ save");
                  Navigator.of(context).pop(convertToItem(this));
                })
          ]),
      body: new Form(
          onWillPop: _onWillPop,
          child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                new Container(
                    padding: const EdgeInsets.only(top: 12.0),
//                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    alignment: Alignment.bottomLeft,
                    child: new TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                          labelText:
                              '${typeName[0].toUpperCase()}${typeName.substring(1)} name',
                          filled: true),
                      style: theme.textTheme.headline,
                      onChanged: (String value) {
                        setState(() {
                          _hasName = value.isNotEmpty;
                          if (_hasName) {
                            _itemName = value;
                          }
                        });
                      },
                    )),
                new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text('Install Date:', style: theme.textTheme.subhead),
                      new DateTimeEntry(
                          displayText: 'Since Beginning',
                          dateTime: _installDateTime,
                          onChanged: (DateTimeCustom value) {
                            setState(() {
                              _installDateTime = value;
                              _saveNeeded = true;
                            });
                          }),
                    ]),
                new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text('Removal Date:', style: theme.textTheme.subhead),
                      new DateTimeEntry(
                          displayText: 'Still Using!',
                          dateTime: _removalDateTime,
                          defaultOverride: true,
                          onChanged: (DateTimeCustom value) {
                            setState(() {
                              _removalDateTime = value;
                              _saveNeeded = true;
                            });
                          }),
                    ]),
                new Container(
//                    padding: const EdgeInsets.symmetric(vertical: 8.0),
//                    alignment: Alignment.bottomLeft,
                    child: new TextField(
                        decoration: const InputDecoration(
                            labelText: 'Location',
//                            hintText: 'Where is the event?',
                            filled: true),
                        onChanged: (String value) {
                          setState(() {
                            _hasLocation = value.isNotEmpty;
                            if (_hasLocation) {
                              _itemLocation = value;
                            }
                          });
                        })),
                new Container(
//                    padding: const EdgeInsets.symmetric(vertical: 8.0),
//                    alignment: Alignment.bottomLeft,
                    child: new TextField(
                        decoration: const InputDecoration(
                            labelText: 'Comments',
//                            hintText: 'Where is the event?',
                            filled: true),
                        onChanged: (String value) {
                          setState(() {
                            _hasComment = value.isNotEmpty;
                            if (_hasComment) {
                              _itemComment = value;
                            }
                          });
                        })),
              ].map((Widget child) {
                return new Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
//                    height: 96.0,
                    child: child);
              }).toList())),
    );
  }
}

BaseItem convertToItem(ItemEntryState itemEntry) {
  BaseItem outputItem;
  // Pull out input item and modify (instead of creating new object)
  if (itemEntry.widget.inputItem != null) {
    outputItem = itemEntry.widget.inputItem;
  } else {
    // Determine which type of item to make
    outputItem = BaseItem.of(itemType: itemEntry.itemType);
  }

  // Update item
  outputItem.installDateTime = itemEntry._installDateTime;
  outputItem.removalDateTime = itemEntry._removalDateTime;
  outputItem.itemName = itemEntry._itemName;
  outputItem.itemComment = itemEntry._itemComment;

  // Return
  return outputItem;
}
