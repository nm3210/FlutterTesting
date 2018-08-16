/*
Name: apptest01_component
Author: Nathan P. Miller
Date Created:  July 22nd, 2018
Last Modified: July 24th, 2018

Comments: This app intends to be the first testing of the Flutter framework for
me and intends to be a simple input mechanism.
 */

import 'package:flutter/material.dart';

import 'gui/item_entry.dart';

import 'classes/BaseItem.dart';

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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text("Nate's AppTest"),
        ),
        body: new Builder(builder: buildBody));
  }

  Widget buildBody(BuildContext context) {
    return new SafeArea(
      child: new Center(
        child: new ListView(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 72.0),
          children: <Widget>[
            new RaisedButton(
              child: Text("Button: SnackBar"),
              onPressed: () {
                Scaffold.of(context).showSnackBar(
                      new SnackBar(
                        content: new Text("You pressed the snackbar button"),
                      ),
                    );
                debugPrint("I Was HERE");
              },
            ),
            new RaisedButton(
              child: Text("Button: Component Entry"),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute<DismissDialogAction>(
                      builder: (BuildContext context) =>
                      new ItemEntry(BaseItemType.Component),
                      fullscreenDialog: true,
                    ));
              },
            ),
            new RaisedButton(
              child: Text("Button: Equipment Entry"),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute<DismissDialogAction>(
                      builder: (BuildContext context) =>
                      new ItemEntry(BaseItemType.Equipment),
                      fullscreenDialog: true,
                    ));
              },
            ),
          ] // Add a little space between the buttons
              .map((Widget button) {
            return new Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: button);
          }).toList(),
        ),
      ),
    );
  }
}
