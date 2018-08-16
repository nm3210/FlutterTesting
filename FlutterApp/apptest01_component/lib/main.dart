/*
Name: apptest01_component
Author: Nathan P. Miller
Date Created:  July 22nd, 2018
Last Modified: August 13th, 2018

Comments: This app intends to be the first testing of the Flutter framework for
me and intends to be a simple input mechanism.
 */

import 'package:flutter/material.dart';
import 'package:apptest01_component/gui/item_entry.dart';
import 'package:apptest01_component/classes/BaseItem.dart';
import 'package:apptest01_component/classes/Component.dart';
import 'package:apptest01_component/classes/Equipment.dart';

void main() => runApp(new MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new AppTest(),
    );
  }
}

class AppTest extends StatefulWidget {
  @override
  AppTestState createState() => new AppTestState();
}

class AppTestState extends State<AppTest> {
  var lastComponentName = '';
  var lastEquipmentName = '';

  List<Widget> componentList = [];
  List<Widget> equipmentList = [];

  List<Component> componentList2 = [];
  List<Equipment> equipmentList2 = [];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text("Nate's AppTest"),
        ),
        body: new Builder(builder: buildBody));
  }

  Widget buildBody(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(
          child: Container(
            child: new ListView(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 72.0),
              children: <Widget>[
                new RaisedButton(
                  child: new RichText(
                    textAlign: TextAlign.center,
                    text: new TextSpan(
                      children: <TextSpan>[
                        new TextSpan(
                          text: 'Component Entry',
                          style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        new TextSpan(
                          text: '\nlast entry: $lastComponentName',
                          style: new TextStyle(
                            color: Colors.black,
//                          fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    launchItemEntry(context, itemType: BaseItemType.Component);
                  },
                ),
                new RaisedButton(
                  child: new RichText(
                    textAlign: TextAlign.center,
                    text: new TextSpan(
                      children: <TextSpan>[
                        new TextSpan(
                          text: 'Equipment Entry',
                          style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        new TextSpan(
                          text: '\nlast entry: $lastEquipmentName',
                          style: new TextStyle(
                            color: Colors.black,
//                          fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    launchItemEntry(context, itemType: BaseItemType.Equipment);
                  },
                ),
                new RaisedButton(
                  child: Text("Clear All"),
                  onPressed: () {
                    Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text("You cleared all items!"),
                        ));
                    debugPrint("Pressed button: Clear All");
                    setState(() {
                      componentList.clear();
                      equipmentList.clear();
                    });
                  },
                ),
              ].map((Widget buttons) {
                return new Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: buttons,
                );
              }).toList(),
            ),
          ),
        ),
        new Expanded(
          child: Container(
            child: new Column(
              children: <Widget>[
                Text("Components:"),
                new Expanded(
                  child: Container(
                    child: new ListView.builder(
                      itemBuilder: (context, index) {
                        return componentList[index];
                      },
                      itemCount: componentList.length,
                    ),
                  ),
                ),
              ],
            ),
            decoration: new BoxDecoration(
              border: new Border(
                top: new BorderSide(
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
        new Expanded(
          child: Container(
            child: new Column(
              children: <Widget>[
                Text("Equipment:"),
                new Expanded(
                  child: Container(
                    child: new ListView.builder(
                      itemBuilder: (context, index) {
                        return equipmentList[index];
                      },
                      itemCount: equipmentList.length,
                    ),
                  ),
                ),
              ],
            ),
            decoration: new BoxDecoration(
              border: new Border(
                top: new BorderSide(
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // A method that launches the SelectionScreen and awaits the result from
  // Navigator.pop!
  launchItemEntry(BuildContext context,
      {BaseItemType itemType, BaseItem inputItem}) async {
    // Navigator.push returns a Future that will complete after we call
    // Navigator.pop on the Selection Screen!
    BaseItem returnItem = await Navigator.push(
      context,
      new MaterialPageRoute<BaseItem>(
        builder: (context) => (inputItem != null)
            ? (ItemEntry.of(inputItem))
            : (ItemEntry(itemType)),
        fullscreenDialog: true,
      ),
    );

    if (returnItem == null || returnItem.itemName==' ' || returnItem.itemName=='') {
      debugPrint("Got item back: $returnItem");
      return;
    }

    debugPrint("Got item back: ${returnItem.itemName}");

    switch (returnItem.itemType) {
      case BaseItemType.Component:
        lastComponentName = returnItem.itemName;
        // Compare the new return item with the items in the list, is it the same one?
        if (componentList2 != null && componentList2.contains(returnItem)) {
          debugPrint("Found $lastComponentName within componentList2");
          return;
        }
        debugPrint("Adding $lastComponentName to componentList");
        componentList2.add(returnItem);
        setState(() {
          componentList.add(new ListTile(
              title: new Text(lastComponentName),
              onTap: () {
                launchItemEntry(context, inputItem: returnItem);
              }));
        });
        break;
      case BaseItemType.Equipment:
        lastEquipmentName = returnItem.itemName;
        // Compare the new return item with the items in the list, is it the same one?
        if (equipmentList2 != null && equipmentList2.contains(returnItem)) {
          debugPrint("Found $lastEquipmentName within equipmentList2");
          return;
        }
        debugPrint("Adding $lastEquipmentName to equipmentList");
        equipmentList2.add(returnItem);
        setState(() {
          equipmentList.add(new ListTile(
              title: new Text(lastEquipmentName),
              onTap: () {
                launchItemEntry(context, inputItem: returnItem);
              }));
        });
        break;
    }
  }
}
