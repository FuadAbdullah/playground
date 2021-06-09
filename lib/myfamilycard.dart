import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _focusedIndex = 0;
  List<dynamic>? _jsonData;

  @override
  void initState() {
    super.initState();
    _jsonDecoder();
  }

  Future<void> _jsonDecoder() async {
    final response = await rootBundle.loadString("json/data.json");
    final data = json.decode(response);
    setState(() {
      _jsonData = data['data'];
    });
  }

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  Widget _buildItemDetail() {
    try {
      if (_jsonData!.length > _focusedIndex) {
        return Container(
          height: 30,
          child: Text("Index: $_focusedIndex"),
        );
      }
    } catch (Exception) {
      print("Handled delayed future load for Item Detail Loader.");
    }
    return Container(height: 30, child: Text("No data"));
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Container(
      width: 300,
      child: Card(
        color: Colors.white60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 250,
              child: Text(
                "ID: ${_jsonData![index]['id']}",
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
              child: Divider(
                color: Colors.black12,
                thickness: 1.0,
              ),
            ),
            Container(
              width: 250,
              child: Text(
                "Name: ${_jsonData![index]['name']}",
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: 250,
              child: Text(
                "Age: ${_jsonData![index]['age']}",
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: 250,
              child: Text(
                "Occupation: ${_jsonData![index]['occupation']}",
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _dirtySnapScrollListLoader() {
    try {
      return ScrollSnapList(
        dynamicItemSize: true,
        onItemFocus: _onItemFocus,
        itemSize: 300,
        itemBuilder: _buildListItem,
        itemCount: _jsonData!.length,
      );
    } catch (Exception) {
      print("Handled delayed future load for Snap Scroll.");
    }
    return Container(height: 0, width: 0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Family Information",
      home: Scaffold(
        appBar: AppBar(
          title: Text("My Family Information"),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: _dirtySnapScrollListLoader(),
              )
              ,
              _buildItemDetail(),
            ],
          )
        ),
      ),
    );
  }
}
