// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:apptest01_component/classes/DateTimeCustom.dart';

import '../classes/BaseItem.dart';

// This demo is based on
// https://material.google.com/components/dialogs.html#dialogs-full-screen-dialogs

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class DateTimeItem extends StatefulWidget {
  DateTimeItem({Key key, String displayText, bool defaultOverride, DateTimeCustom dateTime, @required this.onChanged})
    : assert(onChanged != null),
      date = new DateTimeCustom(year: dateTime.year, month: dateTime.month, day: dateTime.day, hour: dateTime.hour, minute:dateTime.minute, specialCheck: (defaultOverride!=null) ? defaultOverride : dateTime.specialCheck),
      time = new TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      inputDisplayText = displayText;

  final DateTimeCustom date;
  final TimeOfDay time;
  final ValueChanged<DateTimeCustom> onChanged;
  final String inputDisplayText;

  @override
  DateTimeItemState createState() => new DateTimeItemState();
}

class DateTimeItemState extends State<DateTimeItem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new DefaultTextStyle(
      style: theme.textTheme.subhead,
      child: new Container(
        height: 42.0,
        child: new Row(
          mainAxisAlignment: (!widget.date.specialCheck) ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.start,
          children: <Widget>[
            (!widget.date.specialCheck) ? new Container(
              child: new Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: new BoxDecoration(
                  border: new Border(
                    bottom: new BorderSide(
                      color: theme.dividerColor,
                    ),
                  ),
                ),
                child: new InkWell(
                  onTap: () {
                    setState(() {
                      showDatePicker(
                        context: context,
                        initialDate: widget.date,
                        firstDate: widget.date.subtract(const Duration(days: 30)),
                        lastDate: widget.date.add(const Duration(days: 30))
                      ).then<Null>((DateTime value) {
                          if (value != null)
                            widget.onChanged(new DateTimeCustom(year: value.year, month: value.month, day: value.day, hour: widget.time.hour, minute: widget.time.minute));
                      });
                    });
                  },
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                          new DateFormat('EEE, MMM d yyyy').format(widget.date)),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ) : new Container(width: 0.0),
            (!widget.date.specialCheck) ? new Container(
              child: new Container(
                margin: const EdgeInsets.only(left: 8.0),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                width: 95.0,
                decoration: new BoxDecoration(
                  border: new Border(
                    bottom: new BorderSide(
                      color: theme.dividerColor,
                    ),
                  ),
                ),
                child: new InkWell(
                  onTap: () {
                    showTimePicker(
                      context: context,
                      initialTime: widget.time
                    ).then<Null>((TimeOfDay value) {
                        setState(() {
                          if (value != null)
                            widget.onChanged(new DateTimeCustom(year: widget.date.year, month: widget.date.month, day: widget.date.day, hour: value.hour, minute: value.minute));
                        });
                    });
                  },
                  child: new Row(
                    children: <Widget>[
                      new Text('${widget.time.format(context)}'),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ) : new Container(),
            new Container(
              margin: (widget.date.specialCheck) ? const EdgeInsets.only(left: 8.0): null,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  (!widget.date.specialCheck) ? new Text("Toggle") : new Text('${widget.inputDisplayText}'),
                  new Checkbox(
                    value: widget.date.specialCheck,
                      onChanged: (bool value) {
                        setState(() {
                          if (value != null) {
                            // NPM Note: This is not working, it looks like there needs to be some future call to get the setState to work correctly w/ the onChanged.
                            widget.date.specialCheck = value;
                          }
                        });
  //                      widget.onChanged(new DateTimeCustom(year: widget.date.year, month: widget.date.month, day: widget.date.day, hour: widget.time.hour, minute: widget.time.minute, specialCheck: value));
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemEntry extends StatefulWidget {
  ItemEntry([BaseItemType itemTypeInput]) : itemType = itemTypeInput;

  final BaseItemType itemType;

  @override
  ItemEntryState createState() => new ItemEntryState(itemType);
}

class ItemEntryState extends State<ItemEntry> {
  ItemEntryState([BaseItemType itemType]){
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

  }

  DateTimeCustom _installDateTime = DateTimeCustom.now();
  DateTimeCustom _removalDateTime = DateTimeCustom.now();
  String _itemName;
  String _itemLocation; // NPM Note: to be changed to component/equipment list
  String _itemComment;

  BaseItemType itemType;
  String typeName;

  bool _saveNeeded  = false;
  bool _hasName     = false;
  bool _hasLocation = false;
  bool _hasComment  = false;

  Future<bool> _onWillPop() async {
    _saveNeeded = _hasLocation || _hasName || _saveNeeded;
    if (!_saveNeeded) return true;

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
                      Navigator.of(context).pop(
                          false); // Pops the confirmation dialog but not the page.
                    }),
                new FlatButton(
                    child: const Text('DISCARD'),
                    onPressed: () {
                      Navigator.of(context).pop(
                          true); // Returning true to _onWillPop will pop again.
                    })
              ],
            );
          },
        ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
      appBar: new AppBar(
          title: new Text(_hasName ? _itemName : '${typeName[0].toUpperCase()}${typeName.substring(1)} TBD'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('SAVE',
                    style: theme.textTheme.body1.copyWith(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context, DismissDialogAction.save);
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
                        decoration: InputDecoration(
                            labelText: '${typeName[0].toUpperCase()}${typeName.substring(1)} name', filled: true),
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
                      new DateTimeItem(
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
                      new DateTimeItem(
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
