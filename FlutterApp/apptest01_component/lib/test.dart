import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Counter(),
    );
  }
}

class Counter extends StatefulWidget {
  // This class is the configuration for the state. It holds the
  // values (in this nothing) provided by the parent and used by the build
  // method of the State. Fields in a Widget subclass are always marked "final".

  @override
  CounterState createState() => CounterState();
}

class CounterState extends State<Counter> {
  int _counter = 0;

  List<Widget> testList = [
    ListTile(
      leading: Icon(Icons.map),
      title: Text('Map'),
    ),
    ListTile(
      leading: Icon(Icons.photo_album),
      title: Text('Album'),
    ),
    ListTile(
      leading: Icon(Icons.phone),
      title: Text('Phone'),
    ),
  ];

  void _increment() {
    setState(() {
      // This call to setState tells the Flutter framework that
      // something has changed in this State, which causes it to rerun
      // the build method below so that the display can reflect the
      // updated values. If we changed _counter without calling
      // setState(), then the build method would not be called again,
      // and so nothing would appear to happen.
      _counter++;

      // NPM Note 2018-07-25 - this does not seem to update the GUI properly
//      testList[2] = ListTile(
//        leading: Icon(Icons.phone),
//        title: Text('Phone $_counter'),
//      );
//      testList.clear();
      testList.add(new ListTile(title: new Text('Item $_counter')));
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance
    // as done by the _increment method above.
    // The Flutter framework has been optimized to make rerunning
    // build methods fast, so that you can just rebuild anything that
    // needs updating rather than having to individually change
    // instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('NPM Testing'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _increment,
      ),
      body: new Container(
        alignment: Alignment.center,
        child: new Column(
          children: [
            new Text("blahblah"),
            new Expanded(
              child: Container(
                child: new ListView.builder(
                  itemBuilder: (context, index) {
                    return testList[index];
                  },
                  itemCount: testList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
