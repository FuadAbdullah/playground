import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List _data = [];
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i <= 100; i++) {
      popData();
    }
  }

  void popData() {
    var rnd = Random().nextInt(100);
    if (rnd >= 10) {
      _data.add(rnd);
    } else {
      _data.add(rnd + 10);
    }
  }

  void delData() {
    _data.removeAt(_focusedIndex);
    _onItemFocus(_focusedIndex - 1);
  }

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  Widget _buildItemDetail() {
    if (_data.length > _focusedIndex) {
      return Container(
          height: 150,
          child: Text("index $_focusedIndex: ${_data[_focusedIndex]}"));
    }
    return Container(height: 150, child: Text("No data."));
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Container(
        width: 35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
                height: _data[index].toDouble() * 2,
                width: 30,
                color: Colors.lightBlueAccent,
                child: Center(child: Text("i:$index\n${_data[index]}")))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Horizontal List Demo",
        home: Scaffold(
            appBar: AppBar(title: Text("Horizontal List")),
            body: Container(
                child: Column(
              children: <Widget>[
                Expanded(
                    child: ScrollSnapList(
                        onItemFocus: _onItemFocus,
                        itemSize: 35,
                        itemBuilder: _buildListItem,
                        itemCount: _data.length,
                        reverse: false)),
                _buildItemDetail(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            popData();
                          });
                        },
                        child: Text("Add Item")),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            delData();
                          });
                        },
                        child: Text("Remove Item"))
                  ],
                )
              ],
            ))));
  }
}
